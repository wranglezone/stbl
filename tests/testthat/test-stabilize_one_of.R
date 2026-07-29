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
  # "a" in the list blocks stabilize_int for the whole vector, falling through to stabilize_chr
  expect_identical(
    stabilize_one_of(list(1L, "a"), stabilize_int, stabilize_chr),
    c("1", "a")
  )
})

test_that("stabilize_one_of() works with specify_* functions (#215)", {
  expect_identical(
    stabilize_one_of(1L, specify_int_scalar(), specify_chr_scalar()),
    1L
  )
})

test_that("stabilize_one_of() errors with a combined message when all functions fail (#215)", {
  # NULL fails both when allow_null = FALSE
  expect_pkg_error_snapshot(
    stabilize_one_of(
      NULL,
      specify_int(allow_null = FALSE),
      specify_chr(allow_null = FALSE)
    ),
    "stbl",
    "cant_stabilize_one_of"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_one_of(
      NULL,
      specify_int(allow_null = FALSE),
      specify_chr(allow_null = FALSE)
    ),
    "stbl",
    "cant_stabilize_one_of"
  )
})

test_that("stabilize_one_of() errors when ... is empty (#215)", {
  expect_pkg_error_snapshot(
    stabilize_one_of(1L),
    "stbl",
    "empty_specs"
  )
})

test_that("stabilize_one_of() errors when ... contains named elements (#215)", {
  expect_pkg_error_snapshot(
    stabilize_one_of(1L, int = stabilize_int),
    "stbl",
    "named_spec"
  )
})

test_that("stabilise_one_of() is a synonym for stabilize_one_of() (#215)", {
  expect_identical(stabilise_one_of, stabilize_one_of)
})
