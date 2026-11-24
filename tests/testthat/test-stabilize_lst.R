test_that("stabilize_lst() returns NULL for NULL input by default (#110)", {
  expect_null(stabilize_lst(NULL))
})

test_that("stabilize_lst() respects .allow_null (#110)", {
  expect_pkg_error_snapshot(
    stabilize_lst(NULL, .allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_lst(NULL, .allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_lst() returns a valid list unchanged (#110)", {
  given <- list(a = 1L, b = "hello")
  expect_identical(
    stabilize_lst(given, a = stabilize_int_scalar, b = stabilize_chr_scalar),
    given
  )
})

test_that("stabilize_lst() validates required named elements (#110)", {
  given <- list(name = "Alice", age = 30L)
  expect_identical(
    stabilize_lst(
      given,
      name = stabilize_chr_scalar,
      age = stabilize_int_scalar
    ),
    given
  )
})

test_that("stabilize_lst() errors when required named element is missing (#110)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(foo = "a"), name = stabilize_chr_scalar),
    "stbl",
    "missing_element"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_lst(list(foo = "a"), name = stabilize_chr_scalar),
    "stbl",
    "missing_element"
  )
})

test_that("stabilize_lst() errors informatively when element fails validation (#110, #310, #335, #377)", {
  expect_pkg_error_snapshot(
    stabilize_lst(
      list(count = "not-an-int"),
      count = stabilize_int_scalar
    ),
    "stbl",
    "incompatible_values",
    "integer"
  )
})

test_that("stabilize_lst() errors on extra named elements by default (#110)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(a = 1L, b = 2L)),
    "stbl",
    "bad_named"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_lst(list(a = 1L, b = 2L)),
    "stbl",
    "bad_named"
  )
})

test_that("stabilize_lst() validates extra named elements with .named (#110, #310)", {
  given <- list(a = 1L, b = 2L)
  expect_identical(
    stabilize_lst(given, .named = stabilize_int_scalar),
    given
  )
  expect_pkg_error_classes(
    stabilize_lst(list(a = 1L, b = "not-int"), .named = stabilize_int_scalar),
    "stbl",
    "incompatible_values",
    "integer"
  )
})

test_that("stabilize_lst() allows extra named elements unchecked with .named = TRUE (#281)", {
  given <- list(a = 1L, b = "anything")
  expect_identical(stabilize_lst(given, .named = TRUE), given)
})

test_that("stabilize_lst() treats .named = FALSE like the default (forbid) (#281)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(a = 1L, b = 2L), .named = FALSE),
    "stbl",
    "bad_named"
  )
})

test_that("stabilize_lst() errors informatively when .named isn't NULL/logical/function (#281, #335, #377)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(a = 1L, b = 2L), .named = "yes"),
    "stbl",
    "incompatible_values",
    "logical"
  )
})

test_that("stabilize_lst() errors on unnamed elements by default (#110)", {
  expect_pkg_error_snapshot(stabilize_lst(list(1L, 2L)), "stbl", "bad_unnamed")
  expect_pkg_error_snapshot(
    wrapped_stabilize_lst(list(1L, 2L)),
    "stbl",
    "bad_unnamed"
  )
})

test_that("stabilize_lst() validates unnamed elements with .unnamed (#110, #310)", {
  given <- list(1L, 2L, 3L)
  expect_identical(
    stabilize_lst(given, .unnamed = stabilize_int_scalar),
    given
  )
  expect_pkg_error_classes(
    stabilize_lst(list(1L, "not-int"), .unnamed = stabilize_int_scalar),
    "stbl",
    "incompatible_values",
    "integer"
  )
})

test_that("stabilize_lst() allows unnamed elements unchecked with .unnamed = TRUE (#281)", {
  given <- list(1L, "anything")
  expect_identical(stabilize_lst(given, .unnamed = TRUE), given)
})

test_that("stabilize_lst() treats .unnamed = FALSE like the default (forbid) (#281)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(1L, 2L), .unnamed = FALSE),
    "stbl",
    "bad_unnamed"
  )
})

test_that("stabilize_lst() errors informatively when .unnamed isn't NULL/logical/function (#281, #335, #377)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(1L, 2L), .unnamed = "yes"),
    "stbl",
    "incompatible_values",
    "logical"
  )
})

