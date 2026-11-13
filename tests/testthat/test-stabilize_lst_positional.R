test_that("stabilize_lst_positional() applies specs by position (#284)", {
  expect_identical(
    stabilize_lst_positional(
      list("1", 2, TRUE),
      stabilize_int_scalar,
      stabilize_chr_scalar,
      stabilize_lgl_scalar
    ),
    list(1L, "2", TRUE)
  )
})

test_that("stabilize_lst_positional() synonyms are identical (#284)", {
  expect_identical(stabilise_lst_positional, stabilize_lst_positional)
  expect_identical(stabilize_list_positional, stabilize_lst_positional)
  expect_identical(stabilise_list_positional, stabilize_lst_positional)
  expect_identical(stabilize_tuple, stabilize_lst_positional)
  expect_identical(stabilise_tuple, stabilize_lst_positional)
})

test_that("stabilize_lst_positional() requires non-empty, unnamed specs (#284)", {
  expect_pkg_error_classes(
    stabilize_lst_positional(list(1)),
    "stbl",
    "empty_specs"
  )
  expect_pkg_error_classes(
    stabilize_lst_positional(list(1), a = stabilize_int_scalar),
    "stbl",
    "named_spec"
  )
})

test_that("stabilize_lst_positional() handles NULL (#284)", {
  expect_null(stabilize_lst_positional(NULL, stabilize_int_scalar))
  expect_pkg_error_classes(
    stabilize_lst_positional(
      NULL,
      stabilize_int_scalar,
      .allow_null = FALSE
    ),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_lst_positional() errors on named elements (#284)", {
  expect_pkg_error_classes(
    stabilize_lst_positional(list(a = 1L), stabilize_int_scalar),
    "stbl",
    "bad_named"
  )
})

test_that("stabilize_lst_positional() enforces .n_required (#284)", {
  expect_pkg_error_classes(
    stabilize_lst_positional(
      list(1L),
      stabilize_int_scalar,
      stabilize_int_scalar
    ),
    "stbl",
    "missing_element"
  )
  expect_identical(
    stabilize_lst_positional(
      list(1L),
      stabilize_int_scalar,
      stabilize_int_scalar,
      .n_required = 1
    ),
    list(1L)
  )
  expect_identical(
    stabilize_lst_positional(
      list(),
      stabilize_int_scalar,
      .n_required = 1
    ),
    list()
  )
  expect_pkg_error_classes(
    stabilize_lst_positional(
      list(),
      stabilize_int_scalar,
      .allow_zero_length = FALSE
    ),
    "stbl",
    "missing_element"
  )
})

test_that("stabilize_lst_positional() validates .n_required (#284)", {
  expect_pkg_error_classes(
    stabilize_lst_positional(list(1L), stabilize_int_scalar, .n_required = 2),
    "stbl",
    "bad_n_required"
  )
  expect_pkg_error_classes(
    stabilize_lst_positional(list(1L), stabilize_int_scalar, .n_required = -1),
    "stbl",
    "bad_n_required"
  )
})

test_that("stabilize_lst_positional() handles .additional (#284)", {
  expect_pkg_error_classes(
    stabilize_lst_positional(list(1L, 2L), stabilize_int_scalar),
    "stbl",
    "bad_additional"
  )
  expect_pkg_error_classes(
    stabilize_lst_positional(
      list(1L, 2L),
      stabilize_int_scalar,
      .additional = FALSE
    ),
    "stbl",
    "bad_additional"
  )
  expect_identical(
    stabilize_lst_positional(
      list(1L, "a", NULL),
      stabilize_int_scalar,
      .additional = TRUE
    ),
    list(1L, "a", NULL)
  )
  expect_identical(
    stabilize_lst_positional(
      list("a", "1", 2),
      stabilize_chr_scalar,
      .additional = stabilize_int_scalar
    ),
    list("a", 1L, 2L)
  )
  expect_pkg_error_classes(
    stabilize_lst_positional(
      list("a", "x"),
      stabilize_chr_scalar,
      .additional = stabilize_int_scalar
    ),
    "stbl",
    "cant_stabilize_positional"
  )
})

test_that("stabilize_lst_positional() preserves NULL results (#284)", {
  expect_identical(
    stabilize_lst_positional(
      list(NULL, 1L),
      stabilize_arg,
      stabilize_int_scalar
    ),
    list(NULL, 1L)
  )
})

test_that("stabilize_lst_positional() reports every failing position (#284)", {
  cnd <- rlang::catch_cnd(
    stabilize_lst_positional(
      list("a", "b", "c"),
      stabilize_chr_scalar,
      stabilize_int_scalar,
      stabilize_lgl_scalar
    )
  )
  expect_s3_class(cnd, "stbl-error-cant_stabilize_positional")
  expect_identical(cnd$locations, c(2L, 3L))
})

test_that("stabilize_lst_positional() errors with a combined message (#284)", {
  expect_pkg_error_snapshot(
    stabilize_lst_positional(
      list("a", "b", "c"),
      stabilize_chr_scalar,
      stabilize_int_scalar,
      stabilize_lgl_scalar
    ),
    "stbl",
    "cant_stabilize_positional"
  )
  expect_pkg_error_snapshot(
    stabilize_lst_positional(list(1L, 2L), stabilize_int_scalar),
    "stbl",
    "bad_additional"
  )
  expect_pkg_error_snapshot(
    stabilize_lst_positional(
      list(1L),
      stabilize_int_scalar,
      stabilize_int_scalar
    ),
    "stbl",
    "missing_element"
  )
})

test_that("stabilize_lst_positional() checks size and uniqueness (#284)", {
  expect_pkg_error_classes(
    stabilize_lst_positional(
      list(1L),
      stabilize_int_scalar,
      .n_required = 0,
      .min_size = 2
    ),
    "stbl",
    "size_too_small"
  )
  expect_pkg_error_classes(
    stabilize_lst_positional(
      list(1L, 1L),
      stabilize_int_scalar,
      .additional = TRUE,
      .max_size = 1
    ),
    "stbl",
    "size_too_large"
  )
  expect_pkg_error_classes(
    stabilize_lst_positional(
      list("1", 1L),
      stabilize_int_scalar,
      stabilize_int_scalar,
      .unique = TRUE
    ),
    "stbl",
    "duplicate_elements"
  )
})

test_that("stabilize_lst_positional() simplifies when possible (#284)", {
  expect_identical(
    stabilize_lst_positional(
      list(1.5, 2L),
      stabilize_dbl_scalar,
      stabilize_int_scalar,
      .simplify = TRUE
    ),
    c(1.5, 2)
  )
  expect_identical(
    stabilize_lst_positional(
      list(1, "a"),
      stabilize_dbl_scalar,
      stabilize_chr_scalar,
      .simplify = TRUE
    ),
    list(1, "a")
  )
  expect_identical(
    stabilize_lst_positional(
      list(1, 2),
      stabilize_dbl_scalar,
      stabilize_dbl_scalar
    ),
    list(1, 2)
  )
})

test_that("stabilize_lst_positional() coerces functions only on request (#284)", {
  expect_pkg_error_classes(
    stabilize_lst_positional(mean, stabilize_arg),
    "stbl",
    "bad_function"
  )
})
