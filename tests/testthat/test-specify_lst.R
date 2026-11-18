# specify_lst ----

test_that("specify_lst() creates a working specifier (#110)", {
  spec <- specify_lst(name = stabilize_chr, .min_size = 1)
  given <- list(name = "test")
  expect_identical(spec(given), given)
  expect_s3_class(spec, "stbl_specified_fn")
})

test_that("specify_lst() creates the expected stabilizer (#110, #310)", {
  spec <- specify_lst(count = stabilize_int)
  expect_identical(spec(list(count = c(1, 2))), list(count = 1:2))
  expect_pkg_error_classes(
    spec(list(count = "not-int")),
    "stbl",
    "incompatible_values",
    "integer"
  )
})

test_that("specify_lst() passes through additional element specs from ... (#110)", {
  base_spec <- specify_lst(a = stabilize_int)
  given <- list(a = 1L, b = 2L)
  expect_identical(
    base_spec(given, b = stabilize_int),
    given
  )
})

test_that("specify_lst() respects .min_size (#110)", {
  spec <- specify_lst(.min_size = 2)
  expect_pkg_error_classes(spec(list(a = 1L)), "stbl", "size_too_small")
})

test_that("specify_lst() respects .allow_null (#110)", {
  spec <- specify_lst(.allow_null = FALSE)
  expect_pkg_error_classes(spec(NULL), "stbl", "bad_null")
})

test_that("specify_lst() enforces .unique when configured (#280)", {
  spec <- specify_lst(.unnamed = stabilize_int, .unique = TRUE)
  expect_identical(spec(list(1L, 2L)), list(1L, 2L))
  expect_pkg_error_classes(spec(list(1L, 2L, 1L)), "stbl", "duplicate_elements")
})

test_that("specify_lst() passes through .required (#279)", {
  spec <- specify_lst(
    a = stabilize_int,
    b = stabilize_int,
    .required = "a"
  )
  given <- list(a = 1L)
  expect_identical(spec(given), given)
})

test_that("specify_lst() passes through .allow_zero_length (#344)", {
  spec <- specify_lst(a = stabilize_int)
  expect_identical(spec(list()), list())

  spec_strict <- specify_lst(
    a = stabilize_int,
    .allow_zero_length = FALSE
  )
  expect_pkg_error_classes(spec_strict(list()), "stbl", "missing_element")
})

test_that("specify_lst() requires all element specs by default (#279)", {
  spec <- specify_lst(a = stabilize_int, b = stabilize_int)
  expect_pkg_error_classes(spec(list(a = 1L)), "stbl", "missing_element")
})

test_that("specify_lst() allows extra named elements unchecked with .named = TRUE (#281)", {
  spec <- specify_lst(.named = TRUE)
  given <- list(a = 1L, b = "anything")
  expect_identical(spec(given), given)
})

test_that("specify_lst() allows unnamed elements unchecked with .unnamed = TRUE (#281)", {
  spec <- specify_lst(.unnamed = TRUE)
  given <- list(1L, "anything")
  expect_identical(spec(given), given)
})

test_that("specify_list() exists (#110)", {
  expect_no_error(specify_list())
})

test_that("specify_lst() accepts elements named 'x_arg', 'call', 'x_class' (#204)", {
  spec <- specify_lst(
    x_arg = stabilize_chr,
    call = stabilize_chr,
    x_class = stabilize_chr
  )
  given <- list(x_arg = "foo", call = "bar", x_class = "baz")
  expect_identical(spec(given), given)
})

test_that("stabilize_lst() with nested specify_lst() propagates errors correctly (#204, #310)", {
  inner_spec <- specify_lst(a = stabilize_int)
  given_bad <- list(outer = list(a = "not-int"))
  expect_pkg_error_classes(
    stabilize_lst(given_bad, outer = inner_spec),
    "stbl",
    "incompatible_values",
    "integer"
  )
})

test_that("specify_lst() passes .coerce_function (#380, #401)", {
  given <- function(x) x
  expect_pkg_error_classes(specify_lst()(given), "stbl", "bad_function")
  expect_identical(
    specify_lst(.coerce_function = TRUE, .unnamed = TRUE, .named = TRUE)(given),
    as.list(given)
  )
})

test_that("specify_lst() passes .allow_duplicate_names (#400)", {
  given <- list(a = 1L, a = 2L)
  expect_pkg_error_classes(
    specify_lst(.named = stabilize_int)(given),
    "stbl",
    "duplicate_names"
  )
  spec <- specify_lst(
    .named = stabilize_int,
    .allow_duplicate_names = TRUE
  )
  expect_identical(spec(given), given)
})

test_that("specify_lst() args match stabilize_lst() args (#400)", {
  supplied <- c(".x", ".x_arg", ".call", ".x_class")
  expected <- formals(stabilize_lst)
  expected <- expected[!names(expected) %in% supplied]
  expect_identical(as.list(formals(specify_lst)), as.list(expected))
})

test_that("specify_lst() passes .simplify through (#407)", {
  spec <- specify_lst(lon = stabilize_dbl, lat = stabilize_dbl)
  given <- list(lon = 1, lat = 2)
  expect_identical(spec(given), given)
  spec_simple <- specify_lst(
    lon = stabilize_dbl,
    lat = stabilize_dbl,
    .simplify = TRUE
  )
  expect_identical(spec_simple(given), c(lon = 1, lat = 2))
})

test_that("specify_lst() applies and validates .patterns (#292)", {
  spec <- specify_lst(.patterns = list("^a" = stabilize_int))
  expect_identical(spec(list(a = 1)), list(a = 1L))
  expect_pkg_error_classes(
    specify_lst(.patterns = list("[" = stabilize_int)),
    "stbl",
    "bad_patterns",
    "invalid_regex"
  )
})
