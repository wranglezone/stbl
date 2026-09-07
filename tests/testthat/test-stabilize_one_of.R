test_that("stabilize_one_of() returns x unchanged when exactly one function succeeds (#286)", {
  # "ab" matches the first regex but not the second
  expect_identical(
    stabilize_one_of(
      "ab",
      specify_chr(regex = "^a"),
      specify_chr(regex = "^z")
    ),
    "ab"
  )
})

test_that("stabilize_one_of() coerces via the single matching function (#286)", {
  # "a" fails stabilize_int but succeeds stabilize_chr
  expect_identical(stabilize_one_of("a", stabilize_int, stabilize_chr), "a")
})

test_that("stabilize_one_of() works with specify_* functions (#286)", {
  expect_identical(
    stabilize_one_of("a", specify_int_scalar(), specify_chr_scalar()),
    "a"
  )
})

test_that("stabilize_one_of() errors when specs overlap and more than one matches (#286)", {
  # "1" is both int-ish and dbl-ish, so both specs succeed
  expect_pkg_error_snapshot(
    stabilize_one_of("1", stabilize_int, stabilize_dbl),
    "stbl",
    "cant_stabilize_one_of"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_one_of("1", stabilize_int, stabilize_dbl),
    "stbl",
    "cant_stabilize_one_of"
  )
})

test_that("stabilize_one_of() errors with a combined message when no function succeeds (#286)", {
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

test_that("stabilize_one_of() includes Locations from incompatible_values errors (#286)", {
  # "a" fails lgl at position 1; "a" and "2" fail int at positions 1 and 3, so
  # neither matches and both messages should surface
  x <- c("a", "2", "TRUE")
  expect_pkg_error_snapshot(
    stabilize_one_of(x, stabilize_lgl, stabilize_int),
    "stbl",
    "cant_stabilize_one_of"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_one_of(x, stabilize_lgl, stabilize_int),
    "stbl",
    "cant_stabilize_one_of"
  )
})

test_that("stabilize_one_of() names the matched specs when more than one succeeds (#286)", {
  expect_pkg_error_snapshot(
    stabilize_one_of(1L, stabilize_int, stabilize_int_scalar, stabilize_chr),
    "stbl",
    "cant_stabilize_one_of"
  )
})

test_that("stabilize_one_of() errors when ... is empty (#286)", {
  expect_pkg_error_snapshot(
    stabilize_one_of(1L),
    "stbl",
    "empty_specs"
  )
})

test_that("stabilize_one_of() errors when ... contains named elements (#286)", {
  expect_pkg_error_snapshot(
    stabilize_one_of(1L, int = stabilize_int),
    "stbl",
    "named_spec"
  )
})

test_that("stabilise_one_of() is a synonym for stabilize_one_of() (#286)", {
  expect_identical(stabilise_one_of, stabilize_one_of)
})
