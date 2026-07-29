test_that("to_one_of() returns x unchanged when first prototype matches (#215)", {
  expect_identical(to_one_of(1L, integer(), character()), 1L)
})

test_that("to_one_of() coerces via the first matching prototype (#215)", {
  expect_identical(to_one_of("1", integer(), character()), 1L)
})

test_that("to_one_of() falls through to the next prototype when first fails (#215)", {
  expect_identical(to_one_of("a", integer(), character()), "a")
  # "a" in the list blocks integer() for the whole vector, falling through to character()
  expect_identical(
    to_one_of(list("1", "a"), integer(), character()),
    c("1", "a")
  )
})

test_that("to_one_of() errors with a combined message when all prototypes fail (#215)", {
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

test_that("to_one_of() errors when ... is empty (#215)", {
  expect_pkg_error_snapshot(
    to_one_of(1L),
    "stbl",
    "empty_specs"
  )
})
