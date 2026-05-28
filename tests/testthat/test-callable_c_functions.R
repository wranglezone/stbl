# inst/include files -------------------------------------------------------- ----

test_that("inst/include/stbl.h is installed (#235)", {
  expect_true(nchar(system.file("include", "stbl.h", package = "stbl")) > 0)
})

test_that("inst/include/stbl.c is installed (#235)", {
  expect_true(nchar(system.file("include", "stbl.c", package = "stbl")) > 0)
})

# stbl.h completeness ------------------------------------------------------- ----

test_that("stbl.h declares all expected function pointers (#235)", {
  h_path <- system.file("include", "stbl.h", package = "stbl")
  h_text <- paste(readLines(h_path), collapse = "\n")
  for (sym in expected_c_symbols) {
    expect_true(
      grepl(sym, h_text, fixed = TRUE),
      label = paste0(sym, " declared in stbl.h")
    )
  }
})

test_that("stbl.h declares stbl_init_api() (#235)", {
  h_path <- system.file("include", "stbl.h", package = "stbl")
  h_text <- paste(readLines(h_path), collapse = "\n")
  expect_true(grepl("stbl_init_api", h_text, fixed = TRUE))
})

# stbl.c completeness ------------------------------------------------------- ----

test_that("stbl.c assigns all expected callables via R_GetCCallable (#235)", {
  c_path <- system.file("include", "stbl.c", package = "stbl")
  c_text <- paste(readLines(c_path), collapse = "\n")
  for (sym in expected_c_symbols) {
    expect_true(
      grepl(sym, c_text, fixed = TRUE),
      label = paste0(sym, " assigned in stbl.c")
    )
  }
})

test_that("stbl.c defines stbl_init_api() (#235)", {
  c_path <- system.file("include", "stbl.c", package = "stbl")
  c_text <- paste(readLines(c_path), collapse = "\n")
  expect_true(grepl("stbl_init_api", c_text, fixed = TRUE))
  expect_true(grepl('R_GetCCallable\\("stbl"', c_text))
})

# init.c registration ------------------------------------------------------- ----

test_that("src/init.c registers all expected C callables (#235)", {
  # Locate init.c relative to the test file; only works in source package context.
  init_path <- test_path("../../src/init.c")
  if (!file.exists(init_path)) {
    skip("src/init.c not accessible outside source package")
  }
  init_text <- paste(readLines(init_path), collapse = "\n")
  for (sym in expected_c_symbols) {
    expect_true(
      grepl(sym, init_text, fixed = TRUE),
      label = paste0(sym, " registered in init.c")
    )
  }
})
