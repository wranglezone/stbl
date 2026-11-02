test_that("stabilize_arg() returns its inputs for default settings (#11)", {
  given <- 1:2
  expect_identical(stabilize_arg(given), given)
  expect_identical(stabilize_arg(NULL), NULL)
})

test_that("stabilize_arg() complains about weird args (#11, #58, #99)", {
  # This error is from rlang, so just watch for that error class
  expect_error(
    stabilize_arg(1L, new_arg = "red"),
    class = "rlib_error_dots_nonempty"
  )
  expect_snapshot(
    stabilize_arg(1L, new_arg = "red"),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_arg(1L, new_arg = "red"),
    error = TRUE
  )
})

test_that("stabilize_arg() rejects NULLs when asked (#11, #58, #99)", {
  given <- NULL
  expect_pkg_error_snapshot(
    stabilize_arg(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_arg(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_arg() checks NAs (#11, #58, #99)", {
  given <- 1:8
  expect_identical(stabilize_arg(given, allow_na = FALSE), given)

  given[c(4, 7)] <- NA
  expect_pkg_error_snapshot(
    stabilize_arg(given, allow_na = FALSE),
    "stbl",
    "bad_na"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_arg(given, allow_na = FALSE),
    "stbl",
    "bad_na"
  )
})

test_that("stabilize_arg() checks size args (#11, #58, #99)", {
  given <- TRUE
  expect_true(stabilize_arg(given, min_size = 1, max_size = 1))

  expect_pkg_error_snapshot(
    stabilize_arg(given, min_size = 2, max_size = 1),
    "stbl",
    "size_x_vs_y"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_arg(given, min_size = 2, max_size = 1),
    "stbl",
    "size_x_vs_y"
  )
})

test_that("stabilize_arg() checks min_size (#11, #58, #99)", {
  given <- 1:3
  expect_identical(
    stabilize_arg(given, min_size = 1, max_size = 10),
    given
  )

  expect_pkg_error_snapshot(
    stabilize_arg(given, min_size = 11),
    "stbl",
    "size_too_small"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_arg(given, min_size = 11),
    "stbl",
    "size_too_small"
  )
})

test_that("stabilize_arg() checks max_size (#11, #58)", {
  given <- 1:3
  expect_pkg_error_snapshot(
    stabilize_arg(given, max_size = 2),
    "stbl",
    "size_too_large"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_arg(given, max_size = 2),
    "stbl",
    "size_too_large"
  )
})


test_that("stabilize_arg_scalar() allows length-1 args through (#12)", {
  given <- 1L
  expect_identical(stabilize_arg_scalar(given), given)
})

test_that("stabilize_arg_scalar() errors for non-scalars (#12, #58)", {
  given <- 1:10
  expect_pkg_error_snapshot(stabilize_arg_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(
    wrapped_stabilize_arg_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("stabilize_arg_scalar() respects allow_null (#12, #58)", {
  given <- NULL
  expect_pkg_error_snapshot(
    stabilize_arg_scalar(given, allow_null = FALSE),
    "stbl",
    "non_scalar"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_arg_scalar(given, allow_null = FALSE),
    "stbl",
    "non_scalar"
  )
})

test_that("stabilize_arg_scalar() errors on weird internal arg values (#12, #58)", {
  given <- NULL
  expect_pkg_error_snapshot(
    stabilize_arg_scalar(given, allow_null = c(TRUE, FALSE)),
    "stbl",
    "non_scalar"
  )
})

test_that("stabilize_arg() checks named (#8)", {
  expect_identical(stabilize_arg(c(a = 1), named = TRUE), c(a = 1))
  expect_identical(stabilize_arg(1, named = FALSE), 1)
  expect_pkg_error_classes(
    stabilize_arg(1, named = TRUE),
    "stbl",
    "bad_named"
  )
  expect_pkg_error_classes(
    stabilize_arg(c(a = 1), named = "b"),
    "stbl",
    "allowed_names"
  )
  expect_identical(stabilize_arg_scalar(c(a = 1), named = "a"), c(a = 1))
  expect_pkg_error_classes(
    stabilize_arg_scalar(c(a = 1), named = FALSE),
    "stbl",
    "bad_named"
  )
})

test_that("stabilize_*() functions check named (#8)", {
  given <- list(
    lgl = c(a = TRUE),
    int = c(a = 1L),
    dbl = c(a = 1),
    chr = c(a = "x"),
    fct = c(a = "x"),
    date = c(a = "2020-01-01"),
    dttm = c(a = "2020-01-01 10:00:00"),
    time = hms::hms(3600) |> rlang::set_names("a"),
    dur = c(a = "P1D")
  )
  for (type in names(given)) {
    x <- given[[type]]
    unnamed <- unname(x)
    for (suffix in c("", "_scalar")) {
      fn <- get(paste0("stabilize_", type, suffix))
      expect_named(fn(x), "a")
      expect_named(fn(x, named = TRUE), "a")
      expect_named(fn(x, named = "a"), "a")
      expect_null(names(fn(unnamed)))
      expect_no_error(fn(x, named = TRUE))
      expect_no_error(fn(x, named = "a"))
      expect_no_error(fn(unnamed, named = FALSE))
      expect_pkg_error_classes(fn(unnamed, named = TRUE), "stbl", "bad_named")
      expect_pkg_error_classes(fn(x, named = FALSE), "stbl", "bad_named")
      expect_pkg_error_classes(fn(x, named = "b"), "stbl", "allowed_names")
    }
    expect_null(get(paste0("stabilize_", type))(NULL, named = TRUE))
  }
})

test_that("stabilize_*() applies a spec to names (#8)", {
  spec <- specify_chr(regex = "^[a-z]+$")
  expect_no_error(stabilize_int(c(a = 1L), named = spec))
  expect_pkg_error_classes(
    stabilize_int(c(A = 1L), named = spec),
    "stbl",
    "regex_mismatch"
  )
})
