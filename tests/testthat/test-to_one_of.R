test_that("to_one_of() returns x unchanged when exactly one prototype matches (#286)", {
  expect_identical(to_one_of("a", integer(), character()), "a")
})

test_that("to_one_of() coerces via the single matching prototype (#286)", {
  # "FALSE" coerces to logical, but not to integer
  expect_identical(to_one_of("FALSE", logical(), integer()), FALSE)
})

test_that("to_one_of() errors when prototypes overlap and more than one matches (#286)", {
  # "1" can become either an integer or a double
  expect_pkg_error_snapshot(
    to_one_of("1", integer(), double()),
    "stbl",
    "cant_stabilize_one_of"
  )
  expect_pkg_error_snapshot(
    wrapped_to_one_of("1", integer(), double()),
    "stbl",
    "cant_stabilize_one_of"
  )
})

test_that("to_one_of() errors with a combined message when no prototype matches (#286)", {
  # Environments have no to_int or to_chr method, so both fail
  expect_pkg_error_snapshot(
    to_one_of(new.env(), integer(), character()),
    "stbl",
    "cant_stabilize_one_of"
  )
  expect_pkg_error_snapshot(
    wrapped_to_one_of(new.env(), integer(), character()),
    "stbl",
    "cant_stabilize_one_of"
  )
})

test_that("to_one_of() errors when ... is empty (#286)", {
  expect_pkg_error_snapshot(
    to_one_of(1L),
    "stbl",
    "empty_specs"
  )
})
