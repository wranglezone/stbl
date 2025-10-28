test_that("regex_must_match() works as expected (#52, #89)", {
  rule <- regex_must_match("^a")
  expect_type(rule, "character")
  expect_named(rule, "must match the regex pattern {.val ^a}")
  expect_equal(unname(rule), "^a")
})

test_that("regex_must_match() deals with characters for glue (#52, #89)", {
  rule <- regex_must_match("a{1,3}")
  expect_type(rule, "character")
  expect_named(rule, "must match the regex pattern {.val a{{1,3}}}")
  expect_equal(unname(rule), "a{1,3}")
})

test_that("regex_must_match() handles negation (#85, #89)", {
  regex <- "^a"
  attr(regex, "negate") <- TRUE
  rule <- regex_must_match(regex)
  expect_type(rule, "character")
  expect_named(rule, "must not match the regex pattern {.val ^a}")
  expect_equal(unname(rule), regex)
  expect_true(attr(rule, "negate"))
})

test_that("regex_must_not_match() works as expected (#85, #89)", {
  rule <- regex_must_not_match("^a")
  expect_type(rule, "character")
  expect_named(rule, "must not match the regex pattern {.val ^a}")
  expect_equal(rule, "^a", ignore_attr = TRUE)
  expect_true(attr(rule, "negate"))
})

test_that("regex_must_not_match() doesn't freak out about pre-set negation (#85, #89)", {
  regex <- "^a"
  attr(regex, "negate") <- TRUE
  rule <- regex_must_not_match(regex)
  expect_type(rule, "character")
  expect_named(rule, "must not match the regex pattern {.val ^a}")
  expect_equal(rule, regex, ignore_attr = TRUE)
  expect_true(attr(rule, "negate"))
})
