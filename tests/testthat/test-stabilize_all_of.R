test_that("stabilize_all_of() returns x unchanged when all functions succeed (#278)", {
  expect_identical(stabilize_all_of(1L, stabilize_int, stabilize_int_scalar), 1L)
})

test_that("stabilize_all_of() applies each spec to the original x, not chained results (#278)", {
  # Both specs see the original "ab", independently
  expect_identical(
    stabilize_all_of("ab", specify_chr(regex = "^a"), specify_chr(regex = "b$")),
    "ab"
  )
})

test_that("stabilize_all_of() order doesn't affect whether x passes (#278)", {
  expect_identical(
    stabilize_all_of("ab", specify_chr(regex = "^a"), specify_chr(regex = "b$")),
    stabilize_all_of("ab", specify_chr(regex = "b$"), specify_chr(regex = "^a"))
  )
})

test_that("stabilize_all_of() works with specify_* functions (#278)", {
  expect_identical(
    stabilize_all_of(1L, specify_int_scalar(), specify_int(min_value = 0)),
    1L
  )
})

test_that("stabilize_all_of() errors when any function fails (#278)", {
  # "a" can't become integer, so the whole spec set fails
  expect_pkg_error_snapshot(
    stabilize_all_of("a", stabilize_int, stabilize_chr),
    "stbl",
    "cant_stabilize_all_of"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_all_of("a", stabilize_int, stabilize_chr),
    "stbl",
    "cant_stabilize_all_of"
  )
})

test_that("stabilize_all_of() errors when a later spec rejects a value an earlier spec accepted (#278)", {
  # 1L passes stabilize_int, but fails the min_value check
  expect_pkg_error_snapshot(
    stabilize_all_of(1L, stabilize_int, specify_dbl(min_value = 10)),
    "stbl",
    "cant_stabilize_all_of"
  )
})

test_that("stabilize_all_of() applies every spec to the original x, not to previous results (#278)", {
  # stabilize_int("1") would succeed and yield 1L; if that result were fed
  # forward, specify_dbl(coerce_character = FALSE) would then see an integer
  # and succeed too. Since each spec instead sees the original "1"
  # (character), specify_dbl(coerce_character = FALSE) correctly rejects it.
  expect_pkg_error_snapshot(
    stabilize_all_of("1", stabilize_int, specify_dbl(coerce_character = FALSE)),
    "stbl",
    "cant_stabilize_all_of"
  )
})

test_that("stabilize_all_of() errors when specs succeed but disagree on the coerced value (#278)", {
  # stabilize_int(1L) -> 1L, but specify_dbl() -> 1 (double); both succeed but
  # disagree on the resulting type
  expect_pkg_error_snapshot(
    stabilize_all_of(1L, stabilize_int, specify_dbl()),
    "stbl",
    "inconsistent_all_of"
  )
})

test_that("stabilize_all_of() includes Locations from incompatible_values errors (#278)", {
  x <- c("1", "a", "3")
  expect_pkg_error_snapshot(
    stabilize_all_of(x, stabilize_int, stabilize_chr),
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
