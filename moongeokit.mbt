///|
pub(all) struct Point {
  x : Double
  y : Double
} derive(Debug)

///|
pub(all) struct Segment {
  start : Point
  end : Point
} derive(Debug)

///|
pub(all) struct Bounds {
  min_x : Double
  min_y : Double
  max_x : Double
  max_y : Double
} derive(Debug)

///|
pub(all) struct Polygon {
  points : Array[Point]
} derive(Debug)

///|
pub(all) struct Polyline {
  points : Array[Point]
} derive(Debug)

///|
pub(all) struct SpatialItem {
  id : Int
  bounds : Bounds
} derive(Debug)

///|
pub(all) struct SpatialIndex {
  items : Array[SpatialItem]
} derive(Debug)

///|
pub(all) struct GeometrySummary {
  points : Int
  segments : Int
  polygons : Int
  bounds : Bounds
} derive(Debug)

///|
pub fn Point::new(x : Double, y : Double) -> Point {
  { x, y }
}

///|
pub fn Segment::new(start : Point, end : Point) -> Segment {
  { start, end }
}

///|
pub fn Bounds::new(
  min_x : Double,
  min_y : Double,
  max_x : Double,
  max_y : Double,
) -> Bounds {
  {
    min_x: min_double(min_x, max_x),
    min_y: min_double(min_y, max_y),
    max_x: max_double(min_x, max_x),
    max_y: max_double(min_y, max_y),
  }
}

///|
pub fn Bounds::from_points(points : Array[Point]) -> Bounds {
  if points.length() == 0 {
    return Bounds::new(0.0, 0.0, 0.0, 0.0)
  }
  let mut min_x = points[0].x
  let mut max_x = points[0].x
  let mut min_y = points[0].y
  let mut max_y = points[0].y
  for i = 1; i < points.length(); i = i + 1 {
    min_x = min_double(min_x, points[i].x)
    max_x = max_double(max_x, points[i].x)
    min_y = min_double(min_y, points[i].y)
    max_y = max_double(max_y, points[i].y)
  }
  Bounds::new(min_x, min_y, max_x, max_y)
}

///|
pub fn Polygon::new(points : Array[Point]) -> Polygon {
  { points, }
}

///|
pub fn Polyline::new(points : Array[Point]) -> Polyline {
  { points, }
}

///|
pub fn Point::add(self : Point, other : Point) -> Point {
  Point::new(self.x + other.x, self.y + other.y)
}

///|
pub fn Point::sub(self : Point, other : Point) -> Point {
  Point::new(self.x - other.x, self.y - other.y)
}

///|
pub fn Point::scale(self : Point, factor : Double) -> Point {
  Point::new(self.x * factor, self.y * factor)
}

///|
pub fn Point::dot(self : Point, other : Point) -> Double {
  self.x * other.x + self.y * other.y
}

///|
pub fn Point::cross(self : Point, other : Point) -> Double {
  self.x * other.y - self.y * other.x
}

///|
pub fn Point::length(self : Point) -> Double {
  self.dot(self).sqrt()
}

///|
pub fn Point::distance_to(self : Point, other : Point) -> Double {
  self.sub(other).length()
}

///|
pub fn orientation(a : Point, b : Point, c : Point) -> Double {
  b.sub(a).cross(c.sub(a))
}

///|
fn min_double(a : Double, b : Double) -> Double {
  if a < b {
    a
  } else {
    b
  }
}

///|
fn max_double(a : Double, b : Double) -> Double {
  if a > b {
    a
  } else {
    b
  }
}

///|
pub fn point_on_segment(point : Point, segment : Segment) -> Bool {
  point_on_segment_eps(point, segment, 0.000000001)
}

///|
pub fn segments_intersect(a : Segment, b : Segment) -> Bool {
  segments_intersect_eps(a, b, 0.000000001)
}

///|
fn clamp_double(value : Double, min : Double, max : Double) -> Double {
  if value < min {
    min
  } else if value > max {
    max
  } else {
    value
  }
}

///|
pub fn closest_point_on_segment(point : Point, segment : Segment) -> Point {
  let ab = segment.end.sub(segment.start)
  let ap = point.sub(segment.start)
  let denom = ab.dot(ab)
  if denom == 0.0 {
    return segment.start
  }
  let t = clamp_double(ap.dot(ab) / denom, 0.0, 1.0)
  segment.start.add(ab.scale(t))
}

///|
pub fn distance_to_segment(point : Point, segment : Segment) -> Double {
  point.distance_to(closest_point_on_segment(point, segment))
}

