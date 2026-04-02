test_that("stabilize_lst() returns NULL for NULL input by default (#110)", {
  expect_null(stabilize_lst(NULL))
})

test_that("stabilize_lst() respects .allow_null (#110)", {
  expect_error(
    stabilize_lst(NULL, .allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    stabilize_lst(NULL, .allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_lst(NULL, .allow_null = FALSE),
    error = TRUE
  )
})

test_that("stabilize_lst() returns a valid list unchanged (#110)", {
  given <- list(a = 1L, b = "hello")
  expect_identical(
    stabilize_lst(given, a = specify_int_scalar(), b = specify_chr_scalar()),
    given
  )
})

test_that("stabilize_lst() validates required named elements (#110)", {
  given <- list(name = "Alice", age = 30L)
  expect_identical(
    stabilize_lst(
      given,
      name = specify_chr_scalar(),
      age = specify_int_scalar()
    ),
    given
  )
})

test_that("stabilize_lst() errors when required named element is missing (#110)", {
  expect_error(
    stabilize_lst(list(foo = "a"), name = specify_chr_scalar()),
    class = .compile_dash("stbl", "error", "missing_element")
  )
  expect_snapshot(
    stabilize_lst(list(foo = "a"), name = specify_chr_scalar()),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_lst(list(foo = "a"), name = specify_chr_scalar()),
    error = TRUE
  )
})

test_that("stabilize_lst() errors informatively when element fails validation (#110)", {
  expect_error(
    stabilize_lst(
      list(count = "not-an-int"),
      count = specify_int_scalar()
    ),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    stabilize_lst(list(count = "not-an-int"), count = specify_int_scalar()),
    error = TRUE
  )
})

test_that("stabilize_lst() errors on extra named elements by default (#110)", {
  expect_error(
    stabilize_lst(list(a = 1L, b = 2L)),
    class = .compile_dash("stbl", "error", "bad_named")
  )
  expect_snapshot(
    stabilize_lst(list(a = 1L, b = 2L)),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_lst(list(a = 1L, b = 2L)),
    error = TRUE
  )
})

test_that("stabilize_lst() validates extra named elements with .named (#110)", {
  given <- list(a = 1L, b = 2L)
  expect_identical(
    stabilize_lst(given, .named = specify_int_scalar()),
    given
  )
  expect_error(
    stabilize_lst(list(a = 1L, b = "not-int"), .named = specify_int_scalar()),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
})

test_that("stabilize_lst() errors on unnamed elements by default (#110)", {
  expect_error(
    stabilize_lst(list(1L, 2L)),
    class = .compile_dash("stbl", "error", "bad_unnamed")
  )
  expect_snapshot(
    stabilize_lst(list(1L, 2L)),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_lst(list(1L, 2L)),
    error = TRUE
  )
})

test_that("stabilize_lst() validates unnamed elements with .unnamed (#110)", {
  given <- list(1L, 2L, 3L)
  expect_identical(
    stabilize_lst(given, .unnamed = specify_int_scalar()),
    given
  )
  expect_error(
    stabilize_lst(list(1L, "not-int"), .unnamed = specify_int_scalar()),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
})

test_that("stabilize_lst() handles mixed named/unnamed lists (#110)", {
  given <- list(a = 1L, 2L, b = 3L)
  expect_identical(
    stabilize_lst(
      given,
      a = specify_int_scalar(),
      b = specify_int_scalar(),
      .unnamed = specify_int_scalar()
    ),
    given
  )
})

test_that("stabilize_lst() enforces .min_size (#110)", {
  expect_error(
    stabilize_lst(list(a = 1L), .named = specify_int_scalar(), .min_size = 2),
    class = .compile_dash("stbl", "error", "size_too_small")
  )
  expect_snapshot(
    stabilize_lst(list(a = 1L), .named = specify_int_scalar(), .min_size = 2),
    error = TRUE
  )
})

test_that("stabilize_lst() enforces .max_size (#110)", {
  expect_error(
    stabilize_lst(
      list(a = 1L, b = 2L, c = 3L),
      .named = specify_int_scalar(),
      .max_size = 2
    ),
    class = .compile_dash("stbl", "error", "size_too_large")
  )
})

test_that("stabilize_lst() validates nested lists (#110)", {
  spec_aes <- specify_lst(x = specify_chr_scalar(), y = specify_chr_scalar())
  given <- list(aes = list(x = "mpg", y = "hp"))
  expect_identical(
    stabilize_lst(given, aes = spec_aes),
    given
  )
  # data.frame can't be coerced to chr_scalar
  expect_error(
    stabilize_lst(
      list(aes = list(x = mtcars, y = "hp")),
      aes = spec_aes
    ),
    class = .compile_dash("stbl", "error", "coerce", "character")
  )
  expect_snapshot(
    stabilize_lst(list(aes = list(x = mtcars, y = "hp")), aes = spec_aes),
    error = TRUE
  )
})

test_that("stabilize_lst() with unnamed specs errors informatively (#110)", {
  expect_error(
    stabilize_lst(list(1L), specify_int_scalar()),
    class = .compile_dash("stbl", "error", "unnamed_spec")
  )
})

test_that("stabilize_list() exists (#110)", {
  expect_no_error(stabilize_list(NULL))
})

test_that("stabilise_lst() exists (#110)", {
  expect_no_error(stabilise_lst(NULL))
})

test_that("stabilise_list() exists (#110)", {
  expect_no_error(stabilise_list(NULL))
})

# stabilize_present ----

test_that("stabilize_present() returns any non-NULL value unchanged (#110)", {
  expect_identical(stabilize_present("hello"), "hello")
  expect_identical(stabilize_present(1L), 1L)
  expect_identical(stabilize_present(list(a = 1)), list(a = 1))
  expect_identical(stabilize_present(mtcars), mtcars)
})

test_that("stabilize_present() errors for NULL (#110)", {
  expect_error(
    stabilize_present(NULL),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    stabilize_present(NULL),
    error = TRUE
  )
})

test_that("stabilize_present() works as an element spec in stabilize_lst() (#110)", {
  given <- list(data = mtcars)
  expect_identical(
    stabilize_lst(given, data = stabilize_present),
    given
  )
  expect_error(
    stabilize_lst(list(data = NULL), data = stabilize_present),
    class = .compile_dash("stbl", "error", "bad_null")
  )
})
