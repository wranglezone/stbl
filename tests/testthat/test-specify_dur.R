test_that("specify_dur can build a value checker (#295, #325)", {
  checker <- specify_dur(max_value = "P1D")
  expect_identical(checker("PT12H"), to_dur("PT12H"))
  expect_pkg_error_classes(
    checker("P2D"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_dur can enforce unique elements (#295, #325)", {
  checker <- specify_dur(unique = TRUE)
  given <- to_dur(c("P1D", "P2D"))
  expect_identical(checker(given), given)
  expect_pkg_error_classes(
    checker(to_dur(c("P1D", "P1D"))),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_dur_scalar can build a value checker (#295, #325)", {
  checker <- specify_dur_scalar(max_value = "P1D")
  expect_identical(checker("PT12H"), to_dur("PT12H"))
  expect_pkg_error_classes(
    checker(to_dur(c("P1D", "P2D"))),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_dur_scalar defaults to allow_null = FALSE (#295, #325)", {
  checker <- specify_dur_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_dur_scalar defaults to allow_zero_length = FALSE (#295, #325)", {
  checker <- specify_dur_scalar()
  empty <- to_dur(character())
  expect_pkg_error_classes(checker(empty), "stbl", "bad_empty")
  expect_identical(checker(empty, allow_zero_length = TRUE), empty)
})

test_that("specify_dur can enforce allowed_values (#295, #325)", {
  checker <- specify_dur(
    allowed_values = c("P1D", "P2D")
  )
  expect_identical(checker("P1D"), to_dur("P1D"))
  expect_pkg_error_classes(checker("P3D"), "stbl", "allowed_values")
})

test_that("specify_dur() creates a working stabilizer (#295, #325)", {
  stabilize_short <- specify_dur(max_value = "P1D")
  expect_identical(stabilize_short("PT12H"), to_dur("PT12H"))
  expect_pkg_error_classes(
    stabilize_short("P2D"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_dur_scalar() creates a working scalar stabilizer (#295, #325)", {
  stabilize_short <- specify_dur_scalar(max_value = "P1D")
  expect_identical(stabilize_short("PT12H"), to_dur("PT12H"))
  expect_pkg_error_classes(
    stabilize_short(c("P1D", "P2D")),
    "stbl",
    "non_scalar"
  )
})
