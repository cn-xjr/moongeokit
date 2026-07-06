///|
fn abs_double(value : Double) -> Double {
  if value < 0.0 {
    -value
  } else {
    value
  }
}

///|
/// Classifies orientation using a caller-provided tolerance.
///
/// Returns `1` for counter-clockwise, `-1` for clockwise, and `0` when the
/// signed area lies within the tolerance band.
pub fn orientation_sign(
  a : Point,
  b : Point,
  c : Point,
  epsilon : Double,
) -> Int {
  let value = orientation(a, b, c)
  let tolerance = abs_double(epsilon)
  if value > tolerance {
    1
  } else if value < -tolerance {
    -1
  } else {
    0
  }
}

///|
/// Tolerant point-on-segment test for measured or transformed coordinates.
pub fn point_on_segment_eps(
  point : Point,
  segment : Segment,
  epsilon : Double,
) -> Bool {
  let tolerance = abs_double(epsilon)
  orientation_sign(segment.start, segment.end, point, tolerance) == 0 &&
  point.x >= min_double(segment.start.x, segment.end.x) - tolerance &&
  point.x <= max_double(segment.start.x, segment.end.x) + tolerance &&
  point.y >= min_double(segment.start.y, segment.end.y) - tolerance &&
  point.y <= max_double(segment.start.y, segment.end.y) + tolerance
}

///|
/// Tolerant segment intersection including endpoint and collinear contact.
pub fn segments_intersect_eps(
  a : Segment,
  b : Segment,
  epsilon : Double,
) -> Bool {
  let o1 = orientation_sign(a.start, a.end, b.start, epsilon)
  let o2 = orientation_sign(a.start, a.end, b.end, epsilon)
  let o3 = orientation_sign(b.start, b.end, a.start, epsilon)
  let o4 = orientation_sign(b.start, b.end, a.end, epsilon)
  if o1 == 0 && point_on_segment_eps(b.start, a, epsilon) {
    return true
  }
  if o2 == 0 && point_on_segment_eps(b.end, a, epsilon) {
    return true
  }
  if o3 == 0 && point_on_segment_eps(a.start, b, epsilon) {
    return true
  }
  if o4 == 0 && point_on_segment_eps(a.end, b, epsilon) {
    return true
  }
  o1 != o2 && o3 != o4
}