///|
pub fn Bounds::width(self : Bounds) -> Double {
  self.max_x - self.min_x
}

///|
pub fn Bounds::height(self : Bounds) -> Double {
  self.max_y - self.min_y
}

///|
pub fn Bounds::contains(self : Bounds, point : Point) -> Bool {
  point.x >= self.min_x &&
  point.x <= self.max_x &&
  point.y >= self.min_y &&
  point.y <= self.max_y
}

///|
pub fn Bounds::intersects(self : Bounds, other : Bounds) -> Bool {
  self.min_x <= other.max_x &&
  self.max_x >= other.min_x &&
  self.min_y <= other.max_y &&
  self.max_y >= other.min_y
}

///|
pub fn Bounds::union(self : Bounds, other : Bounds) -> Bounds {
  Bounds::new(
    min_double(self.min_x, other.min_x),
    min_double(self.min_y, other.min_y),
    max_double(self.max_x, other.max_x),
    max_double(self.max_y, other.max_y),
  )
}

///|
/// Returns the Euclidean distance from a point to this axis-aligned bounds.
/// The result is zero when the point is inside or on the bounds.
pub fn Bounds::distance_to_point(self : Bounds, point : Point) -> Double {
  let x = clamp_double(point.x, self.min_x, self.max_x)
  let y = clamp_double(point.y, self.min_y, self.max_y)
  point.distance_to(Point::new(x, y))
}

///|
pub fn Segment::bounds(self : Segment) -> Bounds {
  Bounds::new(self.start.x, self.start.y, self.end.x, self.end.y)
}

///|
pub fn Polygon::vertex_count(self : Polygon) -> Int {
  self.points.length()
}

///|
pub fn Polygon::bounds(self : Polygon) -> Bounds {
  Bounds::from_points(self.points)
}

///|
pub fn Polygon::signed_area(self : Polygon) -> Double {
  if self.points.length() < 3 {
    return 0.0
  }
  let mut total = 0.0
  for i = 0; i < self.points.length(); i = i + 1 {
    let next = (i + 1) % self.points.length()
    total = total +
      self.points[i].x * self.points[next].y -
      self.points[next].x * self.points[i].y
  }
  total / 2.0
}

///|
pub fn Polygon::area(self : Polygon) -> Double {
  let area = self.signed_area()
  if area < 0.0 {
    -area
  } else {
    area
  }
}

///|
pub fn Polygon::perimeter(self : Polygon) -> Double {
  if self.points.length() < 2 {
    return 0.0
  }
  let mut total = 0.0
  for i = 0; i < self.points.length(); i = i + 1 {
    let next = (i + 1) % self.points.length()
    total = total + self.points[i].distance_to(self.points[next])
  }
  total
}

///|
pub fn Polygon::centroid_average(self : Polygon) -> Point {
  if self.points.length() == 0 {
    return Point::new(0.0, 0.0)
  }
  let mut x = 0.0
  let mut y = 0.0
  for i = 0; i < self.points.length(); i = i + 1 {
    x = x + self.points[i].x
    y = y + self.points[i].y
  }
  Point::new(
    x / self.points.length().to_double(),
    y / self.points.length().to_double(),
  )
}

///|
/// Computes the area-weighted centroid of a polygon ring.
///
/// Degenerate rings have no stable area centroid, so their vertex average is
/// returned instead. This makes the function suitable for editor previews and
/// GeoJSON data that may contain line-like polygons.
pub fn Polygon::centroid(self : Polygon) -> Point {
  if self.points.length() < 3 {
    return self.centroid_average()
  }
  let mut twice_area = 0.0
  let mut x = 0.0
  let mut y = 0.0
  for i = 0; i < self.points.length(); i = i + 1 {
    let next = (i + 1) % self.points.length()
    let cross = self.points[i].x * self.points[next].y -
      self.points[next].x * self.points[i].y
    twice_area = twice_area + cross
    x = x + (self.points[i].x + self.points[next].x) * cross
    y = y + (self.points[i].y + self.points[next].y) * cross
  }
  if twice_area == 0.0 {
    return self.centroid_average()
  }
  Point::new(x / (3.0 * twice_area), y / (3.0 * twice_area))
}

