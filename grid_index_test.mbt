///|
test "grid index point query scans a local bucket" {
  let index = @moongeokit.GridSpatialIndex::new(
    @moongeokit.Bounds::new(0.0, 0.0, 100.0, 100.0),
    10,
    10,
  )
  for y = 0; y < 10; y = y + 1 {
    for x = 0; x < 10; x = x + 1 {
      let min_x = x.to_double() * 10.0 + 1.0
      let min_y = y.to_double() * 10.0 + 1.0
      ignore(
        index.insert(
          @moongeokit.SpatialItem::new(
            y * 10 + x,
            @moongeokit.Bounds::new(min_x, min_y, min_x + 2.0, min_y + 2.0),
          ),
        ),
      )
    }
  }
  let result = index.query_point(@moongeokit.Point::new(11.5, 11.5))
  assert_eq(index.length(), 100)
  assert_eq(result.items.length(), 1)
  assert_eq(result.items[0].id, 11)
  assert_true(result.candidates_scanned < index.length())
  assert_eq(result.buckets_visited, 1)
}

///|
test "grid index range query deduplicates spanning items" {
  let index = @moongeokit.GridSpatialIndex::new(
    @moongeokit.Bounds::new(0.0, 0.0, 20.0, 20.0),
    4,
    4,
  )
  assert_true(
    index.insert(
      @moongeokit.SpatialItem::new(
        1,
        @moongeokit.Bounds::new(4.0, 4.0, 16.0, 16.0),
      ),
    ),
  )
  let result = index.query_bounds(@moongeokit.Bounds::new(5.0, 5.0, 15.0, 15.0))
  assert_eq(result.items.length(), 1)
  assert_eq(result.items[0].id, 1)
  assert_eq(result.candidates_scanned, 1)
  assert_eq(result.buckets_visited, 9)
}

///|
test "grid index rejects items and queries outside world" {
  let index = @moongeokit.GridSpatialIndex::new(
    @moongeokit.Bounds::new(0.0, 0.0, 10.0, 10.0),
    2,
    2,
  )
  assert_false(
    index.insert(
      @moongeokit.SpatialItem::new(
        9,
        @moongeokit.Bounds::new(20.0, 20.0, 21.0, 21.0),
      ),
    ),
  )
  let result = index.query_point(@moongeokit.Point::new(-1.0, -1.0))
  assert_eq(result.items.length(), 0)
  assert_eq(result.candidates_scanned, 0)
}

///|
test "tolerant predicates handle floating point measurement noise" {
  let segment = @moongeokit.Segment::new(
    @moongeokit.Point::new(0.0, 0.0),
    @moongeokit.Point::new(10.0, 0.0),
  )
  let measured = @moongeokit.Point::new(5.0, 0.00000001)
  assert_false(@moongeokit.point_on_segment_eps(measured, segment, 0.000000001))
  assert_true(@moongeokit.point_on_segment_eps(measured, segment, 0.000001))
  assert_eq(
    @moongeokit.orientation_sign(segment.start, segment.end, measured, 0.000001),
    0,
  )
}

///|
test "grid index updates and removes editor objects by id" {
  let index = @moongeokit.GridSpatialIndex::new(
    @moongeokit.Bounds::new(0.0, 0.0, 100.0, 100.0),
    10,
    10,
  )
  assert_true(
    index.insert(
      @moongeokit.SpatialItem::new(
        7,
        @moongeokit.Bounds::new(2.0, 2.0, 8.0, 8.0),
      ),
    ),
  )
  assert_true(index.update(7, @moongeokit.Bounds::new(72.0, 72.0, 78.0, 78.0)))
  assert_eq(
    index.query_point(@moongeokit.Point::new(4.0, 4.0)).items.length(),
    0,
  )
  assert_eq(
    index.query_point(@moongeokit.Point::new(75.0, 75.0)).items[0].id,
    7,
  )
  assert_true(index.remove(7))
  assert_false(index.contains_id(7))
  assert_eq(
    index.query_point(@moongeokit.Point::new(75.0, 75.0)).items.length(),
    0,
  )
  assert_false(index.remove(7))
}
