# identity conversions ---------------------------------------------------------

test_that("to() returns logical unchanged (#182)", {
  given <- c(TRUE, FALSE, NA)
  expect_identical(to(given, logical()), given)
})

test_that("to() returns integer unchanged (#182)", {
  given <- 1:5
  expect_identical(to(given, integer()), given)
})

test_that("to() returns double unchanged (#182)", {
  given <- c(1.5, 2.5, NA_real_)
  expect_identical(to(given, double()), given)
})

test_that("to() returns character unchanged (#182)", {
  given <- c("a", "b", NA_character_)
  expect_identical(to(given, character()), given)
})

# NULL input -------------------------------------------------------------------

test_that("to() passes NULL through unchanged (#182)", {
  expect_null(to(NULL, integer()))
  expect_null(to(NULL, double()))
  expect_null(to(NULL, character()))
  expect_null(to(NULL, logical()))
})

# to logical -------------------------------------------------------------------

test_that("to() converts integer to logical (#182)", {
  expect_identical(to(1L, logical()), TRUE)
  expect_identical(to(0L, logical()), FALSE)
  expect_identical(to(NA_integer_, logical()), NA)
})

test_that("to() converts double to logical (#182)", {
  expect_identical(to(1.0, logical()), TRUE)
  expect_identical(to(0.0, logical()), FALSE)
  expect_identical(to(NA_real_, logical()), NA)
})

test_that("to() converts character to logical (#182)", {
  expect_identical(to("TRUE", logical()), TRUE)
  expect_identical(to("FALSE", logical()), FALSE)
  expect_identical(to(NA_character_, logical()), NA)
})

test_that("to() errors for incompatible character -> logical (#182)", {
  expect_error(to("xyz", logical()))
})

test_that("to() converts factor to logical (#182)", {
  fct <- factor(c("TRUE", "FALSE"))
  expect_identical(to(fct, logical()), c(TRUE, FALSE))
})

test_that("to() errors for incompatible factor -> logical (#182)", {
  fct <- factor(c("a", "b"))
  expect_error(to(fct, logical()))
})

test_that("to() converts list to logical (#182)", {
  expect_identical(to(list(TRUE, FALSE), logical()), c(TRUE, FALSE))
})

# to integer -------------------------------------------------------------------

test_that("to() converts logical to integer (#182)", {
  expect_identical(to(TRUE, integer()), 1L)
  expect_identical(to(FALSE, integer()), 0L)
  expect_identical(to(NA, integer()), NA_integer_)
})

test_that("to() converts double to integer (#182)", {
  expect_identical(to(1.0, integer()), 1L)
  expect_identical(to(c(1.0, 2.0, NA_real_), integer()), c(1L, 2L, NA_integer_))
})

test_that("to() errors for double -> integer with precision loss (#182)", {
  expect_error(to(1.5, integer()))
})

test_that("to() converts character to integer (#182)", {
  expect_identical(to("1", integer()), 1L)
  expect_identical(to(c("1", "2"), integer()), c(1L, 2L))
})

test_that("to() errors for incompatible character -> integer (#182)", {
  expect_error(to("abc", integer()))
})

test_that("to() converts factor to integer (#182)", {
  fct <- factor(c("1", "2", "3"))
  expect_identical(to(fct, integer()), c(1L, 2L, 3L))
})

test_that("to() converts list to integer (#182)", {
  expect_identical(to(list(1L, 2L), integer()), c(1L, 2L))
})

# to double --------------------------------------------------------------------

test_that("to() converts integer to double (#182)", {
  expect_identical(to(1L, double()), 1.0)
  expect_identical(to(c(1L, 2L, NA_integer_), double()), c(1.0, 2.0, NA_real_))
})

test_that("to() converts logical to double (#182)", {
  expect_identical(to(TRUE, double()), 1.0)
  expect_identical(to(FALSE, double()), 0.0)
})

test_that("to() converts character to double (#182)", {
  expect_identical(to("3.14", double()), 3.14)
  expect_identical(to(c("1", "2.5"), double()), c(1.0, 2.5))
})

test_that("to() errors for incompatible character -> double (#182)", {
  expect_error(to("xyz", double()))
})

test_that("to() converts factor to double (#182)", {
  fct <- factor(c("1.5", "2.5"))
  expect_identical(to(fct, double()), c(1.5, 2.5))
})

