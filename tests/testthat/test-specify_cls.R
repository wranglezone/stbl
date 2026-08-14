test_that(".specify_cls builds the expected function with no args (#150)", {
  baseline <- .specify_cls("chr")
  expect_identical(
    {
      baseline("a")
    },
    "a"
  )
  expect_s3_class(baseline, "stbl_specified_fn")
})

test_that(".specify_cls builds the expected function snapshot with no args (#150)", {
  baseline <- .specify_cls("chr")
  expect_snapshot(baseline, transform = clean_function_snapshot)
})

test_that(".specify_cls builds the expected function with at least one arg (#150, #161)", {
  no_null <- .specify_cls("chr", list(allow_null = FALSE))
  expect_identical(
    {
      no_null("a")
    },
    "a"
  )
  expect_pkg_error_classes(
    {
      no_null(NULL)
    },
    "stbl",
    "bad_null"
  )
})

test_that(".specify_cls builds the expected function snapshot with at least one arg (#150, #161)", {
  no_null <- .specify_cls("chr", list(allow_null = FALSE))
  expect_snapshot(no_null, transform = clean_function_snapshot)
})

test_that("The function built via .specify_cls errors informatively for duplicated args (#150, #153, #161)", {
  no_null <- .specify_cls("chr", list(allow_null = FALSE))
  expect_pkg_error_snapshot(
    {
      no_null(NULL, allow_null = FALSE)
    },
    "stbl",
    "duplicate_args"
  )
})

test_that(".specify_cls can build a scalar specifier (#150)", {
  scalar_checker <- .specify_cls("chr", scalar = TRUE)
  given <- "a"
  expect_identical(
    scalar_checker(given),
    given
  )
  expect_pkg_error_classes(
    scalar_checker(c("a", "b")),
    "stbl",
    "non_scalar"
  )
})

test_that(".specify_cls builds the expected scalar function snapshot (#150)", {
  scalar_checker <- .specify_cls("chr", scalar = TRUE)
  expect_snapshot(scalar_checker, transform = clean_function_snapshot)
})

# Class versions ----

test_that("specify_chr can build a regex checker (#147, #310)", {
  checker <- specify_chr(regex = r"(^\d{5}(?:[-\s]\d{4})?$)")
  given <- "12345-6789"
  expect_identical(
    checker(given),
    given
  )
  expect_pkg_error_classes(
    checker("invalid"),
    "stbl",
    "regex_mismatch"
  )
})

