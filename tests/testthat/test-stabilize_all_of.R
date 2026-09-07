test_that("stabilize_all_of() applies every spec, in order (#278)", {
  # stabilize_int leaves 1L unchanged, then stabilize_dbl coerces to double
  expect_identical(stabilize_all_of(1L, stabilize_int, stabilize_dbl), 1)
})

test_that("stabilize_all_of() composes coercions, feeding each output to the next spec (#278)", {
  # "1" -> 1L (stabilize_int) -> 1 (stabilize_dbl)
  expect_identical(stabilize_all_of("1", stabilize_int, stabilize_dbl), 1)
})

test_that("stabilize_all_of() applies specs in order (#278)", {
  # Coerces to int first (dropping decimals would fail dbl -> int, but
  # int -> dbl always succeeds), so order matters.
  expect_identical(
    stabilize_all_of(1L, stabilize_int, specify_dbl(min_value = 0)),
    1
  )
})

test_that("stabilize_all_of() works with specify_* functions (#278)", {
  expect_identical(
    stabilize_all_of(1L, specify_int_scalar(), specify_dbl_scalar()),
    1
  )
})

test_that("stabilize_all_of() errors when any function fails (#278)", {
  # "a" can't become integer, so the whole chain fails
  expect_pkg_error_snapshot(
    stabilize_all_of("a", stabilize_int, stabilize_dbl),
    "stbl",
    "cant_stabilize_all_of"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_all_of("a", stabilize_int, stabilize_dbl),
    "stbl",
    "cant_stabilize_all_of"
  )
})

test_that("stabilize_all_of() stops at the first failing spec (#278)", {
  # 1L passes stabilize_int, but fails the min_value check; stabilize_dbl is
  # never reached
  expect_pkg_error_snapshot(
    stabilize_all_of(1L, stabilize_int, specify_dbl(min_value = 10)),
    "stbl",
    "cant_stabilize_all_of"
  )
})

test_that("stabilize_all_of() includes Locations from incompatible_values errors (#278)", {
  x <- c("1", "a", "3")
  expect_pkg_error_snapshot(
    stabilize_all_of(x, stabilize_int, stabilize_dbl),
    "stbl",
    "cant_stabilize_all_of"
  )
})

test_that("stabilize_all_of() errors when ... is empty (#278)", {
  expect_pkg_error_snapshot(
    stabilize_all_of(1L),
    "stbl",
    "empty_specs"
  )
})

test_that("stabilize_all_of() errors when ... contains named elements (#278)", {
  expect_pkg_error_snapshot(
    stabilize_all_of(1L, int = stabilize_int),
    "stbl",
    "named_spec"
  )
})

test_that("stabilise_all_of() is a synonym for stabilize_all_of() (#278)", {
  expect_identical(stabilise_all_of, stabilize_all_of)
})
