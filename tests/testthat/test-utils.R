test_that(".glue2() works with custom delimiters", {
  local_var <- "test"
  expect_equal(.glue2("A {local_var} message."), "A {local_var} message.")
  expect_equal(.glue2("A [local_var] message."), "A test message.")
})

test_that(".cli_escape() escapes curly braces", {
  expect_equal(.cli_escape("{message}"), "{{message}}")
  expect_equal(.cli_escape("{{message}}"), "{{{{message}}}}")
  expect_equal(.cli_escape("no braces"), "no braces")
})

test_that(".cli_mark() wraps text in cli markup", {
  expect_equal(.cli_mark("text", "val"), "{.val text}")
  expect_equal(.cli_mark("text", "var"), "{.var text}")
})

test_that("%&&% works as expected", {
  expect_null(NULL %&&% "value")
  expect_equal("not null" %&&% "value", "value")
  expect_equal(TRUE %&&% "value", "value")
})

test_that(".find_failures() works", {
  x <- c("a", "b", "c")
  check_fn <- function(vec, val) {
    vec == val
  }

  expect_null(.find_failures(x, NULL, check_fn))
  expect_null(.find_failures(x, "d", check_fn))
  expect_equal(.find_failures(x, "b", check_fn), 2)
  expect_equal(.find_failures(c(x, "b"), "b", check_fn), c(2, 4))
})

test_that(".copy_names() copies names only when they apply (#8)", {
  given <- c(a = 1L, b = 2L)
  expect_named(.copy_names(1:2, given), c("a", "b"))
  expect_identical(.copy_names(1:2, 1:2), 1:2)
  expect_named(.copy_names(c(x = 1L, y = 2L), given), c("x", "y"))
  expect_null(names(.copy_names(1L, given)))
})

test_that(".as_chr_named() keeps names (#8)", {
  expect_identical(
    .as_chr_named(factor(c(a = "x", b = "y"))),
    c(a = "x", b = "y")
  )
})
