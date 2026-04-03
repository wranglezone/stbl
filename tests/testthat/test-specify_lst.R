# specify_lst ----

test_that("specify_lst() creates a working specifier (#110)", {
  spec <- specify_lst(name = specify_chr_scalar(), .min_size = 1)
  given <- list(name = "test")
  expect_identical(spec(given), given)
  expect_s3_class(spec, "stbl_specified_fn")
})

test_that("specify_lst() respects pre-configured element specs (#110)", {
  spec <- specify_lst(count = specify_int_scalar())
  expect_error(
    spec(list(count = "not-int")),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
})

test_that("specify_lst() supports element specs named 'x' and 'y' (#110)", {
  spec <- specify_lst(x = specify_chr_scalar(), y = specify_chr_scalar())
  given <- list(x = "mpg", y = "hp")
  expect_identical(spec(given), given)
})

test_that("specify_lst() passes through additional element specs from ... (#110)", {
  base_spec <- specify_lst(a = specify_int_scalar())
  given <- list(a = 1L, b = 2L)
  expect_identical(
    base_spec(given, b = specify_int_scalar()),
    given
  )
})

test_that("specify_lst() respects .min_size (#110)", {
  spec <- specify_lst(.min_size = 2)
  expect_error(
    spec(list(a = 1L)),
    class = .compile_dash("stbl", "error", "size_too_small")
  )
})

test_that("specify_lst() respects .allow_null (#110)", {
  spec <- specify_lst(.allow_null = FALSE)
  expect_error(
    spec(NULL),
    class = .compile_dash("stbl", "error", "bad_null")
  )
})

test_that("specify_list() exists (#110)", {
  expect_no_error(specify_list())
})

test_that("specify_lst() accepts elements named 'x_arg', 'call', 'x_class' (#204)", {
  spec <- specify_lst(
    x_arg = specify_chr_scalar(),
    call = specify_chr_scalar(),
    x_class = specify_chr_scalar()
  )
  given <- list(x_arg = "foo", call = "bar", x_class = "baz")
  expect_identical(spec(given), given)
})

test_that("stabilize_lst() with nested specify_lst() propagates errors correctly (#204)", {
  inner_spec <- specify_lst(a = specify_int_scalar())
  given_bad <- list(outer = list(a = "not-int"))
  expect_error(
    stabilize_lst(given_bad, outer = inner_spec),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
})
