# stabilize_one_of() ----

test_that("stabilize_one_of() returns x unchanged when first function succeeds (#215)", {
  expect_identical(stabilize_one_of(1L, stabilize_int, stabilize_chr), 1L)
})

test_that("stabilize_one_of() coerces via the first matching function (#215)", {
  # "1" coerces to integer successfully
  expect_identical(stabilize_one_of("1", stabilize_int, stabilize_chr), 1L)
})

test_that("stabilize_one_of() falls through to the next function when first fails (#215)", {
  # "a" can't become integer, so stabilize_chr is tried
  expect_identical(stabilize_one_of("a", stabilize_int, stabilize_chr), "a")
})

test_that("stabilize_one_of() works with specify_* functions (#215)", {
  expect_identical(
    stabilize_one_of(1L, specify_int_scalar(), specify_chr_scalar()),
    1L
  )
})

test_that("stabilize_one_of() errors with a combined message when all functions fail (#215)", {
  # NULL fails both when allow_null = FALSE
  expect_error(
    stabilize_one_of(
      NULL,
      specify_int(allow_null = FALSE),
      specify_chr(allow_null = FALSE)
    ),
    class = .compile_dash("stbl", "error", "cant_stabilize_one_of")
  )
  expect_snapshot(
    stabilize_one_of(
      NULL,
      specify_int(allow_null = FALSE),
      specify_chr(allow_null = FALSE)
    ),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_one_of(
      NULL,
      specify_int(allow_null = FALSE),
      specify_chr(allow_null = FALSE)
    ),
    error = TRUE
  )
})

test_that("stabilize_one_of() errors when ... is empty (#215)", {
  expect_error(
    stabilize_one_of(1L),
    class = .compile_dash("stbl", "error", "empty_specs")
  )
  expect_snapshot(stabilize_one_of(1L), error = TRUE)
})

test_that("stabilize_one_of() errors when ... contains named elements (#215)", {
  expect_error(
    stabilize_one_of(1L, int = stabilize_int),
    class = .compile_dash("stbl", "error", "named_spec")
  )
  expect_snapshot(stabilize_one_of(1L, int = stabilize_int), error = TRUE)
})

test_that("stabilise_one_of() is a synonym for stabilize_one_of() (#215)", {
  expect_identical(stabilise_one_of, stabilize_one_of)
})

# to_one_of() ----

test_that("to_one_of() returns x unchanged when first prototype matches (#215)", {
  expect_identical(to_one_of(1L, integer(), character()), 1L)
})

test_that("to_one_of() coerces via the first matching prototype (#215)", {
  expect_identical(to_one_of("1", integer(), character()), 1L)
})

test_that("to_one_of() falls through to the next prototype when first fails (#215)", {
  expect_identical(to_one_of("a", integer(), character()), "a")
})

test_that("to_one_of() errors with a combined message when all prototypes fail (#215)", {
  # Environments have no to_int or to_chr method, so both fail
  expect_error(
    to_one_of(new.env(), integer(), character()),
    class = .compile_dash("stbl", "error", "cant_stabilize_one_of")
  )
  expect_snapshot(
    to_one_of(new.env(), integer(), character()),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_one_of(new.env(), integer(), character()),
    error = TRUE
  )
})

test_that("to_one_of() errors when ... is empty (#215)", {
  expect_error(
    to_one_of(1L),
    class = .compile_dash("stbl", "error", "empty_specs")
  )
  expect_snapshot(to_one_of(1L), error = TRUE)
})