test_that("to() converts list to double (#182)", {
  expect_identical(to(list(1.0, 2.0), double()), c(1.0, 2.0))
})

# to character -----------------------------------------------------------------

test_that("to() converts integer to character (#182)", {
  expect_identical(to(1L, character()), "1")
  expect_identical(to(c(1L, 2L), character()), c("1", "2"))
})

test_that("to() converts double to character (#182)", {
  expect_identical(to(1.5, character()), "1.5")
})

test_that("to() converts logical to character (#182)", {
  expect_identical(to(TRUE, character()), "TRUE")
  expect_identical(to(FALSE, character()), "FALSE")
})

test_that("to() converts factor to character (#182)", {
  fct <- factor(c("a", "b"))
  expect_identical(to(fct, character()), c("a", "b"))
})

test_that("to() converts list to character (#182)", {
  expect_identical(to(list("a", "b"), character()), c("a", "b"))
})

# to factor (R-level) ----------------------------------------------------------

test_that("to() converts character to factor using .to levels (#182)", {
  proto <- factor(levels = c("a", "b", "c"))
  result <- to("a", proto)
  expect_identical(class(result), "factor")
  expect_identical(levels(result), c("a", "b", "c"))
  expect_identical(as.character(result), "a")
})

test_that("to() converts integer to factor using .to levels (#182)", {
  proto <- factor(levels = c("1", "2", "3"))
  result <- to(1L, proto)
  expect_identical(class(result), "factor")
  expect_identical(as.character(result), "1")
})

test_that("to() passes levels through from factor .to (#182)", {
  proto <- factor(c("x", "y"), levels = c("x", "y", "z"))
  result <- to(c("x", "z"), proto)
  expect_identical(levels(result), c("x", "y", "z"))
})

test_that("to() respects explicit levels argument in to.factor (#182)", {
  proto <- factor(levels = c("a", "b", "c"))
  result <- to("a", proto, levels = c("a", "b"))
  expect_identical(levels(result), c("a", "b"))
})

test_that("to() preserves ordered input when converting to factor (#246)", {
  proto <- factor(levels = c("a", "b"))
  given <- ordered("a", levels = c("a", "b"))
  result <- to(given, proto)
  expect_s3_class(result, "ordered")
  expect_identical(levels(result), c("a", "b"))
})

test_that("to() uses orderedness from factor .to (#246)", {
  proto <- ordered(NA_character_, levels = c("a", "b"))
  result <- to("a", proto)
  expect_s3_class(result, "ordered")
  expect_identical(levels(result), c("a", "b"))
})

test_that("to() respects to_na argument in to.factor (#182)", {
  proto <- factor(levels = c("a", "b", "c"))
  result <- to(c("a", "b"), proto, to_na = "b")
  expect_true(is.na(result[[2L]]))
})

# to list (R-level) ------------------------------------------------------------

test_that("to() converts to list (#182)", {
  result <- to(1:3, list())
  expect_type(result, "list")
  expect_length(result, 3L)
})

test_that("to() treats language input as data for list targets (#366)", {
  given <- quote(a + b)
  expect_identical(to(given, list()), as.list(given))
})

# allow_null -------------------------------------------------------------------

test_that("to() returns NULL by default when x is NULL (#182)", {
  expect_null(to(NULL, integer()))
  expect_null(to(NULL, double()))
  expect_null(to(NULL, character()))
  expect_null(to(NULL, logical()))
  expect_null(to(NULL, factor()))
  expect_null(to(NULL, list()))
})

test_that("to() errors when x is NULL and allow_null = FALSE (#182)", {
  expect_error(to(NULL, integer(), allow_null = FALSE))
  expect_error(to(NULL, double(), allow_null = FALSE))
  expect_error(to(NULL, character(), allow_null = FALSE))
  expect_error(to(NULL, logical(), allow_null = FALSE))
  expect_error(to(NULL, factor(), allow_null = FALSE))
  expect_error(to(NULL, list(), allow_null = FALSE))
})

# to data frame ----------------------------------------------------------------

test_that("to() passes data frame through unchanged with data frame target (#182)", {
  df <- mtcars
  expect_identical(to(df, mtcars[0, ]), df)
})