test_that("stabilize_lst() handles mixed named/unnamed lists (#110)", {
  given <- list(a = 1L, 2L, b = 3L)
  expect_identical(
    stabilize_lst(
      given,
      a = stabilize_int_scalar,
      b = stabilize_int_scalar,
      .unnamed = stabilize_int_scalar
    ),
    given
  )
})

test_that("stabilize_lst() enforces .min_size (#110)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(a = 1L), .named = stabilize_int_scalar, .min_size = 2),
    "stbl",
    "size_too_small"
  )
})

test_that("stabilize_lst() enforces .max_size (#110)", {
  expect_pkg_error_classes(
    stabilize_lst(
      list(a = 1L, b = 2L, c = 3L),
      .named = stabilize_int_scalar,
      .max_size = 2
    ),
    "stbl",
    "size_too_large"
  )
})

test_that("stabilize_lst() enforces .unique (#280)", {
  expect_identical(
    stabilize_lst(
      list(1L, 2L),
      .unnamed = stabilize_int_scalar,
      .unique = TRUE
    ),
    list(1L, 2L)
  )
  expect_pkg_error_classes(
    stabilize_lst(
      list(1L, 2L, 1L),
      .unnamed = stabilize_int_scalar,
      .unique = TRUE
    ),
    "stbl",
    "duplicate_elements"
  )
})

test_that("stabilize_lst() reports duplicate locations for .unique failures (#280)", {
  cnd <- rlang::catch_cnd(
    stabilize_lst(
      list("a", "b", "a"),
      .unnamed = stabilize_chr_scalar,
      .unique = TRUE
    )
  )
  expect_identical(cnd$locations, 3L)
})

test_that("stabilize_lst() checks .unique after conversion (#280)", {
  cnd <- rlang::catch_cnd(
    stabilize_lst(
      list("1", 1.0),
      .unnamed = stabilize_int_scalar,
      .unique = TRUE
    )
  )
  expect_pkg_error_classes(cnd, "stbl", "duplicate_elements")
  expect_identical(cnd$locations, 2L)
})

test_that("stabilize_lst() validates nested lists (#110, #377)", {
  spec_aes <- specify_lst(x = stabilize_chr_scalar, y = stabilize_chr_scalar)
  given <- list(aes = list(x = "mpg", y = "hp"))
  expect_identical(
    stabilize_lst(given, aes = spec_aes),
    given
  )
  # data.frame can't be converted to chr_scalar
  expect_pkg_error_snapshot(
    stabilize_lst(
      list(aes = list(x = mtcars, y = "hp")),
      aes = spec_aes
    ),
    "stbl",
    "coerce",
    "character"
  )
})

test_that("stabilize_lst() requires all named specs by default (#279)", {
  expect_pkg_error_snapshot(
    stabilize_lst(
      list(a = 1L),
      a = stabilize_int_scalar,
      b = stabilize_int_scalar
    ),
    "stbl",
    "missing_element"
  )
})

test_that("stabilize_lst() allows an absent optional element via .required (#279)", {
  given <- list(a = 1L)
  expect_identical(
    stabilize_lst(
      given,
      a = stabilize_int_scalar,
      b = stabilize_int_scalar,
      .required = "a"
    ),
    given
  )
})

test_that("stabilize_lst() still validates an optional element when present (#279)", {
  expect_pkg_error_classes(
    stabilize_lst(
      list(a = 1L, b = "not-int"),
      a = stabilize_int_scalar,
      b = stabilize_int_scalar,
      .required = "a"
    ),
    "stbl",
    "incompatible_values",
    "integer"
  )
})

test_that("stabilize_lst() treats .required = NULL as making everything optional (#279)", {
  given <- list(z = 1L)
  expect_identical(
    stabilize_lst(
      given,
      a = stabilize_int_scalar,
      b = stabilize_int_scalar,
      .named = TRUE,
      .required = NULL
    ),
    given
  )
})

test_that("stabilize_lst() still errors on required elements not in .required (#279)", {
  expect_pkg_error_snapshot(
    stabilize_lst(
      list(z = 1L),
      a = stabilize_int_scalar,
      b = stabilize_int_scalar,
      .named = TRUE,
      .required = "a"
    ),
    "stbl",
    "missing_element"
  )
})

