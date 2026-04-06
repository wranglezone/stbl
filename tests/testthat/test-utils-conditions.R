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
