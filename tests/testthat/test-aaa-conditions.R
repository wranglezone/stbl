test_that(".stbl_abort() throws the expected error", {
  expect_pkg_error_classes(
    .stbl_abort("A message.", "a_subclass"),
    "stbl",
    "a_subclass"
  )
  expect_snapshot(
    .stbl_abort("A message.", "a_subclass"),
    error = TRUE
  )
})

test_that(".stop_cant_coerce() throws the expected error", {
  expect_pkg_error_classes(
    .stop_cant_coerce("character", "integer", "my_arg", rlang::current_env()),
    "stbl",
    "coerce",
    "integer"
  )
  expect_snapshot(
    .stop_cant_coerce("character", "integer", "my_arg", rlang::current_env()),
    error = TRUE
  )
})

test_that(".stop_cant_coerce() uses additional_msg when provided", {
  expect_snapshot(
    .stop_cant_coerce(
      "character",
      "integer",
      "my_arg",
      rlang::current_env(),
      additional_msg = c(x = "An extra message.")
    ),
    error = TRUE
  )
})

test_that(".stop_must() throws the expected error", {
  expect_pkg_error_classes(
    .stop_must("must be a foo.", "my_arg", rlang::current_env()),
    "stbl",
    "must"
  )
  expect_snapshot(
    .stop_must("must be a foo.", "my_arg", rlang::current_env()),
    error = TRUE
  )
})

test_that(".stop_must() handles subclasses", {
  expect_pkg_error_classes(
    .stop_must(
      "must be a foo.",
      "my_arg",
      rlang::current_env(),
      subclass = "my_custom_class"
    ),
    "stbl",
    "my_custom_class"
  )
  expect_snapshot(
    .stop_must(
      "must be a foo.",
      "my_arg",
      rlang::current_env(),
      subclass = "my_custom_class"
    ),
    error = TRUE
  )
})

test_that(".stop_must() uses additional_msg when provided", {
  expect_snapshot(
    .stop_must(
      "must be a foo.",
      "my_arg",
      rlang::current_env(),
      additional_msg = c("*" = "Some details.")
    ),
    error = TRUE
  )
})

test_that(".define_main_msg() works", {
  expect_equal(
    .define_main_msg("my_arg", "must be a foo."),
    "{.arg my_arg} must be a foo."
  )
})

test_that(".stop_null() throws the expected error", {
  expect_pkg_error_classes(
    .stop_null("my_arg", rlang::current_env()),
    "stbl",
    "bad_null"
  )
  expect_snapshot(
    .stop_null("my_arg", rlang::current_env()),
    error = TRUE
  )
})

test_that(".stop_null() passes dots", {
  expect_pkg_error_classes(
    .stop_null("my_arg", rlang::current_env(), .internal = TRUE),
    "stbl",
    "bad_null"
  )
  expect_snapshot(
    .stop_null("my_arg", rlang::current_env(), .internal = TRUE),
    error = TRUE
  )
})

test_that(".stop_incompatible() throws the expected error", {
  expect_pkg_error_classes(
    .stop_incompatible(
      "character",
      integer(),
      c(FALSE, TRUE, FALSE, TRUE),
      "some reason",
      "my_arg",
      rlang::current_env()
    ),
    "stbl",
    "incompatible_type"
  )
  expect_snapshot(
    .stop_incompatible(
      "character",
      integer(),
      c(FALSE, TRUE, FALSE, TRUE),
      "some reason",
      "my_arg",
      rlang::current_env()
    ),
    error = TRUE
  )
})

test_that(".stop_incompatible() passes dots", {
  expect_pkg_error_classes(
    .stop_incompatible(
      "character",
      integer(),
      c(FALSE, TRUE, FALSE, TRUE),
      "some reason",
      "my_arg",
      rlang::current_env(),
      .internal = TRUE
    ),
    "stbl",
    "incompatible_type"
  )
  expect_snapshot(
    .stop_incompatible(
      "character",
      integer(),
      c(FALSE, TRUE, FALSE, TRUE),
      "some reason",
      "my_arg",
      rlang::current_env(),
      .internal = TRUE
    ),
    error = TRUE
  )
})