test_that("specify_chr can enforce unique elements (#280)", {
  checker <- specify_chr(unique = TRUE)
  expect_identical(checker(c("a", "b")), c("a", "b"))
  expect_pkg_error_classes(
    checker(c("a", "b", "a")),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_chr_scalar can build a regex checker (#147, #310)", {
  checker <- specify_chr_scalar(regex = r"(^\d{5}(?:[-\s]\d{4})?$)")
  given <- "12345-6789"
  expect_identical(
    checker(given),
    given
  )
  expect_pkg_error_classes(
    checker("invalid"),
    "stbl",
    "regex_mismatch"
  )
})

test_that("specify_chr_scalar defaults to allow_null = FALSE (#197)", {
  checker <- specify_chr_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_chr_scalar defaults to allow_zero_length = FALSE (#197)", {
  checker <- specify_chr_scalar()
  expect_pkg_error_classes(checker(character(0)), "stbl", "bad_empty")
  expect_identical(
    checker(character(0), allow_zero_length = TRUE),
    character(0)
  )
})

test_that("specify_dbl can build a value checker (#148)", {
  checker <- specify_dbl(min_value = 27.2)
  expect_identical(
    checker(30:40 + 0.1),
    30:40 + 0.1
  )
  expect_pkg_error_classes(
    checker(19.2),
    "stbl",
    "outside_range"
  )
})

test_that("specify_dbl can enforce unique elements (#280)", {
  checker <- specify_dbl(unique = TRUE)
  expect_identical(checker(c(1.1, 2.2)), c(1.1, 2.2))
  expect_pkg_error_classes(
    checker(c(1.1, 2.2, 1.1)),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_dbl_scalar can build a value checker (#148)", {
  checker <- specify_dbl_scalar(min_value = 27.2)
  expect_identical(
    checker(30.1),
    30.1
  )
  expect_pkg_error_classes(
    checker(30:40 + 0.1),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_dbl_scalar defaults to allow_null = FALSE (#197)", {
  checker <- specify_dbl_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_dbl_scalar defaults to allow_zero_length = FALSE (#197)", {
  checker <- specify_dbl_scalar()
  expect_pkg_error_classes(checker(double(0)), "stbl", "bad_empty")
  expect_identical(checker(double(0), allow_zero_length = TRUE), double(0))
})

test_that("specify_date can build a value checker (#104)", {
  checker <- specify_date(min_value = "2000-01-01")
  expect_identical(checker("2024-01-01"), as.Date("2024-01-01"))
  expect_pkg_error_classes(
    checker("1999-12-31"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_date can enforce unique elements (#104)", {
  checker <- specify_date(unique = TRUE)
  given <- as.Date(c("2024-01-01", "2024-06-15"))
  expect_identical(checker(given), given)
  expect_pkg_error_classes(
    checker(as.Date(c("2024-01-01", "2024-01-01"))),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_date_scalar can build a value checker (#104)", {
  checker <- specify_date_scalar(min_value = "2000-01-01")
  expect_identical(checker("2024-01-01"), as.Date("2024-01-01"))
  expect_pkg_error_classes(
    checker(as.Date(c("2024-01-01", "2024-06-15"))),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_date_scalar defaults to allow_null = FALSE (#104)", {
  checker <- specify_date_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_date_scalar defaults to allow_zero_length = FALSE (#104)", {
  checker <- specify_date_scalar()
  expect_pkg_error_classes(
    checker(as.Date(character(0))),
    "stbl",
    "bad_empty"
  )
  expect_identical(
    checker(as.Date(character(0)), allow_zero_length = TRUE),
    as.Date(character(0))
  )
})

test_that("specify_date can enforce allowed_values (#104)", {
  checker <- specify_date(allowed_values = c("2024-01-01", "2024-06-15"))
  expect_identical(checker("2024-01-01"), as.Date("2024-01-01"))
  expect_pkg_error_classes(checker("2024-07-01"), "stbl", "allowed_values")
})

test_that("specify_date() creates a working stabilizer (#104)", {
  stabilize_recent <- specify_date(min_value = "2000-01-01")
  expect_identical(stabilize_recent("2024-01-01"), as.Date("2024-01-01"))
  expect_pkg_error_classes(
    stabilize_recent("1999-12-31"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_date_scalar() creates a working scalar stabilizer (#104)", {
  stabilize_recent <- specify_date_scalar(min_value = "2000-01-01")
  expect_identical(stabilize_recent("2024-01-01"), as.Date("2024-01-01"))
  expect_pkg_error_classes(
    stabilize_recent(c("2024-01-01", "2024-06-15")),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_dttm can build a value checker (#105)", {
  checker <- specify_dttm(min_value = "2000-01-01T00:00:00Z")
  expect_identical(
    checker("2024-01-01T00:00:00Z"),
    to_dttm("2024-01-01T00:00:00Z")
  )
  expect_pkg_error_classes(
    checker("1999-12-31T00:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_dttm can enforce unique elements (#105)", {
  checker <- specify_dttm(unique = TRUE)
  given <- to_dttm(c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z"))
  expect_identical(checker(given), given)
  expect_pkg_error_classes(
    checker(to_dttm(c("2024-01-01T00:00:00Z", "2024-01-01T00:00:00Z"))),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_dttm respects tz (#105)", {
  checker <- specify_dttm(tz = "America/Chicago")
  result <- checker("2024-01-01T00:00:00Z")
  expect_identical(attr(result, "tzone"), "America/Chicago")
})

test_that("specify_dttm_scalar can build a value checker (#105)", {
  checker <- specify_dttm_scalar(min_value = "2000-01-01T00:00:00Z")
  expect_identical(
    checker("2024-01-01T00:00:00Z"),
    to_dttm("2024-01-01T00:00:00Z")
  )
  expect_pkg_error_classes(
    checker(to_dttm(c(
      "2024-01-01T00:00:00Z",
      "2024-06-15T00:00:00Z"
    ))),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_dttm_scalar defaults to allow_null = FALSE (#105)", {
  checker <- specify_dttm_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_dttm_scalar defaults to allow_zero_length = FALSE (#105)", {
  checker <- specify_dttm_scalar()
  empty <- to_dttm(character())
  expect_pkg_error_classes(checker(empty), "stbl", "bad_empty")
  expect_identical(
    checker(empty, allow_zero_length = TRUE),
    empty
  )
})

test_that("specify_dttm can enforce allowed_values (#105)", {
  checker <- specify_dttm(
    allowed_values = c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z")
  )
  expect_identical(
    checker("2024-01-01T00:00:00Z"),
    to_dttm("2024-01-01T00:00:00Z")
  )
  expect_pkg_error_classes(
    checker("2024-07-01T00:00:00Z"),
    "stbl",
    "allowed_values"
  )
})

test_that("specify_dttm() creates a working stabilizer (#105)", {
  stabilize_recent <- specify_dttm(min_value = "2000-01-01T00:00:00Z")
  expect_identical(
    stabilize_recent("2024-01-01T00:00:00Z"),
    to_dttm("2024-01-01T00:00:00Z")
  )
  expect_pkg_error_classes(
    stabilize_recent("1999-12-31T00:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_dttm_scalar() creates a working scalar stabilizer (#105)", {
  stabilize_recent <- specify_dttm_scalar(
    min_value = "2000-01-01T00:00:00Z"
  )
  expect_identical(
    stabilize_recent("2024-01-01T00:00:00Z"),
    to_dttm("2024-01-01T00:00:00Z")
  )
  expect_pkg_error_classes(
    stabilize_recent(c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z")),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_dur can build a value checker (#295)", {
  checker <- specify_dur(max_value = "P1D")
  expect_identical(checker("PT12H"), to_dur("PT12H"))
  expect_pkg_error_classes(
    checker("P2D"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_dur can enforce unique elements (#295)", {
  checker <- specify_dur(unique = TRUE)
  given <- to_dur(c("P1D", "P2D"))
  expect_identical(checker(given), given)
  expect_pkg_error_classes(
    checker(to_dur(c("P1D", "P1D"))),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_dur_scalar can build a value checker (#295)", {
  checker <- specify_dur_scalar(max_value = "P1D")
  expect_identical(checker("PT12H"), to_dur("PT12H"))
  expect_pkg_error_classes(
    checker(to_dur(c("P1D", "P2D"))),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_dur_scalar defaults to allow_null = FALSE (#295)", {
  checker <- specify_dur_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_dur_scalar defaults to allow_zero_length = FALSE (#295)", {
  checker <- specify_dur_scalar()
  empty <- to_dur(character())
  expect_pkg_error_classes(checker(empty), "stbl", "bad_empty")
  expect_identical(checker(empty, allow_zero_length = TRUE), empty)
})

test_that("specify_dur can enforce allowed_values (#295)", {
  checker <- specify_dur(
    allowed_values = c("P1D", "P2D")
  )
  expect_identical(checker("P1D"), to_dur("P1D"))
  expect_pkg_error_classes(checker("P3D"), "stbl", "allowed_values")
})

test_that("specify_dur() creates a working stabilizer (#295)", {
  stabilize_short <- specify_dur(max_value = "P1D")
  expect_identical(stabilize_short("PT12H"), to_dur("PT12H"))
  expect_pkg_error_classes(
    stabilize_short("P2D"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_dur_scalar() creates a working scalar stabilizer (#295)", {
  stabilize_short <- specify_dur_scalar(max_value = "P1D")
  expect_identical(stabilize_short("PT12H"), to_dur("PT12H"))
  expect_pkg_error_classes(
    stabilize_short(c("P1D", "P2D")),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_time can build a value checker (#294)", {
  checker <- specify_time(min_value = "12:00:00Z")
  expect_identical(checker("13:00:00Z"), to_time("13:00:00Z"))
  expect_pkg_error_classes(
    checker("06:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_time can enforce unique elements (#294)", {
  checker <- specify_time(unique = TRUE)
  given <- to_time(c("06:00:00Z", "14:00:00Z"))
  expect_identical(checker(given), given)
  expect_pkg_error_classes(
    checker(to_time(c("06:00:00Z", "06:00:00Z"))),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_time_scalar can build a value checker (#294)", {
  checker <- specify_time_scalar(min_value = "12:00:00Z")
  expect_identical(checker("13:00:00Z"), to_time("13:00:00Z"))
  expect_pkg_error_classes(
    checker(to_time(c("13:00:00Z", "14:00:00Z"))),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_time_scalar defaults to allow_null = FALSE (#294)", {
  checker <- specify_time_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_time_scalar defaults to allow_zero_length = FALSE (#294)", {
  checker <- specify_time_scalar()
  empty <- to_time(character())
  expect_pkg_error_classes(checker(empty), "stbl", "bad_empty")
  expect_identical(checker(empty, allow_zero_length = TRUE), empty)
})

test_that("specify_time can enforce allowed_values (#294)", {
  checker <- specify_time(
    allowed_values = c("06:00:00Z", "14:00:00Z")
  )
  expect_identical(checker("06:00:00Z"), to_time("06:00:00Z"))
  expect_pkg_error_classes(checker("09:00:00Z"), "stbl", "allowed_values")
})

test_that("specify_time() creates a working stabilizer (#294)", {
  stabilize_afternoon <- specify_time(min_value = "12:00:00Z")
  expect_identical(
    stabilize_afternoon("13:00:00Z"),
    to_time("13:00:00Z")
  )
  expect_pkg_error_classes(
    stabilize_afternoon("06:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_time_scalar() creates a working scalar stabilizer (#294)", {
  stabilize_afternoon <- specify_time_scalar(min_value = "12:00:00Z")
  expect_identical(
    stabilize_afternoon("13:00:00Z"),
    to_time("13:00:00Z")
  )
  expect_pkg_error_classes(
    stabilize_afternoon(c("13:00:00Z", "14:00:00Z")),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_fct can build a level checker (#150)", {
  checker <- specify_fct(levels = c("a", "c"), to_na = "b")
  expect_identical(
    checker(c("a", "b", "c")),
    factor(c("a", NA, "c"), levels = c("a", "c"))
  )
  expect_pkg_error_classes(
    checker("invalid"),
    "stbl",
    "fct_levels"
  )
})

test_that("specify_fct_scalar can build a level checker (#150)", {
  checker <- specify_fct_scalar(levels = c("a", "c"), to_na = "b")
  expect_identical(
    checker("a"),
    factor("a", levels = c("a", "c"))
  )
  expect_pkg_error_classes(
    checker(c("a", "c")),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_fct_scalar defaults to allow_null = FALSE (#197)", {
  checker <- specify_fct_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_fct_scalar defaults to allow_zero_length = FALSE (#197)", {
  checker <- specify_fct_scalar()
  expect_pkg_error_classes(checker(character(0)), "stbl", "bad_empty")
  expect_identical(
    checker(character(0), allow_zero_length = TRUE),
    factor(character(0))
  )
})

test_that("specify_int can build a value checker (#149)", {
  checker <- specify_int(min_value = 2)
  expect_identical(
    checker(2:10),
    2:10
  )
  expect_pkg_error_classes(
    checker(1),
    "stbl",
    "outside_range"
  )
})

test_that("specify_int can enforce unique elements (#280)", {
  checker <- specify_int(unique = TRUE)
  expect_identical(checker(c(1L, 2L)), c(1L, 2L))
  expect_pkg_error_classes(checker(c(1L, 2L, 1L)), "stbl", "duplicate_elements")
})

test_that("specify_int_scalar can build a value checker (#149)", {
  checker <- specify_int_scalar(min_value = 2)
  expect_identical(
    checker(2),
    2L
  )
  expect_pkg_error_classes(
    checker(2:10),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_int_scalar defaults to allow_null = FALSE (#197)", {
  checker <- specify_int_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_int_scalar defaults to allow_zero_length = FALSE (#197)", {
  checker <- specify_int_scalar()
  expect_pkg_error_classes(checker(integer(0)), "stbl", "bad_empty")
  expect_identical(checker(integer(0), allow_zero_length = TRUE), integer(0))
})

test_that("specify_lgl can build a checker (#151)", {
  checker <- specify_lgl(allow_na = FALSE)
  expect_identical(
    checker(c(TRUE, "False")),
    c(TRUE, FALSE)
  )
  expect_pkg_error_classes(
    checker(NA),
    "stbl",
    "bad_na"
  )
})

test_that("specify_lgl_scalar can build a value checker (#151)", {
  checker <- specify_lgl_scalar(allow_na = FALSE)
  expect_identical(
    checker("True"),
    TRUE
  )
  expect_pkg_error_classes(
    checker(c(TRUE, FALSE)),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_lgl_scalar defaults to allow_null = FALSE (#197)", {
  checker <- specify_lgl_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_lgl_scalar defaults to allow_zero_length = FALSE (#197)", {
  checker <- specify_lgl_scalar()
  expect_pkg_error_classes(checker(logical(0)), "stbl", "bad_empty")
  expect_identical(checker(logical(0), allow_zero_length = TRUE), logical(0))
})

test_that("specify_character() exists (#164)", {
  expect_no_error(specify_character())
})

test_that("stabilize_character_scalar() exists (#164)", {
  expect_no_error(specify_character_scalar())
})

test_that("specify_double() exists (#164)", {
  expect_no_error(specify_double())
})

test_that("stabilize_double_scalar() exists (#164)", {
  expect_no_error(specify_double_scalar())
})

test_that("specify_factor() exists (#164)", {
  expect_no_error(specify_factor())
})

test_that("stabilize_factor_scalar() exists (#164)", {
  expect_no_error(specify_factor_scalar())
})

test_that("specify_integer() exists (#164)", {
  expect_no_error(specify_integer())
})

test_that("stabilize_integer_scalar() exists (#164)", {
  expect_no_error(specify_integer_scalar())
})

test_that("specify_logical() exists (#164)", {
  expect_no_error(specify_logical())
})

test_that("stabilize_logical_scalar() exists (#164)", {
  expect_no_error(specify_logical_scalar())
})

test_that("specify_chr can enforce allowed_values (#282)", {
  checker <- specify_chr(allowed_values = c("a", "b"))
  expect_identical(checker("a"), "a")
  expect_pkg_error_classes(checker("z"), "stbl", "allowed_values")
})

test_that("specify_int can enforce allowed_values (#282)", {
  checker <- specify_int(allowed_values = c(1L, 2L))
  expect_identical(checker(1L), 1L)
  expect_pkg_error_classes(checker(5L), "stbl", "allowed_values")
})

test_that("specify_dbl can enforce allowed_values (#282)", {
  checker <- specify_dbl(allowed_values = c(1.1, 2.2))
  expect_identical(checker(1.1), 1.1)
  expect_pkg_error_classes(checker(3.3), "stbl", "allowed_values")
})

test_that("specify_lgl can enforce allowed_values (#282)", {
  checker <- specify_lgl(allowed_values = TRUE)
  expect_identical(checker(TRUE), TRUE)
  expect_pkg_error_classes(checker(FALSE), "stbl", "allowed_values")
})
