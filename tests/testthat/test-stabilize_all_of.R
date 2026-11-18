test_that("stabilize_all_of() returns x unchanged when all functions succeed (#278)", {
  expect_identical(
    stabilize_all_of(1L, stabilize_int, stabilize_int_scalar),
    1L
  )
})

test_that("stabilize_all_of() applies each spec to the original x, not chained results (#278)", {
  # Both specs see the original "ab", independently
  expect_identical(
    stabilize_all_of(
      "ab",
      specify_chr(regex = "^a"),
      specify_chr(regex = "b$")
    ),
    "ab"
  )
})

test_that("stabilize_all_of() order doesn't affect whether x passes (#278)", {
  expect_identical(
    stabilize_all_of(
      "ab",
      specify_chr(regex = "^a"),
      specify_chr(regex = "b$")
    ),
    stabilize_all_of("ab", specify_chr(regex = "b$"), specify_chr(regex = "^a"))
  )
})

test_that("stabilize_all_of() errors when any function fails (#278, #377)", {
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

test_that("stabilize_all_of() applies every spec to the original x, not to previous results (#278, #377)", {
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

test_that("stabilize_all_of() accepts equivalent results of different types (#408)", {
  expect_identical(stabilize_all_of(1L, stabilize_int, stabilize_dbl), 1L)
  expect_identical(stabilize_all_of(1L, stabilize_dbl, stabilize_int), 1L)
  expect_identical(
    stabilize_all_of(as.double(1:10), stabilize_int, stabilize_dbl),
    1:10
  )
  expect_identical(stabilize_all_of("1", stabilize_int, stabilize_chr), 1L)
})

test_that("stabilize_all_of() returns the same result regardless of spec order (#408)", {
  specs <- list(
    stabilize_int,
    stabilize_dbl,
    stabilize_chr,
    stabilize_lgl,
    stabilize_fct,
    specify_int(min_value = 0)
  )
  for (x in list(1L, 1, "1", TRUE)) {
    for (a in specs) {
      for (b in specs) {
        forward <- tryCatch(stabilize_all_of(x, a, b), error = \(cnd) "error")
        backward <- tryCatch(stabilize_all_of(x, b, a), error = \(cnd) "error")
        expect_identical(forward, backward)
      }
    }
  }
})

test_that("stabilize_all_of() errors when specs succeed but their results are not equivalent (#278, #377, #408)", {
  # Same labels, different level order
  expect_pkg_error_snapshot(
    stabilize_all_of(
      c("a", "b"),
      stabilize_fct,
      specify_fct(levels = c("b", "a"))
    ),
    "stbl",
    "inconsistent_all_of"
  )
})

test_that("stabilize_all_of() includes Locations from incompatible_values errors (#278, #377)", {
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