test_that("to() converts list to data frame (#182)", {
  given <- list(name = c("Alice", "Bob"), age = c(30L, 25L))
  result <- to(given, data.frame())
  expect_s3_class(result, "data.frame")
  expect_equal(names(result), c("name", "age"))
})

test_that("to() converts vector to data frame (#182)", {
  given <- c("a", "b", "c")
  result <- to(given, data.frame())
  expected <- data.frame(x = c("a", "b", "c"), stringsAsFactors = FALSE)
  expect_identical(result, expected)
})

# to NULL (target) --------------------------------------------------------------

test_that("to() returns NULL when .to is NULL (#182)", {
  expect_null(to(1L, NULL))
  expect_null(to("x", NULL))
  expect_null(to(c(1, 2, 3), NULL))
})

test_that("to() errors when .to is NULL and allow_null = FALSE (#182)", {
  expect_error(to(1L, NULL, allow_null = FALSE))
})

# coerce_character -------------------------------------------------------------

test_that("to() respects coerce_character = FALSE for integer target (#182)", {
  expect_error(to("1", integer(), coerce_character = FALSE))
})

test_that("to() respects coerce_character = FALSE for double target (#182)", {
  expect_error(to("1.5", double(), coerce_character = FALSE))
})

# to function ------------------------------------------------------------------

test_that("to() converts character to function (#250)", {
  expect_identical(to("mean", mean), mean)
  expect_identical(to("stats::median", mean), stats::median)
})

test_that("to() passes function through unchanged (#250)", {
  expect_identical(to(mean, mean), mean)
})

test_that("to() converts formula to function (#250)", {
  expect_identical(to(~ . + 1, mean), rlang::as_function(~ . + 1))
})

test_that("to() errors for non-coercible types to function (#250)", {
  expect_snapshot(to(1L, mean), error = TRUE)
})

# to Date ----------------------------------------------------------------------

test_that("to() converts character to Date (#366)", {
  expect_identical(
    to("2024-01-01", as.Date("2024-01-01")),
    as.Date("2024-01-01")
  )
})

test_that("to() passes Date through unchanged (#366)", {
  given <- as.Date("2024-01-01")
  expect_identical(to(given, as.Date("2024-01-01")), given)
})

test_that("to() converts POSIXct to Date (#366)", {
  given <- as.POSIXct("2024-01-01 12:00:00", tz = "UTC")
  expect_identical(to(given, as.Date("2024-01-01")), as.Date("2024-01-01"))
})

test_that("to() errors for incompatible character -> Date (#366)", {
  expect_error(to("not-a-date", as.Date("2024-01-01")))
})

# to POSIXct -------------------------------------------------------------------

test_that("to() converts character to POSIXct (#366)", {
  result <- to("2024-01-01T12:00:00Z", as.POSIXct("2024-01-01", tz = "UTC"))
  expect_s3_class(result, "POSIXct")
  expect_identical(result, as.POSIXct("2024-01-01 12:00:00", tz = "UTC"))
})

test_that("to() uses tzone from POSIXct .to (#366)", {
  proto <- as.POSIXct("2024-01-01", tz = "America/Chicago")
  result <- to("2024-01-01T12:00:00Z", proto)
  expect_identical(attr(result, "tzone"), "America/Chicago")
})

test_that("to() defaults to UTC when POSIXct .to has empty tzone (#366)", {
  proto <- as.POSIXct("2024-01-01 12:00:00")
  attr(proto, "tzone") <- ""
  result <- to("2024-01-01T12:00:00Z", proto)
  expect_identical(attr(result, "tzone"), "UTC")
})

test_that("to() uses first element of a 3-element tzone attribute (#366)", {
  proto <- as.POSIXct("2024-01-01", tz = "America/Chicago")
  attr(proto, "tzone") <- c("America/Chicago", "CST", "CDT")
  result <- to("2024-01-01T12:00:00Z", proto)
  expect_identical(attr(result, "tzone"), "America/Chicago")
})

test_that("to() defaults to UTC when POSIXct .to has empty tzone attribute (#366)", {
  proto <- as.POSIXct("2024-01-01 12:00:00")
  attr(proto, "tzone") <- character()
  result <- to("2024-01-01T12:00:00Z", proto)
  expect_identical(attr(result, "tzone"), "UTC")
})

