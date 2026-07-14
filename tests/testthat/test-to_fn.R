test_that("to_fn() works for functions (#250)", {
  expect_identical(to_fn(mean), mean)
  expect_identical(to_fn(base::mean), mean)
})

test_that("to_fn() works for lambda functions (#250)", {
  f <- \(x) x + 1
  expect_identical(to_fn(f), f)
  expect_identical(to_fn(~ . + 1), rlang::as_function(~ . + 1))
})

test_that("to_fn() works for NULL (#250)", {
  expect_null(to_fn(NULL))
})

test_that("to_fn() respects allow_null for NULL input (#250)", {
  expect_error(
    to_fn(NULL, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_fn(NULL, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_fn(NULL, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_fn() works for simple character names (#250)", {
  expect_identical(to_fn("mean"), mean)
})

test_that("to_fn() works for namespaced character names (#250)", {
  expect_identical(to_fn("base::mean"), mean)
  expect_identical(to_fn("stats::median"), stats::median)
})

test_that("to_fn() respects definition_env for character input (#250)", {
  local_fn <- function(x) x * 2
  e <- new.env()
  e$local_fn <- local_fn
  expect_identical(to_fn("local_fn", definition_env = e), local_fn)
})

test_that("to_fn() errors informatively for unknown character names (#250)", {
  expect_snapshot(
    to_fn("not_a_real_function_xyz"),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_fn("not_a_real_function_xyz"),
    error = TRUE
  )
})

test_that("to_fn() errors for length > 1 character input (#250)", {
  expect_error(
    to_fn(c("mean", "sum")),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    to_fn(c("mean", "sum")),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_fn(c("mean", "sum")),
    error = TRUE
  )
})

test_that("to_fn() respects allow_null for length-0 character input (#250)", {
  expect_null(to_fn(character()))
  expect_error(
    to_fn(character(), allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_fn(character(), allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_fn() errors informatively for bad namespaced names (#250)", {
  expect_snapshot(
    to_fn("nonexistent_pkg::mean"),
    error = TRUE
  )
})

test_that("to_fn() errors informatively for non-coercible types (#250)", {
  expect_snapshot(
    to_fn(1L),
    error = TRUE
  )
})

test_that("to_function() exists (#250)", {
  expect_no_error(to_function("mean"))
})

# C callables ------------------------------------------------------------------

test_that(".chr_to_fn() works via C callable (#250)", {
  expect_identical(.chr_to_fn("mean"), mean)
  expect_identical(.chr_to_fn("base::mean"), mean)
  expect_identical(.chr_to_fn("stats::median"), stats::median)
  expect_error(.chr_to_fn("not_a_real_fn_xyz"))
})

test_that(".chr_are_fnish() works via C callable (#250)", {
  expect_equal(
    .chr_are_fnish(c("mean", "pkg::fn", NA, "", "1 bad")),
    c(TRUE, TRUE, FALSE, FALSE, FALSE)
  )
})
