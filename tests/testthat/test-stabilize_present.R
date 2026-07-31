test_that("stabilize_present() is deprecated in favor of assert_present() (#299)", {
  expect_pkg_error_snapshot(stabilize_present("hello"), "stbl", "deprecated")
})

test_that("stabilize_present() errors even when x is NULL (#299)", {
  expect_pkg_error_classes(stabilize_present(NULL), "stbl", "deprecated")
})
