test_that(".to_cls_scalar() works", {
  expect_equal(
    .to_cls_scalar(
      "1",
      is_rlang_cls_scalar = rlang::is_scalar_integer,
      to_cls_fn = as.integer
    ),
    1L
  )

  expect_equal(
    .to_cls_scalar(
      1L,
      is_rlang_cls_scalar = rlang::is_scalar_integer,
      to_cls_fn = as.integer
    ),
    1L
  )

  expect_error(
    .to_cls_scalar(
      c("1", "2"),
      is_rlang_cls_scalar = rlang::is_scalar_integer,
      to_cls_fn = as.integer
    ),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
})

test_that(".stabilize_cls() calls to_cls_fn with to_cls_args", {
  to_fn <- function(x, ..., my_arg = "default") {
    if (my_arg != "success") {
      .stbl_abort("wrong arg", "fail")
    }
    as.integer(x)
  }

  expect_equal(
    .stabilize_cls(
      1:5,
      to_cls_fn = to_fn,
      to_cls_args = list(my_arg = "success")
    ),
    1:5
  )

  expect_error(
    .stabilize_cls(1:5, to_cls_fn = to_fn),
    class = .compile_dash("stbl", "error", "fail")
  )
})

test_that(".stabilize_cls() calls check_cls_value_fn", {
  check_fn <- function(x, ..., my_arg = "default") {
    if (my_arg != "success") {
      .stbl_abort("wrong arg", "fail")
    }
    if (any(x > 3)) {
      .stbl_abort("too high", "custom")
    }
    NULL
  }

  expect_equal(
    .stabilize_cls(1:3, to_cls_fn = as.integer, check_cls_value_fn = NULL),
    1:3
  )

  expect_error(
    .stabilize_cls(
      1:5,
      to_cls_fn = as.integer,
      check_cls_value_fn = check_fn,
      check_cls_value_fn_args = list(my_arg = "success")
    ),
    class = .compile_dash("stbl", "error", "custom")
  )

  expect_error(
    .stabilize_cls(
      1:3,
      to_cls_fn = as.integer,
      check_cls_value_fn = check_fn
    ),
    class = .compile_dash("stbl", "error", "fail")
  )
})

test_that(".stabilize_cls() calls stabilize_arg", {
  expect_equal(
    .stabilize_cls(1:5, to_cls_fn = as.integer, min_size = 5, max_size = 5),
    1:5
  )

  expect_error(
    .stabilize_cls(1:5, to_cls_fn = as.integer, min_size = 6),
    class = .compile_dash("stbl", "error", "size_too_small")
  )

  expect_error(
    .stabilize_cls(1:5, to_cls_fn = as.integer, max_size = 4),
    class = .compile_dash("stbl", "error", "size_too_large")
  )
})

test_that(".stabilize_cls_scalar() calls to_cls_scalar_fn with args", {
  to_fn_scalar <- function(x, ..., my_arg = "default") {
    if (my_arg != "success") {
      .stbl_abort("wrong arg", "fail")
    }
    if (length(x) > 1) {
      .stbl_abort("must be scalar", "non_scalar")
    }
    as.integer(x)
  }

  expect_equal(
    .stabilize_cls_scalar(
      "1",
      to_cls_scalar_fn = to_fn_scalar,
      to_cls_scalar_args = list(my_arg = "success")
    ),
    1L
  )

  expect_error(
    .stabilize_cls_scalar("1", to_cls_scalar_fn = to_fn_scalar),
    class = .compile_dash("stbl", "error", "fail")
  )
})

test_that(".stabilize_cls_scalar() calls check_cls_value_fn", {
  to_fn_scalar <- function(x, ...) as.integer(x)

  check_fn <- function(x, ..., my_arg = "default") {
    if (my_arg != "success") {
      .stbl_abort("wrong arg", "fail")
    }
    if (x > 3) {
      .stbl_abort("too high", "custom")
    }
    NULL
  }

  expect_equal(
    .stabilize_cls_scalar(
      "1",
      to_cls_scalar_fn = to_fn_scalar,
      check_cls_value_fn = NULL
    ),
    1L
  )

  expect_error(
    .stabilize_cls_scalar(
      "5",
      to_cls_scalar_fn = to_fn_scalar,
      check_cls_value_fn = check_fn,
      check_cls_value_fn_args = list(my_arg = "success")
    ),
    class = .compile_dash("stbl", "error", "custom")
  )

  expect_error(
    .stabilize_cls_scalar(
      "1",
      to_cls_scalar_fn = to_fn_scalar,
      check_cls_value_fn = check_fn
    ),
    class = .compile_dash("stbl", "error", "fail")
  )
})

test_that(".stabilize_cls_scalar() checks for NA and empty dots", {
  to_fn_scalar <- function(x, ...) as.integer(x)
  expect_error(
    .stabilize_cls_scalar(
      NA_integer_,
      to_cls_scalar_fn = to_fn_scalar,
      allow_na = FALSE
    ),
    class = .compile_dash("stbl", "error", "bad_na")
  )

  expect_error(
    .stabilize_cls_scalar(1L, to_cls_scalar_fn = to_fn_scalar, blah = "argh"),
    class = "rlib_error_dots_nonempty"
  )
})

test_that(".elements_are_cls_ish() works (#93)", {
  # A simple, non-S3 predicate function for testing.
  # The helper will call this function on scalar elements.
  # For our test, something is "ish" if it is an integer.
  are_test_ish <- function(x, ...) {
    is.integer(x)
  }

  expect_identical(
    .elements_are_cls_ish(list(1L, 2L), are_test_ish),
    c(TRUE, TRUE)
  )
  expect_identical(
    .elements_are_cls_ish(list(1L, "a", list(3L)), are_test_ish),
    c(TRUE, FALSE, TRUE)
  )
  expect_identical(
    .elements_are_cls_ish(list(1L, "a", list(2L, 3L)), are_test_ish),
    c(TRUE, FALSE, FALSE)
  )
})

test_that(".to_cls_from_fct() works (#23)", {
  to_fn <- function(x, ...) as.integer(x)

  # Happy path
  expect_equal(
    .to_cls_from_fct(
      x = factor(1:3),
      to_cls_fn = to_fn,
      to_cls_args = list(),
      to_class = "integer"
    ),
    1:3
  )

  # coerce_factor = FALSE
  expect_error(
    .to_cls_from_fct(
      x = factor(1:3),
      to_cls_fn = to_fn,
      to_cls_args = list(),
      to_class = "integer",
      coerce_factor = FALSE
    ),
    class = .compile_dash("stbl", "error", "coerce", "integer")
  )
})

test_that(".to_num_from_complex() works (#23)", {
  # Happy path
  expect_equal(
    .to_num_from_complex(
      x = as.complex(1:3),
      cast_fn = as.integer,
      to_type_obj = integer()
    ),
    1:3
  )

  # Failure path
  expect_error(
    .to_num_from_complex(
      x = c(1 + 1i, 2),
      cast_fn = as.integer,
      to_type_obj = integer()
    ),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
})

test_that(".to_cls_from_list() works (#128)", {
  to_fn <- function(x, ...) as.character(x)
  expect_identical(
    .to_cls_from_list(list(1, "b"), to_fn, "character"),
    c("1", "b")
  )
  expect_identical(
    .to_cls_from_list(list(list(1), "b"), to_fn, "character"),
    c("1", "b")
  )
  expect_error(
    .to_cls_from_list(list(1, 1:5), to_fn, "character"),
    class = .compile_dash("stbl", "error", "coerce", "character")
  )
})

test_that(".to_cls_from_list() works for single-element lists (#128)", {
  to_fn <- function(x, ...) as.character(x)
  # This tests the `if (length(flat) == 1)` block
  expect_identical(
    .to_cls_from_list(list("a"), to_fn, "character"),
    "a"
  )
  expect_identical(
    .to_cls_from_list(list(list("a")), to_fn, "character"),
    "a"
  )
  expect_identical(
    .to_cls_from_list(list(1L), to_fn, "character"),
    "1"
  )
})