test_that("stabilize_lst() errors on missing required element in unnamed non-empty list (#344)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(1L, 2L), a = stabilize_int_scalar),
    "stbl",
    "missing_element"
  )
})

test_that("stabilize_lst() skips required-element check for empty .x by default (#344)", {
  expect_identical(
    stabilize_lst(list(), a = stabilize_int_scalar),
    list()
  )
})

test_that("stabilize_lst() still enforces .min_size on empty .x when .allow_zero_length = TRUE (#344)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(), .min_size = 2),
    "stbl",
    "size_too_small"
  )
})

test_that("stabilize_lst() checks required elements for empty .x when .allow_zero_length = FALSE (#344)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(), a = stabilize_int_scalar, .allow_zero_length = FALSE),
    "stbl",
    "missing_element"
  )
})

test_that("stabilize_lst() with unnamed specs errors informatively (#110)", {
  expect_pkg_error_classes(
    stabilize_lst(list(1L), stabilize_int_scalar),
    "stbl",
    "unnamed_spec"
  )
})

test_that(".check_duplicate_names(): errors on duplicate names by default (#110)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(a = 1L, a = 2L), .named = stabilize_int_scalar),
    "stbl",
    "duplicate_names"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_lst(list(a = 1L, a = 2L), .named = stabilize_int_scalar),
    "stbl",
    "duplicate_names"
  )
})

test_that(".check_duplicate_names(): allows duplicates with .allow_duplicate_names = TRUE (#110)", {
  given <- list(a = 1L, a = 2L)
  expect_identical(
    stabilize_lst(
      given,
      .named = stabilize_int_scalar,
      .allow_duplicate_names = TRUE
    ),
    given
  )
})

test_that(".check_duplicate_names(): reports all duplicate name groups (#110)", {
  expect_snapshot(
    stabilize_lst(
      list(a = 1L, b = 2L, a = 3L, b = 4L),
      .named = stabilize_int_scalar
    ),
    error = TRUE
  )
})

