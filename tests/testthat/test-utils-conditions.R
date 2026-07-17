test_that(".capture_first_pkg_condition() captures a condition and returns it invisibly (#234)", {
  captured <- .capture_first_pkg_condition(
    quote(warning("a warning")),
    condition_name = "warning",
    muffle_restart = "muffleWarning",
    env = environment()
  )
  expect_s3_class(captured, "warning")
  expect_match(conditionMessage(captured), "a warning")
})

test_that(".capture_first_pkg_condition() returns NULL when no condition is signalled (#234)", {
  expect_null(
    .capture_first_pkg_condition(
      quote(1 + 1),
      condition_name = "warning",
      muffle_restart = "muffleWarning",
      env = environment()
    )
  )
})

test_that(".capture_first_pkg_condition() evaluates obj_expr in env (#234)", {
  env <- new.env(parent = environment())
  .capture_first_pkg_condition(
    quote(x <- 42),
    condition_name = "warning",
    muffle_restart = "muffleWarning",
    env = env
  )
  expect_equal(env$x, 42)
})

test_that(".compile_dash() pastes with a dash separator (#213)", {
  expect_equal(.compile_dash("a", "b"), "a-b")
  expect_equal(.compile_dash("pkg", "error", "sub"), "pkg-error-sub")
})

test_that(".collapse_dash() collapses a vector with dashes (#213)", {
  expect_equal(.collapse_dash(c("a", "b")), "a-b")
  expect_equal(.collapse_dash(c("outer", "inner")), "outer-inner")
  expect_equal(.collapse_dash("single"), "single")
})

test_that(".compile_pkg_condition_classes() compiles condition class chains (#213)", {
  expect_equal(
    .compile_pkg_condition_classes("wrapped"),
    "wrapped-condition"
  )
  expect_equal(
    .compile_pkg_condition_classes("wrapped", "error"),
    c("wrapped-error", "wrapped-condition")
  )
  expect_equal(
    .compile_pkg_condition_classes("wrapped", "error", "my_subclass"),
    c("wrapped-error-my_subclass", "wrapped-error", "wrapped-condition")
  )
  expect_equal(
    .compile_pkg_condition_classes("pkg", "warning", "outer", "inner"),
    c(
      "pkg-warning-outer-inner",
      "pkg-warning-outer",
      "pkg-warning",
      "pkg-condition"
    )
  )
})
