test_that("reconcile() returns the narrowest of equivalent atomic values (#408)", {
  expect_identical(reconcile(1L, 1), 1L)
  expect_identical(reconcile(1, 1L), 1L)
  expect_identical(reconcile(as.double(1:10), 1:10), 1:10)
  expect_identical(reconcile("1", 1L, 1), 1L)
  expect_identical(reconcile(1, "1"), 1)
  expect_identical(reconcile(1L, TRUE), TRUE)
  expect_identical(reconcile("TRUE", TRUE), TRUE)
  expect_identical(
    reconcile(c(a = 1, b = NA), c(a = 1L, b = NA_integer_)),
    c(a = 1L, b = NA_integer_)
  )
})

test_that("reconcile() returns a single value unchanged (#408)", {
  expect_identical(reconcile(1.5), 1.5)
  expect_identical(reconcile(list(a = 1)), list(a = 1))
})

test_that("reconcile() errors with no values (#408)", {
  expect_pkg_error_snapshot(reconcile(), "stbl", "empty_values")
})

test_that("reconcile() rejects lossy and non-equivalent atomic pairs (#408)", {
  expect_pkg_error_snapshot(reconcile(0.5, TRUE), "stbl", "cant_reconcile")
  expect_pkg_error_classes(reconcile("1.0", 1L), "stbl", "cant_reconcile")
  expect_pkg_error_classes(reconcile("true", TRUE), "stbl", "cant_reconcile")
  expect_pkg_error_classes(reconcile(2^31, 1L), "stbl", "cant_reconcile")
  expect_pkg_error_classes(reconcile(Inf, 1L), "stbl", "cant_reconcile")
})