test_that(".check_duplicate_names(): unnamed elements do not count as duplicates (#110)", {
  expect_pkg_error_classes(
    stabilize_lst(
      list(a = 1L, 2L, a = 3L),
      .named = stabilize_int_scalar,
      .unnamed = stabilize_int_scalar
    ),
    "stbl",
    "duplicate_names"
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

test_that("stabilize_lst() converts functions with .coerce_function = TRUE (#380, #401)", {
  given <- function(x, y = 2) x + y
  expect_identical(
    stabilize_lst(
      given,
      .coerce_function = TRUE,
      .unnamed = TRUE,
      .named = TRUE
    ),
    as.list(given)
  )
  expect_pkg_error_classes(stabilize_lst(given), "stbl", "bad_function")
  expect_identical(
    stabilize_lst(list(a = 1L), .coerce_function = TRUE, a = to_int_scalar),
    list(a = 1L)
  )
})

# .simplify ----

test_that("stabilize_lst() simplifies scalars when .simplify = TRUE (#407)", {
  expect_identical(
    stabilize_lst(list(a = 1L, b = 2L), .named = TRUE, .simplify = TRUE),
    c(a = 1L, b = 2L)
  )
  expect_identical(
    stabilize_lst(list(flag = TRUE, n = 2L), .named = TRUE, .simplify = TRUE),
    c(flag = 1L, n = 2L)
  )
  expect_identical(
    stabilize_lst(list(1, 2), .unnamed = TRUE, .simplify = TRUE),
    c(1, 2)
  )
})

test_that("stabilize_lst() simplifies after validation (#407)", {
  expect_identical(
    stabilize_lst(
      list(a = "1", b = 2L),
      .named = stabilize_int_scalar,
      .simplify = TRUE
    ),
    c(a = 1L, b = 2L)
  )
})

test_that("stabilize_lst() leaves unsimplifiable lists alone (#407)", {
  mixed <- list(a = 1, b = "x")
  expect_identical(
    stabilize_lst(mixed, .named = TRUE, .simplify = TRUE),
    mixed
  )
  nonscalar <- list(a = 1:2, b = 3L)
  expect_identical(
    stabilize_lst(nonscalar, .named = TRUE, .simplify = TRUE),
    nonscalar
  )
  expect_identical(stabilize_lst(list(), .simplify = TRUE), list())
  expect_null(stabilize_lst(NULL, .simplify = TRUE))
})

test_that("stabilize_lst() checks .simplify (#407)", {
  expect_pkg_error_classes(
    stabilize_lst(list(), .simplify = "nope"),
    "stbl",
    "incompatible_values",
    "logical"
  )
})

test_that("stabilize_lst() resolves unconditional and conditional .required (#291)", {
  spec <- function(x, ...) {
    stabilize_lst(
      x,
      name = stabilize_chr_scalar,
      card = stabilize_int_scalar,
      address = stabilize_chr_scalar,
      ...
    )
  }
  req <- list("name", card = "address")
  expect_identical(spec(list(name = "A"), .required = req), list(name = "A"))
  expect_identical(
    spec(list(address = "x"), .required = list(card = "address")),
    list(address = "x")
  )
  expect_pkg_error_snapshot(
    spec(list(name = "A", card = 1L), .required = req),
    "stbl",
    "missing_element"
  )
  expect_pkg_error_classes(
    spec(list(card = 1L), .required = req),
    "stbl",
    "missing_element"
  )
  # Named atomic vectors behave like lists.
  expect_pkg_error_classes(
    spec(list(name = "A", card = 1L), .required = c("name", card = "address")),
    "stbl",
    "missing_element"
  )
})

test_that("stabilize_lst() scopes nested .required (#291)", {
  spec <- function(x, req) {
    stabilize_lst(x, .named = TRUE, .required = req)
  }
  nested <- list(card = list(address = c("zip", "city")))
  flat <- list(card = "address", address = c("zip", "city"))
  expect_no_error(spec(list(address = 1), nested))
  expect_pkg_error_classes(
    spec(list(address = 1), flat),
    "stbl",
    "missing_element"
  )
  expect_no_error(spec(list(card = 1), nested))
  expect_pkg_error_classes(
    spec(list(card = 1, address = 1, zip = 1), nested),
    "stbl",
    "missing_element"
  )
  expect_no_error(spec(list(card = 1, address = 1, zip = 1, city = 1), nested))
})

test_that("stabilize_lst() validates .required (#291)", {
  expect_pkg_error_classes(
    stabilize_lst(list(a = 1), .named = TRUE, .required = list(a = list(1))),
    "stbl",
    "bad_required"
  )
  expect_pkg_error_classes(
    stabilize_lst(
      list(a = 1),
      .named = TRUE,
      .required = list(a = NA_character_)
    ),
    "stbl",
    "bad_required"
  )
})

test_that("stabilize_lst() requires names in .required without specs (#291)", {
  expect_pkg_error_classes(
    stabilize_lst(
      list(a = 1L),
      a = stabilize_int_scalar,
      .required = c("a", "z")
    ),
    "stbl",
    "missing_element"
  )
  given <- list(a = 1L, z = "anything")
  # NULL: known but unchecked.
  expect_identical(
    stabilize_lst(given, a = stabilize_int_scalar, .required = c("a", "z")),
    given
  )
  # TRUE: ordinary extra element.
  expect_identical(
    stabilize_lst(
      given,
      a = stabilize_int_scalar,
      .required = c("a", "z"),
      .named = TRUE
    ),
    given
  )
  # A function validates it.
  expect_pkg_error_classes(
    stabilize_lst(
      given,
      a = stabilize_int_scalar,
      .required = c("a", "z"),
      .named = stabilize_int_scalar
    ),
    "stbl",
    "incompatible_values",
    "integer"
  )
})

test_that("stabilize_lst() errors early for unspecced .required with .named = FALSE (#291)", {
  expect_pkg_error_snapshot(
    stabilize_lst(list(a = 1L), .required = "a", .named = FALSE),
    "stbl",
    "bad_required"
  )
  expect_pkg_error_classes(
    stabilize_lst(NULL, .required = "a", .named = FALSE),
    "stbl",
    "bad_required"
  )
  expect_pkg_error_classes(
    stabilize_lst(
      list(),
      .required = list(a = "b"),
      .named = FALSE,
      a = stabilize_int_scalar
    ),
    "stbl",
    "bad_required"
  )
  expect_identical(
    stabilize_lst(
      list(a = 1L),
      a = stabilize_int_scalar,
      .required = "a",
      .named = FALSE
    ),
    list(a = 1L)
  )
})

test_that("stabilize_lst() applies .patterns to matching names (#292)", {
  expect_identical(
    stabilize_lst(
      list(S_a = "x", S_b = "y", I_n = 1.0, 2),
      .patterns = list("^S_" = stabilize_chr, "^I_" = stabilize_int),
      .unnamed = TRUE
    ),
    list(S_a = "x", S_b = "y", I_n = 1L, 2)
  )
  expect_identical(
    stabilize_lst(list(), .patterns = list("a" = to_int)),
    list()
  )
})

test_that("stabilize_lst() treats pattern-matched names as known (#292)", {
  patterns <- list("^S_" = stabilize_int)
  expect_identical(
    stabilize_lst(list(S_a = 1L), .patterns = patterns, .named = FALSE),
    list(S_a = 1L)
  )
  expect_pkg_error_snapshot(
    stabilize_lst(list(S_a = 1L, b = 1L), .patterns = patterns),
    "stbl",
    "bad_named"
  )
  expect_identical(
    stabilize_lst(
      list(S_a = 1L, b = "1"),
      .patterns = patterns,
      .named = stabilize_int
    ),
    list(S_a = 1L, b = 1L)
  )
})

test_that("stabilize_lst() counts .patterns as specs for .required (#292)", {
  expect_identical(
    stabilize_lst(
      list(S_a = 1L),
      .patterns = list("^S_" = stabilize_int),
      .required = "S_a",
      .named = FALSE
    ),
    list(S_a = 1L)
  )
  expect_pkg_error_classes(
    stabilize_lst(
      list(S_a = 1L),
      .patterns = list("^T_" = stabilize_int),
      .required = "S_a",
      .named = FALSE
    ),
    "stbl",
    "bad_required"
  )
})

test_that("stabilize_lst() combines exact specs and .patterns (#292)", {
  expect_identical(
    stabilize_lst(
      list(S_a = 1),
      S_a = stabilize_dbl,
      .patterns = list("^S_" = stabilize_int)
    ),
    list(S_a = 1L)
  )
  expect_identical(
    stabilize_lst(
      list(S_a = 1, S_a = 2),
      S_a = stabilize_dbl,
      .patterns = list("^S_" = stabilize_int),
      .allow_duplicate_names = TRUE
    ),
    list(S_a = 1L, S_a = 2L)
  )
  expect_pkg_error_classes(
    stabilize_lst(
      list(S_a = 1.5),
      S_a = stabilize_dbl,
      .patterns = list("^S_" = stabilize_int)
    ),
    "stbl",
    "cant_stabilize_patterns"
  )
})

test_that("stabilize_lst() validates .patterns before .x (#292)", {
  expect_pkg_error_classes(
    stabilize_lst(stop("touched"), .patterns = "a"),
    "stbl",
    "bad_patterns",
    "not_list"
  )
})

test_that("stabilize_lst() .patterns work with .simplify (#292)", {
  expect_identical(
    stabilize_lst(
      list(S_a = 1, S_b = 2),
      .patterns = list("^S_" = stabilize_int_scalar),
      .simplify = TRUE
    ),
    c(S_a = 1L, S_b = 2L)
  )
})

test_that("stabilize_lst() applies exact specs to duplicate names (#292)", {
  expect_identical(
    stabilize_lst(
      list(a = 1, a = 2),
      a = stabilize_int,
      .allow_duplicate_names = TRUE
    ),
    list(a = 1L, a = 2L)
  )
})

test_that(".call_specified_fn() forwards .to_arg and .x_class only to specs that accept them (#419)", {
  spec <- function(x, to_arg = "none", x_class = "default") {
    paste(to_arg, x_class)
  }
  expect_identical(
    .call_specified_fn(
      spec,
      1,
      .x_arg = "x",
      .call = NULL,
      .to_arg = "to",
      .x_class = "cls"
    ),
    "to cls"
  )
  expect_identical(
    .call_specified_fn(spec, 1, .x_arg = "x", .call = NULL),
    "none default"
  )
  expect_identical(
    .call_specified_fn(
      to_int,
      "1",
      .x_arg = "x",
      .call = NULL,
      .to_arg = "to",
      .x_class = "cls"
    ),
    1L
  )
})
