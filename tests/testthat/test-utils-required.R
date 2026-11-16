test_that(".normalize_required() handles NULL and atomic vectors (#291)", {
  expect_identical(
    .normalize_required(NULL, "required", rlang::current_env()),
    .new_required()
  )
  expect_identical(
    .normalize_required(c("a", "b"), "required", rlang::current_env()),
    .new_required(always = c("a", "b"))
  )
  expect_identical(
    .normalize_required(character(), "required", rlang::current_env()),
    .new_required()
  )
})

test_that(".normalize_required() treats named atomic vectors like lists (#291)", {
  expect_identical(
    .normalize_required(
      c("a", b = "c"),
      "required",
      rlang::current_env()
    ),
    .normalize_required(
      list("a", b = "c"),
      "required",
      rlang::current_env()
    )
  )
})

test_that(".normalize_required() normalizes lists (#291)", {
  expect_identical(
    .normalize_required(
      list("a", c("b", "c"), d = "e", f = list(g = "h"), NULL),
      "required",
      rlang::current_env()
    ),
    .new_required(
      always = c("a", "b", "c"),
      when = list(
        d = .new_required(always = "e"),
        f = .new_required(
          when = list(g = .new_required(always = "h"))
        )
      )
    )
  )
})

test_that(".normalize_required() treats empty names as unnamed (#291)", {
  expect_identical(
    .normalize_required(
      c("a", "b"),
      "required",
      rlang::current_env()
    ),
    .normalize_required(
      stats::setNames(c("a", "b"), c("", "")),
      "required",
      rlang::current_env()
    )
  )
})

test_that(".normalize_required() merges duplicate triggers by union (#291)", {
  expect_identical(
    .normalize_required(
      list(a = "b", a = c("b", "c"), a = list(d = "e")),
      "required",
      rlang::current_env()
    ),
    .new_required(
      when = list(
        a = .new_required(
          always = c("b", "c"),
          when = list(d = .new_required(always = "e"))
        )
      )
    )
  )
  expect_identical(
    .normalize_required(
      list(a = list(b = "c"), a = list(b = "d")),
      "required",
      rlang::current_env()
    ),
    .new_required(
      when = list(
        a = .new_required(
          when = list(b = .new_required(always = c("c", "d")))
        )
      )
    )
  )
})

test_that(".normalize_required() errors for invalid leaves (#291)", {
  expect_pkg_error_snapshot(
    .normalize_required(list(NA_character_), "required", rlang::current_env()),
    "stbl",
    "bad_required"
  )
  expect_pkg_error_classes(
    .normalize_required(list(a = 1), ".required", rlang::current_env()),
    "stbl",
    "bad_required"
  )
  expect_pkg_error_classes(
    .normalize_required(list(a = list(1)), ".required", rlang::current_env()),
    "stbl",
    "bad_required"
  )
})

test_that(".required_names() lists every name at any depth (#291)", {
  required <- .normalize_required(
    list("a", b = list(c = c("d", "e")), f = "g"),
    "required",
    rlang::current_env()
  )
  expect_setequal(
    .required_names(required),
    c("a", "b", "c", "d", "e", "f", "g")
  )
  expect_identical(.required_names(.new_required()), character())
})

test_that(".find_missing_required() reports triggers for missing names (#291)", {
  required <- .normalize_required(
    list("a", b = list(c = "d")),
    "required",
    rlang::current_env()
  )
  expect_identical(.find_missing_required(required, c("a")), list())
  expect_identical(
    .find_missing_required(required, character()),
    list(list(missing = "a", triggers = character()))
  )
  expect_identical(
    .find_missing_required(required, c("a", "b", "c")),
    list(list(missing = "d", triggers = c("b", "c")))
  )
  expect_identical(.find_missing_required(required, c("a", "c")), list())
})

test_that(".check_required_present() passes when requirements are met (#291)", {
  required <- .normalize_required(
    list("a", b = "c"),
    "required",
    rlang::current_env()
  )
  expect_null(
    .check_required_present(
      required,
      present = c("a", "b", "c"),
      noun = "name",
      x_arg = "x",
      call = rlang::current_env()
    )
  )
})

test_that(".check_required_present() describes missing names (#291)", {
  required <- .normalize_required(
    list("a", "z", b = "c", d = list(e = c("f", "g"))),
    "required",
    rlang::current_env()
  )
  expect_pkg_error_snapshot(
    .check_required_present(
      required,
      present = character(),
      noun = "element",
      x_arg = "x",
      call = rlang::current_env()
    ),
    "stbl",
    "missing_element"
  )
  expect_pkg_error_snapshot(
    .check_required_present(
      required,
      present = c("a", "z", "b", "d", "e"),
      noun = "column",
      x_arg = "x",
      call = rlang::current_env()
    ),
    "stbl",
    "missing_element"
  )
})

test_that(".check_required_have_specs() passes when specs are not needed (#291)", {
  required <- .normalize_required(
    list("a", b = "c"),
    "required",
    rlang::current_env()
  )
  expect_null(
    .check_required_have_specs(
      required,
      spec_names = c("a", "b", "c"),
      named = FALSE,
      named_arg = ".named",
      call = rlang::current_env()
    )
  )
  for (named in list(NULL, TRUE, identity)) {
    expect_null(
      .check_required_have_specs(
        required,
        spec_names = "a",
        named = named,
        named_arg = ".named",
        call = rlang::current_env()
      )
    )
  }
})

test_that(".check_required_have_specs() errors when FALSE and specs are missing (#291)", {
  required <- .normalize_required(
    list("a", b = "c"),
    "required",
    rlang::current_env()
  )
  expect_pkg_error_snapshot(
    .check_required_have_specs(
      required,
      spec_names = "a",
      named = FALSE,
      named_arg = ".extra_cols",
      call = rlang::current_env()
    ),
    "stbl",
    "bad_required"
  )
})