test_that("reconcile() handles NA and NaN (#408)", {
  expect_identical(reconcile(NA, NA_integer_, NA_real_, NA_character_), NA)
  expect_pkg_error_classes(reconcile(NA_real_, NaN), "stbl", "cant_reconcile")
  expect_pkg_error_classes(
    reconcile(NaN, NA_integer_),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() handles empty vectors (#408)", {
  expect_identical(reconcile(integer(), double()), integer())
  expect_identical(reconcile(character(), logical()), logical())
  expect_pkg_error_snapshot(reconcile(integer(), 1L), "stbl", "cant_reconcile")
})

test_that("reconcile() requires matching names (#408)", {
  expect_pkg_error_snapshot(
    reconcile(c(a = 1), c(b = 1L)),
    "stbl",
    "cant_reconcile"
  )
  expect_pkg_error_classes(reconcile(c(a = 1), 1L), "stbl", "cant_reconcile")
})

test_that("reconcile() treats lists and atomic vectors as different categories (#408)", {
  expect_pkg_error_snapshot(
    reconcile(1:2, list(1, 2)),
    "stbl",
    "cant_reconcile"
  )
  expect_pkg_error_classes(reconcile(NULL, list()), "stbl", "cant_reconcile")
})

test_that("reconcile() reconciles factors and character vectors (#408)", {
  fct <- factor(c("a", "b"), levels = c("b", "a"))
  expect_identical(reconcile(c("a", "b"), fct), fct)
  expect_identical(reconcile(fct, c("a", "b")), fct)
  unused <- factor("a", levels = c("a", "z"))
  expect_identical(reconcile("a", unused), unused)
  ord <- factor("a", levels = c("a", "b"), ordered = TRUE)
  expect_identical(reconcile("a", ord), ord)
})

test_that("reconcile() rejects factors that are not identical (#408)", {
  expect_pkg_error_snapshot(
    reconcile("c", factor("a", levels = c("a", "b"))),
    "stbl",
    "cant_reconcile"
  )
  expect_pkg_error_snapshot(
    reconcile(
      factor(c("a", "b")),
      factor(c("a", "b"), levels = c("b", "a"))
    ),
    "stbl",
    "cant_reconcile"
  )
  expect_pkg_error_snapshot(
    reconcile(factor("a"), factor("a", ordered = TRUE)),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() reconciles Dates and date-times independent of the session time zone (#408)", {
  date <- as.Date("2024-01-02")
  for (tz in c("UTC", "Pacific/Auckland", "America/Los_Angeles")) {
    withr::local_timezone(tz)
    utc <- as.POSIXct("2024-01-02 00:00:00", tz = "UTC")
    tokyo <- as.POSIXct("2024-01-02 00:00:00", tz = "Asia/Tokyo")
    expect_identical(reconcile(date, "2024-01-02"), date)
    expect_identical(reconcile(date, utc), date)
    expect_identical(reconcile(utc, date), date)
    # to() reads a Date as UTC midnight, which is 9 AM in Tokyo
    expect_error(
      reconcile(date, tokyo),
      class = "stbl-error-cant_reconcile"
    )
    expect_identical(
      reconcile(date, as.POSIXct("2024-01-02 09:00:00", tz = "Asia/Tokyo")),
      date
    )
  }
})

test_that("reconcile() rejects date-times with different time zones (#408)", {
  utc <- as.POSIXct("2024-01-02 00:00:00", tz = "UTC")
  tokyo <- as.POSIXct("2024-01-02 00:00:00", tz = "Asia/Tokyo")
  expect_pkg_error_snapshot(reconcile(utc, tokyo), "stbl", "cant_reconcile")
})

test_that("reconcile() reconciles hms and Period values (#408)", {
  skip_if_not_installed("hms")
  skip_if_not_installed("lubridate")
  expect_identical(reconcile(hms::hms(3600), 3600), hms::hms(3600))
  period <- lubridate::seconds(5)
  expect_identical(reconcile(period, period), period)
  expect_pkg_error_snapshot(
    reconcile(period, lubridate::seconds(6)),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() compares unranked types with vctrs (#408)", {
  expect_identical(reconcile(1i, 1i), 1i)
  expect_identical(reconcile(as.raw(1), as.raw(1)), as.raw(1))
  one_i <- 1i
  two_i <- 2i
  expect_pkg_error_snapshot(reconcile(one_i, two_i), "stbl", "cant_reconcile")
  expect_pkg_error_classes(reconcile(1i, 1), "stbl", "cant_reconcile")
  expect_pkg_error_snapshot(
    reconcile(as.raw(1), as.raw(1), one_i),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() treats classed objects and other objects as equivalent only to equal values (#408)", {
  foo <- structure(1, class = "foo")
  expect_identical(reconcile(foo, foo), foo)
  expect_pkg_error_snapshot(reconcile(foo, 1), "stbl", "cant_reconcile")
  env <- new.env()
  expect_identical(reconcile(env, env), env)
  expect_pkg_error_snapshot(reconcile(env, new.env()), "stbl", "cant_reconcile")
})

test_that("reconcile() combines the narrowest elements of lists (#408)", {
  expect_identical(
    reconcile(list(a = 1L, b = 2), list(a = 1, b = 2L)),
    list(a = 1L, b = 2L)
  )
  expect_identical(
    reconcile(list(1, NULL, "a"), list(1L, NULL, "a")),
    list(1L, NULL, "a")
  )
  expect_identical(
    reconcile(list(a = list(b = 1)), list(a = list(b = 1L))),
    list(a = list(b = 1L))
  )
})

test_that("reconcile() reports the path to nested differences (#408)", {
  expect_pkg_error_snapshot(
    reconcile(list(a = list(1, 2:3)), list(a = list(1, c(2L, 4L)))),
    "stbl",
    "cant_reconcile"
  )
  expect_pkg_error_snapshot(
    reconcile(list(`a b` = 1), list(`a b` = "x")),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() requires matching list structure (#408)", {
  expect_pkg_error_snapshot(
    reconcile(list(1), list(1, 2)),
    "stbl",
    "cant_reconcile"
  )
  expect_pkg_error_snapshot(
    reconcile(list(a = 1), list(b = 1)),
    "stbl",
    "cant_reconcile"
  )
  attributed <- structure(list(1), extra = "x")
  expect_pkg_error_snapshot(
    reconcile(attributed, list(1)),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() reconciles data frames column by column (#408)", {
  expect_identical(
    reconcile(
      data.frame(a = 1L, b = 2),
      data.frame(a = 1, b = 2L)
    ),
    data.frame(a = 1L, b = 2L)
  )
  skip_if_not_installed("tibble")
  expect_identical(
    reconcile(tibble::tibble(a = 1L), tibble::tibble(a = 1)),
    tibble::tibble(a = 1L)
  )
})

test_that("reconcile() requires matching data frame structure (#408)", {
  expect_pkg_error_snapshot(
    reconcile(data.frame(a = 1), data.frame(b = 1)),
    "stbl",
    "cant_reconcile"
  )
  expect_pkg_error_snapshot(
    reconcile(data.frame(a = 1, b = 2), data.frame(b = 2, a = 1)),
    "stbl",
    "cant_reconcile"
  )
  expect_pkg_error_snapshot(
    reconcile(data.frame(a = 1), data.frame(a = 1, row.names = "x")),
    "stbl",
    "cant_reconcile"
  )
  skip_if_not_installed("tibble")
  expect_pkg_error_snapshot(
    reconcile(data.frame(a = 1), tibble::tibble(a = 1)),
    "stbl",
    "cant_reconcile"
  )
  expect_pkg_error_snapshot(
    reconcile(data.frame(a = 1), list(a = 1)),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() only treats identical functions and NULL as equivalent (#408)", {
  expect_null(reconcile(NULL, NULL))
  expect_identical(reconcile(mean, mean), mean)
  expect_pkg_error_snapshot(reconcile(mean, median), "stbl", "cant_reconcile")
})

test_that("reconcile() checks every pair of three or more values (#408)", {
  # "TRUE" ~ TRUE and TRUE ~ 1L, but "TRUE" !~ 1L
  expect_pkg_error_snapshot(
    reconcile("TRUE", TRUE, 1L),
    "stbl",
    "cant_reconcile"
  )
  expect_pkg_error_snapshot(
    reconcile(1L, TRUE, "TRUE"),
    "stbl",
    "cant_reconcile"
  )
})


test_that("reconcile() doesn't depend on the order of the values (#408)", {
  values <- list(
    1L,
    1,
    "1",
    TRUE,
    c(a = 1),
    "a",
    factor("a"),
    list(a = 1L),
    list(a = 1),
    as.Date("2024-01-02"),
    "2024-01-02"
  )
  safely <- function(...) tryCatch(reconcile(...), error = \(cnd) "error")
  for (i in seq_along(values)) {
    for (j in seq_along(values)) {
      expect_identical(
        safely(values[[i]], values[[j]]),
        safely(values[[j]], values[[i]])
      )
    }
  }
})

test_that("reconcile() uses names as labels (#408)", {
  expect_pkg_error_snapshot(
    reconcile(first = 0.5, second = TRUE),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() reports errors from the caller's perspective (#408)", {
  expect_pkg_error_snapshot(
    wrapped_reconcile(0.5, TRUE),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() compares pairlists like lists (#408)", {
  expect_identical(
    reconcile(pairlist(a = 1L), pairlist(a = 1)),
    list(a = 1L)
  )
  expect_pkg_error_snapshot(
    reconcile(pairlist(a = 1L), pairlist(a = 2L)),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() recurses through deeply nested lists (#408)", {
  nest <- function(depth, leaf) {
    for (i in seq_len(depth)) {
      leaf <- list(leaf)
    }
    leaf
  }
  expect_identical(reconcile(nest(200, 1L), nest(200, 1)), nest(200, 1L))
  expect_pkg_error_classes(
    reconcile(nest(200, 1L), nest(200, 2L)),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() compares attributes as a set (#408)", {
  expect_pkg_error_snapshot(
    reconcile(
      structure(list(1), foo = "x"),
      structure(list(1), bar = "x")
    ),
    "stbl",
    "cant_reconcile"
  )
})

test_that("reconcile() leaves vectors with extra attributes to R (#408)", {
  expect_pkg_error_classes(
    reconcile(structure(1L, foo = "x"), 1),
    "stbl",
    "cant_reconcile"
  )
  bad_levels <- structure(1L, levels = 1L, class = "factor")
  expect_pkg_error_classes(reconcile("a", bad_levels), "stbl", "cant_reconcile")
})

test_that("reconcile() explains length and name differences for classed vectors (#408)", {
  skip_if_not_installed("hms")
  expect_pkg_error_snapshot(
    reconcile(hms::hms(1), hms::hms(1:2)),
    "stbl",
    "cant_reconcile"
  )
  expect_pkg_error_snapshot(
    reconcile(stats::setNames(hms::hms(1), "a"), hms::hms(1)),
    "stbl",
    "cant_reconcile"
  )
})

test_that(".reconcile() requires a non-empty list (#408)", {
  expect_error(.reconcile(list()), "at least one")
})
