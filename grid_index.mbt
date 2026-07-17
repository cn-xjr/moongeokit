///|
/// Query output with performance evidence exposed to callers and benchmarks.
pub(all) struct SpatialQueryResult {
  items : Array[SpatialItem]
  candidates_scanned : Int
  buckets_visited : Int
} derive(Debug)

///|
/// A fixed-world uniform grid index for editor, map, and simulation workloads.
///
/// Items spanning several cells are stored in each covered bucket. Queries
/// deduplicate candidates before applying exact AABB tests.
pub(all) struct GridSpatialIndex {
  world : Bounds
  columns : Int
  rows : Int
  mut items : Array[SpatialItem]
  buckets : Array[Array[Int]]
} derive(Debug)

///|
pub fn GridSpatialIndex::new(
  world : Bounds,
  columns : Int,
  rows : Int,
) -> GridSpatialIndex {
  let safe_columns = if columns < 1 { 1 } else { columns }
  let safe_rows = if rows < 1 { 1 } else { rows }
  let buckets : Array[Array[Int]] = []
  for i = 0; i < safe_columns * safe_rows; i = i + 1 {
    buckets.push([])
  }
  { world, columns: safe_columns, rows: safe_rows, items: [], buckets }
}

///|
pub fn GridSpatialIndex::length(self : GridSpatialIndex) -> Int {
  self.items.length()
}

///|
fn GridSpatialIndex::column_for(self : GridSpatialIndex, x : Double) -> Int {
  if self.world.width() <= 0.0 {
    return 0
  }
  let raw = ((x - self.world.min_x) /
  self.world.width() *
  self.columns.to_double()).to_int()
  clamp_int(raw, 0, self.columns - 1)
}

///|
fn GridSpatialIndex::row_for(self : GridSpatialIndex, y : Double) -> Int {
  if self.world.height() <= 0.0 {
    return 0
  }
  let raw = ((y - self.world.min_y) /
  self.world.height() *
  self.rows.to_double()).to_int()
  clamp_int(raw, 0, self.rows - 1)
}

///|
fn GridSpatialIndex::bucket_index(
  self : GridSpatialIndex,
  column : Int,
  row : Int,
) -> Int {
  row * self.columns + column
}

///|
/// Inserts an item when its bounds overlap the configured world.
pub fn GridSpatialIndex::insert(
  self : GridSpatialIndex,
  item : SpatialItem,
) -> Bool {
  if !self.world.intersects(item.bounds) {
    return false
  }
  let item_index = self.items.length()
  self.items.push(item)
  let min_column = self.column_for(item.bounds.min_x)
  let max_column = self.column_for(item.bounds.max_x)
  let min_row = self.row_for(item.bounds.min_y)
  let max_row = self.row_for(item.bounds.max_y)
  for row = min_row; row <= max_row; row = row + 1 {
    for column = min_column; column <= max_column; column = column + 1 {
      self.buckets[self.bucket_index(column, row)].push(item_index)
    }
  }
  true
}

///|
/// Inserts every in-world item and returns the number accepted. This is the
/// preferred ingestion API for tiles, entity snapshots, and GeoJSON features.
pub fn GridSpatialIndex::insert_many(
  self : GridSpatialIndex,
  items : Array[SpatialItem],
) -> Int {
  let mut inserted = 0
  for item in items {
    if self.insert(item) {
      inserted = inserted + 1
    }
  }
  inserted
}

///|
/// Removes the first item with `id` and rebuilds bucket membership.
///
/// Rebuilding is deterministic and keeps deletion semantics simple for map
/// editors where the index is updated less often than it is queried.
pub fn GridSpatialIndex::remove(self : GridSpatialIndex, id : Int) -> Bool {
  let index = self.item_index(id)
  if index < 0 {
    return false
  }
  let last = self.items.unsafe_pop()
  if index < self.items.length() {
    self.items[index] = last
  }
  self.rebuild_buckets()
  true
}

///|
/// Replaces an item's bounds and refreshes its covered grid buckets.
pub fn GridSpatialIndex::update(
  self : GridSpatialIndex,
  id : Int,
  bounds : Bounds,
) -> Bool {
  let index = self.item_index(id)
  if index < 0 || !self.world.intersects(bounds) {
    return false
  }
  self.items[index] = SpatialItem::new(id, bounds)
  self.rebuild_buckets()
  true
}

///|
/// Applies a batch of id/bounds replacements and rebuilds bucket membership
/// once. Invalid ids and bounds outside the configured world are skipped.
pub fn GridSpatialIndex::update_many(
  self : GridSpatialIndex,
  items : Array[SpatialItem],
) -> Int {
  let mut changed = 0
  for item in items {
    let index = self.item_index(item.id)
    if index >= 0 && self.world.intersects(item.bounds) {
      self.items[index] = item
      changed = changed + 1
    }
  }
  if changed > 0 {
    self.rebuild_buckets()
  }
  changed
}

