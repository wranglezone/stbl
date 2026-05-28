expected_symbols <- c(
  # chr -> *
  "stbl_chr_to_lgl", "stbl_chr_are_lglish",
  "stbl_chr_to_int", "stbl_chr_are_intish",
  "stbl_chr_to_dbl", "stbl_chr_are_dblish",
  "stbl_chr_are_fctish",
  # dbl -> *
  "stbl_dbl_to_int", "stbl_dbl_are_intish",
  "stbl_dbl_to_lgl", "stbl_dbl_are_lglish",
  # int -> *
  "stbl_int_to_dbl", "stbl_int_are_dblish",
  # lgl -> *
  "stbl_lgl_to_dbl", "stbl_lgl_are_dblish",
  "stbl_lgl_to_int", "stbl_lgl_are_intish",
  # cpx -> *
  "stbl_cpx_to_dbl", "stbl_cpx_are_dblish",
  "stbl_cpx_to_int", "stbl_cpx_are_intish",
  # fct -> *
  "stbl_fct_to_dbl", "stbl_fct_are_dblish",
  "stbl_fct_to_int", "stbl_fct_are_intish",
  "stbl_fct_to_lgl", "stbl_fct_are_lglish",
  "stbl_fct_are_fctish",
  # lst -> *
  "stbl_lst_to_dbl", "stbl_lst_to_int", "stbl_lst_to_lgl",
  "stbl_lst_to_chr", "stbl_lst_to_fct",
  # range checks
  "stbl_check_min_dbl", "stbl_check_max_dbl"
)

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
  for (sym in expected_symbols) {
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
  for (sym in expected_symbols) {
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
  for (sym in expected_symbols) {
    expect_true(
      grepl(sym, init_text, fixed = TRUE),
      label = paste0(sym, " registered in init.c")
    )
  }
})
