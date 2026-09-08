test_that("locale_datetime_formats() prefers month-first for US locales (#326)", {
  expect_identical(
    locale_datetime_formats("en_US.UTF-8"),
    c(
      "%Y-%m-%dT%H:%M:%S",
      "%Y-%m-%d %H:%M:%S",
      "%Y-%m-%d",
      "%m/%d/%Y %H:%M:%S",
      "%m/%d/%Y",
      "%m-%d-%Y %H:%M:%S",
      "%m-%d-%Y"
    )
  )
})

test_that("locale_datetime_formats() prefers day-first for other locales (#326)", {
  expect_identical(
    locale_datetime_formats("en_GB.UTF-8"),
    c(
      "%Y-%m-%dT%H:%M:%S",
      "%Y-%m-%d %H:%M:%S",
      "%Y-%m-%d",
      "%d/%m/%Y %H:%M:%S",
      "%d/%m/%Y",
      "%d-%m-%Y %H:%M:%S",
      "%d-%m-%Y"
    )
  )
})

test_that("locale_datetime_formats() recognizes Windows-style US locale strings (#326)", {
  expect_identical(
    locale_datetime_formats("English_United States.1252"),
    locale_datetime_formats("en_US.UTF-8")
  )
})

test_that("locale_datetime_formats() defaults to Sys.getlocale('LC_TIME') (#326)", {
  expect_identical(
    locale_datetime_formats(),
    locale_datetime_formats(Sys.getlocale("LC_TIME"))
  )
})
