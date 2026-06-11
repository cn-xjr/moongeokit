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
  orientation(segment.start, segment.end, point) == 0.0 &&
  point.x >= min_double(segment.start.x, segment.end.x) &&
  point.x <= max_double(segment.start.x, segment.end.x) &&
  point.y >= min_double(segment.start.y, segment.end.y) &&
  point.y <= max_double(segment.start.y, segment.end.y)
}

///|
pub fn segments_intersect(a : Segment, b : Segment) -> Bool {
  let o1 = orientation(a.start, a.end, b.start)
  let o2 = orientation(a.start, a.end, b.end)
  let o3 = orientation(b.start, b.end, a.start)
  let o4 = orientation(b.start, b.end, a.end)
  if o1 == 0.0 && point_on_segment(b.start, a) {
    return true
  }
  if o2 == 0.0 && point_on_segment(b.end, a) {
    return true
  }
  if o3 == 0.0 && point_on_segment(a.start, b) {
    return true
  }
  if o4 == 0.0 && point_on_segment(a.end, b) {
    return true
  }
  ((o1 > 0.0 && o2 < 0.0) || (o1 < 0.0 && o2 > 0.0)) &&
  ((o3 > 0.0 && o4 < 0.0) || (o3 < 0.0 && o4 > 0.0))
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
