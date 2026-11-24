test_that(".doc_errors() sorts entries and flattens lists (#426)", {
  result <- .doc_errors(
    .doc_err_scalar(),
    .doc_err_size(),
    .doc_err_null(),
    .doc_err_named_fn()
  )
  bullets <- strsplit(result, "\n", fixed = TRUE)[[1]]
  expect_identical(
    sub("^- `<stbl-error-([^>]*)>.*", "\\1", bullets[1:5]),
    c(
      "bad_null",
      "non_scalar",
      "size_too_large",
      "size_too_small",
      "size_x_vs_y"
    )
  )
  expect_match(bullets[6], "^- Errors from `named`")
})

test_that(".doc_errors() errors on duplicate subclasses (#426)", {
  expect_error(
    .doc_errors(.doc_err_null(), .doc_err_null(".allow_null")),
    "bad_null"
  )
})

test_that(".doc_errors() rejects non-entries (#426)", {
  expect_error(.doc_errors("bad_null"), "doc_err")
})

test_that("coerce and incompatible helpers build consistent entries (#426)", {
  expect_identical(
    .doc_err_coerce("integer")$text,
    "`<stbl-error-coerce-integer>` when `x` cannot be converted to integer."
  )
  expect_identical(
    .doc_err_incompatible("character", what = "elements")$text,
    "`<stbl-error-incompatible_values-character>` when some elements of a list cannot be converted to character."
  )
  expect_error(.doc_err_incompatible("integer", what = "bogus"))
})

test_that(".doc_err() accepts a vector subclass (#426)", {
  expect_identical(
    .doc_err(c("coerce", "character"), "when it fails.")$text,
    "`<stbl-error-coerce-character>` when it fails."
  )
  expect_error(
    .doc_errors(
      .doc_err(c("coerce", "character"), "a."),
      .doc_err_coerce("character")
    ),
    "coerce-character"
  )
})

test_that("shared entries with scalar and exclusive variants work (#426)", {
  expect_match(.doc_err_range()$text, "`min_value` or `max_value`", fixed = TRUE)
  expect_match(.doc_err_range(TRUE)$text, "`exclusive_max_value`", fixed = TRUE)
  expect_match(.doc_err_allowed_values()$text, "values are not in")
  expect_match(.doc_err_allowed_values(TRUE)$text, "the value is not in")
  expect_match(.doc_err_not_multiple()$text, "values are not a multiple")
  expect_match(.doc_err_not_multiple(TRUE)$text, "the value is not a multiple")
  expect_identical(.doc_err_unique()$subclass, "duplicate_elements")
  expect_identical(.doc_err_function()$subclass, "bad_function")
  expect_identical(.doc_err_fct_levels()$subclass, "fct_levels")
  expect_identical(.doc_err_multiple_of()$subclass, "bad_multiple_of")
})

test_that("simple shared entries carry their subclass (#426)", {
  expect_identical(.doc_err_na()$subclass, "bad_na")
  expect_identical(.doc_err_named()$subclass, "bad_named")
  expect_identical(.doc_err_allowed_names()$subclass, "allowed_names")
  expect_identical(.doc_err_empty()$subclass, "bad_empty")
  expect_identical(.doc_err_scalar()$subclass, "non_scalar")
  expect_identical(
    .doc_err_incompatible("integer")$subclass,
    "incompatible_values-integer"
  )
})

test_that("size, n_characters, regex, and tz entries work (#426)", {
  sizes <- .doc_err_size("list", ".min_size", ".max_size", fn = "f")
  expect_length(sizes, 3)
  expect_match(sizes[[1]]$text, "list is longer than `.max_size` in [f()].", fixed = TRUE)
  expect_length(.doc_err_size(x_vs_y = FALSE), 2)
  expect_match(
    .doc_err_size_x_vs_y(also = c("min_characters", "max_characters"))$text,
    "or `min_characters` is larger than `max_characters`",
    fixed = TRUE
  )
  expect_length(.doc_err_n_characters(), 3)
  expect_length(.doc_err_n_characters(scalar = TRUE), 2)
  expect_identical(.doc_err_regex()$subclass, "regex_mismatch")
  expect_match(.doc_err_tz()$text, "^`<stbl-error-bad_tz>` when `tz` is not")
  expect_match(.doc_err_tz("`.to` is a Date")$text, "when `.to` is a Date and `tz`")
  expect_match(.doc_err_empty("f")$text, "in [f()].", fixed = TRUE)
  expect_match(.doc_err_scalar("f")$text, "in [f()].", fixed = TRUE)
})