///|
pub fn Polygon::contains_point(self : Polygon, point : Point) -> Bool {
  if self.points.length() < 3 {
    return false
  }
  let mut inside = false
  let mut j = self.points.length() - 1
  for i = 0; i < self.points.length(); i = i + 1 {
    let pi = self.points[i]
    let pj = self.points[j]
    let edge = Segment::new(pj, pi)
    if point_on_segment(point, edge) {
      return true
    }
    let crosses = (pi.y > point.y) != (pj.y > point.y)
    if crosses {
      let x_at_y = (pj.x - pi.x) * (point.y - pi.y) / (pj.y - pi.y) + pi.x
      if point.x < x_at_y {
        inside = !inside
      }
    }
    j = i
  }
  inside
}

///|
fn leftmost_index(points : Array[Point]) -> Int {
  let mut index = 0
  for i = 1; i < points.length(); i = i + 1 {
    if points[i].x < points[index].x ||
      (points[i].x == points[index].x && points[i].y < points[index].y) {
      index = i
    }
  }
  index
}

///|
pub fn convex_hull(points : Array[Point]) -> Polygon {
  let hull : Array[Point] = []
  if points.length() < 3 {
    for i = 0; i < points.length(); i = i + 1 {
      hull.push(points[i])
    }
    return Polygon::new(hull)
  }
  let start = leftmost_index(points)
  let mut current = start
  let mut closed = false
  let mut steps = 0
  while !closed && steps <= points.length() {
    hull.push(points[current])
    let mut next = (current + 1) % points.length()
    for candidate = 0; candidate < points.length(); candidate = candidate + 1 {
      let turn = orientation(points[current], points[next], points[candidate])
      if turn < 0.0 ||
        (
          turn == 0.0 &&
          points[current].distance_to(points[candidate]) >
          points[current].distance_to(points[next])
        ) {
        next = candidate
      }
    }
    current = next
    if current == start {
      closed = true
    }
    steps = steps + 1
  }
  Polygon::new(hull)
}

///|
pub fn Polyline::length(self : Polyline) -> Double {
  if self.points.length() < 2 {
    return 0.0
  }
  let mut total = 0.0
  for i = 1; i < self.points.length(); i = i + 1 {
    total = total + self.points[i - 1].distance_to(self.points[i])
  }
  total
}

///|
pub fn Polyline::bounds(self : Polyline) -> Bounds {
  Bounds::from_points(self.points)
}

///|
pub fn Polyline::closest_point(self : Polyline, point : Point) -> Point {
  if self.points.length() == 0 {
    return Point::new(0.0, 0.0)
  }
  if self.points.length() == 1 {
    return self.points[0]
  }
  let mut best = self.points[0]
  let mut best_distance = point.distance_to(best)
  for i = 1; i < self.points.length(); i = i + 1 {
    let candidate = closest_point_on_segment(
      point,
      Segment::new(self.points[i - 1], self.points[i]),
    )
    let distance = point.distance_to(candidate)
    if distance < best_distance {
      best = candidate
      best_distance = distance
    }
  }
  best
}

///|
pub fn Polyline::distance_to(self : Polyline, point : Point) -> Double {
  point.distance_to(self.closest_point(point))
}

///|
pub fn Polyline::simplify_by_distance(
  self : Polyline,
  min_distance : Double,
) -> Polyline {
  let simplified : Array[Point] = []
  if self.points.length() == 0 {
    return Polyline::new(simplified)
  }
  simplified.push(self.points[0])
  let mut last = self.points[0]
  for i = 1; i < self.points.length(); i = i + 1 {
    if last.distance_to(self.points[i]) >= min_distance ||
      i == self.points.length() - 1 {
      simplified.push(self.points[i])
      last = self.points[i]
    }
  }
  Polyline::new(simplified)
}

///|
pub fn SpatialItem::new(id : Int, bounds : Bounds) -> SpatialItem {
  { id, bounds }
}

///|
pub fn SpatialIndex::new() -> SpatialIndex {
  { items: [] }
}

///|
pub fn SpatialIndex::from_items(items : Array[SpatialItem]) -> SpatialIndex {
  { items, }
}

///|
pub fn SpatialIndex::insert(self : SpatialIndex, item : SpatialItem) -> Unit {
  self.items.push(item)
}

///|
pub fn SpatialIndex::query_bounds(
  self : SpatialIndex,
  bounds : Bounds,
) -> Array[SpatialItem] {
  let result : Array[SpatialItem] = []
  for item in self.items {
    if item.bounds.intersects(bounds) {
      result.push(item)
    }
  }
  result
}

