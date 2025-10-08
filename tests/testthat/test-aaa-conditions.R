test_that(".stbl_abort() throws the expected error", {
  expect_error(
    .stbl_abort("A message.", "a_subclass"),
    class = "stbl-error-a_subclass"
  )
  expect_error(
    .stbl_abort("A message.", "a_subclass"),
    class = "stbl-error"
  )
  expect_error(
    .stbl_abort("A message.", "a_subclass"),
    class = "stbl-condition"
  )
  expect_snapshot(
    .stbl_abort("A message.", "a_subclass"),
    error = TRUE
  )
})

test_that(".stop_cant_coerce() throws the expected error", {
  expected_classes <- compile_pkg_error_classes("stbl", "coerce", "integer")
  for (cls in expected_classes) {
    expect_error(
      .stop_cant_coerce("character", "integer", "my_arg", rlang::current_env()),
      class = cls
    )
  }
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
  expected_classes <- compile_pkg_error_classes("stbl", "must")
  for (cls in expected_classes) {
    expect_error(
      .stop_must("must be a foo.", "my_arg", rlang::current_env()),
      class = cls
    )
  }
  expect_snapshot(
    .stop_must("must be a foo.", "my_arg", rlang::current_env()),
    error = TRUE
  )
})

test_that(".stop_must() handles subclasses", {
  expected_classes <- compile_pkg_error_classes(
    "stbl",
    "my_custom_class"
  )
  for (cls in expected_classes) {
    expect_error(
      .stop_must(
        "must be a foo.",
        "my_arg",
        rlang::current_env(),
        subclass = "my_custom_class"
      ),
      class = cls
    )
  }
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
  expected_classes <- compile_pkg_error_classes("stbl", "bad_null")
  for (cls in expected_classes) {
    expect_error(
      .stop_null("my_arg", rlang::current_env()),
      class = cls
    )
  }
  expect_snapshot(
    .stop_null("my_arg", rlang::current_env()),
    error = TRUE
  )
})

test_that(".stop_null() passes dots", {
  expected_classes <- compile_pkg_error_classes("stbl", "bad_null")
  for (cls in expected_classes) {
    expect_error(
      .stop_null("my_arg", rlang::current_env(), .internal = TRUE),
      class = cls
    )
  }
  expect_snapshot(
    .stop_null("my_arg", rlang::current_env(), .internal = TRUE),
    error = TRUE
  )
})

test_that(".stop_incompatible() throws the expected error", {
  expected_classes <- compile_pkg_error_classes("stbl", "incompatible_type")
  for (cls in expected_classes) {
    expect_error(
      .stop_incompatible(
        "character",
        integer(),
        c(FALSE, TRUE, FALSE, TRUE),
        "some reason",
        "my_arg",
        rlang::current_env()
      ),
      class = cls
    )
  }
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
  expected_classes <- compile_pkg_error_classes("stbl", "incompatible_type")
  for (cls in expected_classes) {
    expect_error(
      .stop_incompatible(
        "character",
        integer(),
        c(FALSE, TRUE, FALSE, TRUE),
        "some reason",
        "my_arg",
        rlang::current_env(),
        .internal = TRUE
      ),
      class = cls
    )
  }
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