test_that("to() converts Date to POSIXct (#366)", {
  result <- to(as.Date("2024-01-01"), as.POSIXct("2024-01-01", tz = "UTC"))
  expect_s3_class(result, "POSIXct")
})

test_that("to() errors for incompatible character -> POSIXct (#366)", {
  expect_error(to("not-a-datetime", as.POSIXct("2024-01-01", tz = "UTC")))
})

# to hms -----------------------------------------------------------------------

test_that("to() converts character to hms (#366)", {
  skip_if_not_installed("hms")
  expect_identical(
    to("13:20:00Z", hms::hms()),
    hms::as_hms("13:20:00")
  )
})

test_that("to() passes hms through unchanged (#366)", {
  skip_if_not_installed("hms")
  given <- hms::as_hms("13:20:00")
  expect_identical(to(given, hms::hms()), given)
})

test_that("to() errors for incompatible character -> hms (#366)", {
  skip_if_not_installed("hms")
  expect_error(to("not-a-time", hms::hms()))
})

# to Period --------------------------------------------------------------------

test_that("to() converts character to Period (#366)", {
  skip_if_not_installed("lubridate")
  result <- to("P1Y", lubridate::period())
  expect_s4_class(result, "Period")
})

test_that("to() passes Period through unchanged (#366)", {
  skip_if_not_installed("lubridate")
  given <- lubridate::period(1, "year")
  expect_identical(to(given, lubridate::period()), given)
})

test_that("to() errors for incompatible character -> Period (#366)", {
  skip_if_not_installed("lubridate")
  expect_error(to("not-a-duration", lubridate::period()))
})

# vctrs fallback ---------------------------------------------------------------

test_that("to() falls back to vctrs::vec_cast for unknown prototypes (#367)", {
  # vctrs supports rational-class casts that stbl does not dispatch on.
  proto <- vctrs::new_rcrd(
    list(a = integer(), b = integer()),
    class = "vctrs_rational"
  )
  given <- vctrs::new_rcrd(list(a = 1L, b = 2L), class = "vctrs_rational")
  expect_identical(to(given, proto), given)
})

test_that("to() routes POSIXlt prototypes through vctrs (#366)", {
  proto <- as.POSIXlt("2024-01-01", tz = "UTC")
  result <- to(proto, proto)
  expect_s3_class(result, "POSIXlt")
})

test_that("to() routes difftime prototypes through vctrs (#366)", {
  proto <- as.difftime(1, units = "days")
  result <- to(proto, proto)
  expect_s3_class(result, "difftime")
})

test_that("to() routes tibble prototypes through vctrs (#367)", {
  skip_if_not_installed("tibble")
  proto <- tibble::tibble(a = integer())
  result <- to(data.frame(a = 1L), proto)
  expect_s3_class(result, "tbl_df")
  expect_identical(result$a, 1L)
})

test_that("to() routes list_of prototypes through vctrs (#367)", {
  proto <- vctrs::list_of(integer())
  result <- to(list(1L, 2L), proto)
  expect_s3_class(result, "vctrs_list_of")
})

test_that("to() routes matrix targets through vctrs (#366)", {
  expect_identical(
    to(1:4, matrix(0L, 2, 2)),
    vctrs::vec_cast(1:4, matrix(0L, 2, 2))
  )
  expect_identical(
    to(c(1.5, 2.5), matrix(0.0, 1, 2)),
    vctrs::vec_cast(c(1.5, 2.5), matrix(0.0, 1, 2))
  )
  expect_identical(
    to(c(TRUE, FALSE), matrix(TRUE, 1, 2)),
    vctrs::vec_cast(c(TRUE, FALSE), matrix(TRUE, 1, 2))
  )
  expect_identical(
    to(c("a", "b"), matrix("", 1, 2)),
    vctrs::vec_cast(c("a", "b"), matrix("", 1, 2))
  )
  expect_identical(
    to(1:8, array(0L, c(2, 2, 2))),
    vctrs::vec_cast(1:8, array(0L, c(2, 2, 2)))
  )
})

# unsupported ------------------------------------------------------------------

test_that("to() errors for unsupported target types (#182, #367)", {
  to(1L, as.raw(1L)) |>
    expect_pkg_error_classes("stbl", "coerce", "raw")
})