///|
pub fn SpatialIndex::query_point(
  self : SpatialIndex,
  point : Point,
) -> Array[SpatialItem] {
  let result : Array[SpatialItem] = []
  for item in self.items {
    if item.bounds.contains(point) {
      result.push(item)
    }
  }
  result
}

///|
pub fn SpatialIndex::bounds(self : SpatialIndex) -> Bounds {
  if self.items.length() == 0 {
    return Bounds::new(0.0, 0.0, 0.0, 0.0)
  }
  let mut bounds = self.items[0].bounds
  for i = 1; i < self.items.length(); i = i + 1 {
    bounds = bounds.union(self.items[i].bounds)
  }
  bounds
}

///|
pub fn GeometrySummary::new(
  points : Int,
  segments : Int,
  polygons : Int,
  bounds : Bounds,
) -> GeometrySummary {
  { points, segments, polygons, bounds }
}

///|
pub fn GeometrySummary::to_json(self : GeometrySummary) -> String {
  "{\"points\":\{self.points},\"segments\":\{self.segments},\"polygons\":\{self.polygons},\"bounds\":\{self.bounds.to_json()}}"
}

///|
pub fn Point::to_json(self : Point) -> String {
  "{\"x\":\{self.x},\"y\":\{self.y}}"
}

///|
pub fn Bounds::to_json(self : Bounds) -> String {
  "{\"min_x\":\{self.min_x},\"min_y\":\{self.min_y},\"max_x\":\{self.max_x},\"max_y\":\{self.max_y}}"
}

///|
pub fn Polygon::to_json(self : Polygon) -> String {
  let buf = StringBuilder()
  buf.write_string("{\"points\":[")
  for i = 0; i < self.points.length(); i = i + 1 {
    if i > 0 {
      buf.write_char(',')
    }
    buf.write_string(self.points[i].to_json())
  }
  buf.write_string("]}")
  buf.to_string()
}

///|
pub fn SpatialItem::to_json(self : SpatialItem) -> String {
  "{\"id\":\{self.id},\"bounds\":\{self.bounds.to_json()}}"
}

///|
/// Encodes a point as a GeoJSON geometry object. Coordinates intentionally
/// remain numeric so the output can be passed directly to a Web/Wasm client.
pub fn Point::to_geojson(self : Point) -> String {
  "{\"type\":\"Point\",\"coordinates\":[\{self.x},\{self.y}]}"
}

///|
/// Encodes a polyline as a GeoJSON LineString geometry object.
pub fn Polyline::to_geojson(self : Polyline) -> String {
  let buf = StringBuilder()
  buf.write_string("{\"type\":\"LineString\",\"coordinates\":[")
  for i = 0; i < self.points.length(); i = i + 1 {
    if i > 0 {
      buf.write_char(',')
    }
    let point = self.points[i]
    buf.write_string("[\{point.x},\{point.y}]")
  }
  buf.write_string("]}")
  buf.to_string()
}

///|
/// Encodes a polygon as a GeoJSON Polygon geometry object. GeoJSON requires
/// a closed exterior ring; this function closes a non-empty ring on export.
pub fn Polygon::to_geojson(self : Polygon) -> String {
  let buf = StringBuilder()
  buf.write_string("{\"type\":\"Polygon\",\"coordinates\":[[")
  for i = 0; i < self.points.length(); i = i + 1 {
    if i > 0 {
      buf.write_char(',')
    }
    let point = self.points[i]
    buf.write_string("[\{point.x},\{point.y}]")
  }
  if self.points.length() > 0 {
    let first = self.points[0]
    buf.write_string(",[\{first.x},\{first.y}]")
  }
  buf.write_string("]]}")
  buf.to_string()
}

///|
/// Encodes bounds as a GeoJSON Polygon geometry object.
pub fn Bounds::to_geojson(self : Bounds) -> String {
  Polygon::new([
    Point::new(self.min_x, self.min_y),
    Point::new(self.max_x, self.min_y),
    Point::new(self.max_x, self.max_y),
    Point::new(self.min_x, self.max_y),
  ]).to_geojson()
}

///|
/// Encodes an indexed bounds record as a GeoJSON Feature with a numeric id.
pub fn SpatialItem::to_geojson_feature(self : SpatialItem) -> String {
  "{\"type\":\"Feature\",\"id\":\{self.id},\"properties\":{},\"geometry\":\{self.bounds.to_geojson()}}"
}

///|
pub fn SpatialIndex::to_json(self : SpatialIndex) -> String {
  let bounds = self.bounds()
  "{\"items\":\{self.items.length()},\"bounds\":\{bounds.to_json()}}"
}
