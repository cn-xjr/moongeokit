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
  items : Array[SpatialItem]
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
fn GridSpatialIndex::column_for(
  self : GridSpatialIndex,
  x : Double,
) -> Int {
  if self.world.width() <= 0.0 {
    return 0
  }
  let raw = (
    (x - self.world.min_x) / self.world.width() *
    self.columns.to_double()
  ).to_int()
  clamp_int(raw, 0, self.columns - 1)
}

///|
fn GridSpatialIndex::row_for(self : GridSpatialIndex, y : Double) -> Int {
  if self.world.height() <= 0.0 {
    return 0
  }
  let raw = (
    (y - self.world.min_y) / self.world.height() *
    self.rows.to_double()
  ).to_int()
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
pub fn GridSpatialIndex::query_point(
  self : GridSpatialIndex,
  point : Point,
) -> SpatialQueryResult {
  if !self.world.contains(point) {
    return { items: [], candidates_scanned: 0, buckets_visited: 0 }
  }
  let bucket = self.buckets[
    self.bucket_index(self.column_for(point.x), self.row_for(point.y))
  ]
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
  {
    items: result,
    candidates_scanned: candidates,
    buckets_visited: visited,
  }
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
