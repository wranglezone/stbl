test_that("stabilize_any_of() returns x unchanged when first function succeeds (#215, #285)", {
  expect_identical(stabilize_any_of(1L, stabilize_int, stabilize_chr), 1L)
})

test_that("stabilize_any_of() coerces via the first matching function (#215, #285)", {
  # "1" coerces to integer successfully
  expect_identical(stabilize_any_of("1", stabilize_int, stabilize_chr), 1L)
})

test_that("stabilize_any_of() falls through to the next function when first fails (#215, #285)", {
  # "a" can't become integer, so stabilize_chr is tried
  expect_identical(stabilize_any_of("a", stabilize_int, stabilize_chr), "a")
  # "a" in the list blocks stabilize_int for the whole vector, falling through to stabilize_chr
  expect_identical(
    stabilize_any_of(list(1L, "a"), stabilize_int, stabilize_chr),
    c("1", "a")
  )
})

test_that("stabilize_any_of() works with specify_* functions (#215, #285)", {
  expect_identical(
    stabilize_any_of(1L, specify_int_scalar(), specify_chr_scalar()),
    1L
  )
})

test_that("stabilize_any_of() errors with a combined message when all functions fail (#215, #285)", {
  # NULL fails both when allow_null = FALSE
  expect_pkg_error_snapshot(
    stabilize_any_of(
      NULL,
      specify_int(allow_null = FALSE),
      specify_chr(allow_null = FALSE)
    ),
    "stbl",
    "cant_stabilize_any_of"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_any_of(
      NULL,
      specify_int(allow_null = FALSE),
      specify_chr(allow_null = FALSE)
    ),
    "stbl",
    "cant_stabilize_any_of"
  )
})

test_that("stabilize_any_of() includes Locations from incompatible_values errors (#215, #285, #310)", {
  # "a" fails lgl at position 1; "a" and "2" fail int at positions 1 and 3
  x <- c("a", "2", "TRUE")
  expect_pkg_error_snapshot(
    stabilize_any_of(x, stabilize_lgl, stabilize_int),
    "stbl",
    "cant_stabilize_any_of"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_any_of(x, stabilize_lgl, stabilize_int),
    "stbl",
    "cant_stabilize_any_of"
  )
})

test_that("stabilize_any_of() errors when ... is empty (#215, #285)", {
  expect_pkg_error_snapshot(
    stabilize_any_of(1L),
    "stbl",
    "empty_specs"
  )
})

test_that("stabilize_any_of() errors when ... contains named elements (#215, #285)", {
  expect_pkg_error_snapshot(
    stabilize_any_of(1L, int = stabilize_int),
    "stbl",
    "named_spec"
  )
})

test_that("stabilise_any_of() is a synonym for stabilize_any_of() (#215, #285)", {
  expect_identical(stabilise_any_of, stabilize_any_of)
})
