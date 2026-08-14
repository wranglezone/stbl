test_that("stabilize_dur() coerces and returns durations (#295)", {
  given <- c("P1D", "P2D")
  expect_identical(stabilize_dur(given), to_dur(given))
})

test_that("stabilize_dur() works for NULL (#295)", {
  expect_null(stabilize_dur(NULL))
  expect_pkg_error_snapshot(
    stabilize_dur(NULL, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_dur() respects allow_na (#295)", {
  given <- to_dur(c("P1D", NA))
  expect_identical(stabilize_dur(given), given)
  expect_pkg_error_snapshot(
    stabilize_dur(given, allow_na = FALSE),
    "stbl",
    "bad_na"
  )
})

test_that("stabilize_dur() checks min_value (#295)", {
  given <- to_dur(c("P1D", "P3D"))
  expect_identical(
    stabilize_dur(given, min_value = "P0D", max_value = "P5D"),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_dur(given, min_value = "P2D"),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dur(given, min_value = "P2D"),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_dur() checks max_value (#295)", {
  given <- to_dur(c("P1D", "P3D"))
  expect_pkg_error_snapshot(
    stabilize_dur(given, max_value = "P2D"),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dur(given, max_value = "P2D"),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_dur() attaches value failure locations (#295)", {
  cnd <- rlang::catch_cnd(stabilize_dur(
    to_dur(c("P1D", "P5D", "P2D")),
    min_value = "P3D"
  ))
  expect_identical(cnd$locations, c(1L, 3L))
})

test_that("stabilize_dur() checks size (#295)", {
  given <- to_dur(c("P1D", "P2D"))
  expect_pkg_error_snapshot(
    stabilize_dur(given, min_size = 3),
    "stbl",
    "size_too_small"
  )
  expect_pkg_error_snapshot(
    stabilize_dur(given, max_size = 1),
    "stbl",
    "size_too_large"
  )
})

test_that("stabilize_dur() enforces unique elements (#295)", {
  given <- to_dur(c("P1D", "P2D"))
  expect_identical(stabilize_dur(given, unique = TRUE), given)
  expect_pkg_error_classes(
    stabilize_dur(
      to_dur(c("P1D", "P2D", "P1D")),
      unique = TRUE
    ),
    "stbl",
    "duplicate_elements"
  )
})

test_that("stabilize_dur() flags non-adjacent duplicates with equal seconds components (#295)", {
  # Regression check: base::duplicated()/unique() only look at Period's
  # `.Data` slot (the seconds component) for S4 objects, which would
  # otherwise treat these three (day = 1, 2, 1) as fully duplicated because
  # their seconds component is 0 in every position.
  given <- to_dur(c("P1D", "P2D", "P1D"))
  cnd <- rlang::catch_cnd(stabilize_dur(given, unique = TRUE))
  expect_identical(cnd$locations, 3L)
})

test_that("stabilize_dur() checks allowed_values (#295)", {
  given <- to_dur(c("P1D", "P2D"))
  expect_identical(
    stabilize_dur(given, allowed_values = c("P1D", "P2D")),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_dur(given, allowed_values = "P1D"),
    "stbl",
    "allowed_values"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dur(given, allowed_values = "P1D"),
    "stbl",
    "allowed_values"
  )
})

test_that("stabilize_dur() rejects a bare P (#295)", {
  expect_pkg_error_snapshot(
    stabilize_dur("P"),
    "stbl",
    "incompatible_values",
    "duration"
  )
})

test_that("stabilise_dur() exists (#295)", {
  expect_no_error(stabilise_dur("P1D"))
})

test_that("stabilize_dur_scalar() allows length-1 durations through (#295)", {
  given <- to_dur("P1D")
  expect_identical(stabilize_dur_scalar(given), given)
  expect_null(stabilize_dur_scalar(NULL, allow_null = TRUE))
})

test_that("stabilize_dur_scalar() respects allow_null (#295)", {
  expect_pkg_error_snapshot(
    stabilize_dur_scalar(NULL),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dur_scalar(NULL),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_dur_scalar() errors on non-scalars (#295)", {
  given <- to_dur(c("P1D", "P2D"))
  expect_pkg_error_snapshot(
    stabilize_dur_scalar(given),
    "stbl",
    "non_scalar"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dur_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("stabilize_dur_scalar() checks allowed_values (#295)", {
  expect_identical(
    stabilize_dur_scalar(
      "P1D",
      allowed_values = c("P1D", "P2D")
    ),
    to_dur("P1D")
  )
  expect_pkg_error_snapshot(
    stabilize_dur_scalar("P3D", allowed_values = "P1D"),
    "stbl",
    "allowed_values"
  )
})

test_that("stabilise_dur_scalar() exists (#295)", {
  expect_no_error(stabilise_dur_scalar("P1D"))
})

test_that("stabilize_duration_scalar() exists (#295)", {
  expect_no_error(stabilize_duration_scalar("P1D"))
})

test_that("stabilise_duration_scalar() exists (#295)", {
  expect_no_error(stabilise_duration_scalar("P1D"))
})