///|
/// Removes every item whose id occurs in `ids` and rebuilds once. The result
/// is the number of records actually removed, not the number of requested ids.
pub fn GridSpatialIndex::remove_many(
  self : GridSpatialIndex,
  ids : Array[Int],
) -> Int {
  let retained : Array[SpatialItem] = []
  let mut removed = 0
  for item in self.items {
    let mut should_remove = false
    for id in ids {
      if item.id == id {
        should_remove = true
      }
    }
    if should_remove {
      removed = removed + 1
    } else {
      retained.push(item)
    }
  }
  if removed > 0 {
    self.items = retained
    self.rebuild_buckets()
  }
  removed
}

///|
pub fn GridSpatialIndex::contains_id(self : GridSpatialIndex, id : Int) -> Bool {
  self.item_index(id) >= 0
}

///|
fn GridSpatialIndex::item_index(self : GridSpatialIndex, id : Int) -> Int {
  for i = 0; i < self.items.length(); i = i + 1 {
    if self.items[i].id == id {
      return i
    }
  }
  -1
}

///|
fn GridSpatialIndex::rebuild_buckets(self : GridSpatialIndex) -> Unit {
  for i = 0; i < self.buckets.length(); i = i + 1 {
    self.buckets[i] = []
  }
  for item_index = 0
      item_index < self.items.length()
      item_index = item_index + 1 {
    let bounds = self.items[item_index].bounds
    let min_column = self.column_for(bounds.min_x)
    let max_column = self.column_for(bounds.max_x)
    let min_row = self.row_for(bounds.min_y)
    let max_row = self.row_for(bounds.max_y)
    for row = min_row; row <= max_row; row = row + 1 {
      for column = min_column; column <= max_column; column = column + 1 {
        self.buckets[self.bucket_index(column, row)].push(item_index)
      }
    }
  }
}

///|
pub fn GridSpatialIndex::query_point(
  self : GridSpatialIndex,
  point : Point,
) -> SpatialQueryResult {
  if !self.world.contains(point) {
    return { items: [], candidates_scanned: 0, buckets_visited: 0 }
  }
  let bucket = self.buckets[self.bucket_index(
      self.column_for(point.x),
      self.row_for(point.y),
    )]
  let result : Array[SpatialItem] = []
  for i = 0; i < bucket.length(); i = i + 1 {
    let item = self.items[bucket[i]]
    if item.bounds.contains(point) {
      result.push(item)
    }
  }
  { items: result, candidates_scanned: bucket.length(), buckets_visited: 1 }
}

///|
pub fn GridSpatialIndex::query_bounds(
  self : GridSpatialIndex,
  query : Bounds,
) -> SpatialQueryResult {
  if !self.world.intersects(query) {
    return { items: [], candidates_scanned: 0, buckets_visited: 0 }
  }
  let min_column = self.column_for(query.min_x)
  let max_column = self.column_for(query.max_x)
  let min_row = self.row_for(query.min_y)
  let max_row = self.row_for(query.max_y)
  let seen = Array::make(self.items.length(), false)
  let result : Array[SpatialItem] = []
  let mut candidates = 0
  let mut visited = 0
  for row = min_row; row <= max_row; row = row + 1 {
    for column = min_column; column <= max_column; column = column + 1 {
      visited = visited + 1
      let bucket = self.buckets[self.bucket_index(column, row)]
      for i = 0; i < bucket.length(); i = i + 1 {
        let item_index = bucket[i]
        if !seen[item_index] {
          seen[item_index] = true
          candidates = candidates + 1
          let item = self.items[item_index]
          if item.bounds.intersects(query) {
            result.push(item)
          }
        }
      }
    }
  }
  { items: result, candidates_scanned: candidates, buckets_visited: visited }
}

///|
/// Finds the closest indexed bounds within `max_distance` of `point`.
///
/// It uses a bounded grid query before exact point-to-AABB distance tests, so
/// map clients can keep a stable interaction radius without scanning the whole
/// world. `None` means no candidate overlaps the search envelope.
pub fn GridSpatialIndex::query_nearest(
  self : GridSpatialIndex,
  point : Point,
  max_distance : Double,
) -> SpatialItem? {
  if max_distance < 0.0 {
    return None
  }
  let candidates = self.query_bounds(
    Bounds::new(
      point.x - max_distance,
      point.y - max_distance,
      point.x + max_distance,
      point.y + max_distance,
    ),
  )
  let mut nearest : SpatialItem? = None
  let mut distance = max_distance
  for item in candidates.items {
    let candidate_distance = item.bounds.distance_to_point(point)
    if candidate_distance <= distance {
      distance = candidate_distance
      nearest = Some(item)
    }
  }
  nearest
}

///|
fn clamp_int(value : Int, min : Int, max : Int) -> Int {
  if value < min {
    min
  } else if value > max {
    max
  } else {
    value
  }
}
