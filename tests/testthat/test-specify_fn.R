test_that("specify_fn() creates a working to_fn() wrapper (#250)", {
  to_fn2 <- specify_fn()
  expect_identical(to_fn2("mean"), mean)
  expect_null(to_fn2(NULL))
})

test_that("specify_fn() pre-fills allow_null (#250)", {
  to_fn_strict <- specify_fn(allow_null = FALSE)
  expect_identical(to_fn_strict("mean"), mean)
  expect_error(
    to_fn_strict(NULL),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_fn_strict(NULL),
    error = TRUE
  )
})

test_that("specify_fn() pre-fills definition_env (#250)", {
  local_fn <- function(x) x * 2
  e <- new.env()
  e$local_fn <- local_fn
  to_fn_in_e <- specify_fn(definition_env = e)
  expect_identical(to_fn_in_e("local_fn"), local_fn)
})

test_that("specify_fn() errors on duplicate args (#250)", {
  to_fn_strict <- specify_fn(allow_null = FALSE)
  expect_error(
    to_fn_strict("mean", allow_null = TRUE),
    class = .compile_dash("stbl", "error", "duplicate_args")
  )
})

test_that("specify_fn() returns stbl_specified_fn (#250)", {
  expect_s3_class(specify_fn(), "stbl_specified_fn")
})

test_that("specify_function() exists (#250)", {
  expect_identical(specify_function, specify_fn)
})
