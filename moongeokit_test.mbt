///|
test "point vector operations are deterministic" {
  let a = @moongeokit.Point::new(3.0, 4.0)
  let b = @moongeokit.Point::new(1.0, 2.0)
  assert_eq(a.add(b).x, 4.0)
  assert_eq(a.sub(b).y, 2.0)
  assert_eq(a.scale(2.0).x, 6.0)
  assert_eq(a.length(), 5.0)
}

///|
test "dot cross distance and orientation" {
  let a = @moongeokit.Point::new(0.0, 0.0)
  let b = @moongeokit.Point::new(4.0, 0.0)
  let c = @moongeokit.Point::new(4.0, 3.0)
  assert_eq(b.dot(c), 16.0)
  assert_eq(b.cross(c), 12.0)
  assert_eq(a.distance_to(c), 5.0)
  assert_eq(@moongeokit.orientation(a, b, c), 12.0)
}

///|
test "segment intersection detects crossing segments" {
  let a = @moongeokit.Segment::new(
    @moongeokit.Point::new(0.0, 0.0),
    @moongeokit.Point::new(4.0, 4.0),
  )
  let b = @moongeokit.Segment::new(
    @moongeokit.Point::new(0.0, 4.0),
    @moongeokit.Point::new(4.0, 0.0),
  )
  assert_true(@moongeokit.segments_intersect(a, b))
}

///|
test "point on segment handles collinear bounds" {
  let segment = @moongeokit.Segment::new(
    @moongeokit.Point::new(0.0, 0.0),
    @moongeokit.Point::new(4.0, 0.0),
  )
  assert_true(
    @moongeokit.point_on_segment(@moongeokit.Point::new(2.0, 0.0), segment),
  )
  assert_false(
    @moongeokit.point_on_segment(@moongeokit.Point::new(5.0, 0.0), segment),
  )
}

///|
test "bounds from points computes extent" {
  let bounds = @moongeokit.Bounds::from_points([
    @moongeokit.Point::new(2.0, 4.0),
    @moongeokit.Point::new(-1.0, 5.0),
    @moongeokit.Point::new(3.0, -2.0),
  ])
  assert_eq(bounds.min_x, -1.0)
  assert_eq(bounds.max_y, 5.0)
  assert_eq(bounds.width(), 4.0)
  assert_eq(bounds.height(), 7.0)
}

///|
test "bounds containment and intersection" {
  let bounds = @moongeokit.Bounds::new(0.0, 0.0, 4.0, 4.0)
  assert_true(bounds.contains(@moongeokit.Point::new(2.0, 2.0)))
  assert_false(bounds.contains(@moongeokit.Point::new(5.0, 2.0)))
  assert_true(bounds.intersects(@moongeokit.Bounds::new(3.0, 3.0, 5.0, 5.0)))
  assert_false(bounds.intersects(@moongeokit.Bounds::new(5.0, 5.0, 6.0, 6.0)))
}
