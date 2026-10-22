#' Coerce to date-time with additional checks
#'
#' Compared to [to_dttm()], `stabilize_dttm()` checks more details, but is
#' slower. `stabilise_dttm()`, `stabilize_datetime()`, `stabilise_dttm()`,
#' `stabilize_datetime()`, and `stabilise_datetime()` are synonyms of
#' `stabilize_dttm()`.
#'
#' @inheritParams .shared-params
#' @inheritParams to_dttm
#'
#' @returns The input as a [base::POSIXct] vector, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-datetime>` when `x` cannot be coerced to datetime.
#'   - `<stbl-error-incompatible_values-datetime>` when some values cannot be
#'   safely converted to datetime.
#'   - `<stbl-error-bad_tz>` when `tz` is not `""` or a value from
#'   [OlsonNames()], or is `""` and your local time zone can't be determined.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-size_too_small>` when the vector is shorter than
#'   `min_size`.
#'   - `<stbl-error-size_too_large>` when the vector is longer than
#'   `max_size`.
#'   - `<stbl-error-duplicate_elements>` when `unique = TRUE` and duplicates
#'   are present.
#'   - `<stbl-error-outside_range>` when values fall outside `min_value` or
#'   `max_value`.
#'   - `<stbl-error-allowed_values>` when values are not in `allowed_values`.
#' @family datetime functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_dttm(as.POSIXct("2024-01-01 12:00:00", tz = "UTC"))
#' stabilize_dttm("2024-01-01T12:00:00Z")
#' stabilize_dttm(NULL)
#' try(stabilize_dttm(NULL, allow_null = FALSE))
#' try(stabilize_dttm(
#'   c("2024-01-01T12:00:00Z", NA),
#'   allow_na = FALSE
#' ))
#' stabilize_dttm("2024-01-01 12:00:00")
#' try(stabilize_dttm(
#'   "2024-01-01T12:00:00Z",
#'   min_value = "2024-06-01T00:00:00Z"
#' ))
#' try(stabilize_dttm(
#'   "2024-12-01T00:00:00Z",
#'   max_value = "2024-06-01T00:00:00Z"
#' ))
stabilize_dttm <- function(
  x,
  ...,
  tz = "UTC",
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL,
  accepted_datetime_formats = locale_datetime_formats(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls(
    x,
    to_cls_fn = .to_dttm_locale,
    to_cls_args = list(
      tz = tz,
      accepted_datetime_formats = accepted_datetime_formats
    ),
    check_cls_value_fn = .check_value_dttm,
    check_cls_value_fn_args = list(
      min_value = min_value,
      max_value = max_value,
      allowed_values = allowed_values
    ),
    allow_null = allow_null,
    allow_na = allow_na,
    min_size = min_size,
    max_size = max_size,
    unique = unique,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
#' @rdname stabilize_dttm
stabilise_dttm <- stabilize_dttm

#' @export
#' @rdname stabilize_dttm
stabilize_datetime <- stabilize_dttm

#' @export
#' @rdname stabilize_dttm
stabilise_datetime <- stabilize_dttm

#' Coerce to length-1 date-time with additional checks
#'
#' Checks whether a vector can be coerced to a length-1 [base::POSIXct] vector.
#' `stabilize_dttm_scalar()` is optimized to check for length-1 date-time
#' vectors (compared to [stabilize_dttm()] with `max_size = 1`).
#' `stabilise_dttm_scalar` are synonyms of `stabilize_dttm_scalar()`.
#'
#' @inheritParams .shared-params
#' @inheritParams to_dttm
#'
#' @returns The input as a length-1 [base::POSIXct] vector, or an error
#'   condition with classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`,
#'   `<error>`, `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-datetime>` when `x` cannot be coerced to datetime.
#'   - `<stbl-error-incompatible_values-datetime>` when some values cannot be
#'   safely converted to datetime.
#'   - `<stbl-error-bad_tz>` when `tz` is not `""` or a value from
#'   [OlsonNames()], or is `""` and your local time zone can't be determined.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-outside_range>` when values fall outside `min_value` or
#'   `max_value`.
#'   - `<stbl-error-allowed_values>` when the value is not in
#'   `allowed_values`.
#' @family datetime functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_dttm_scalar(as.POSIXct("2024-01-01 12:00:00", tz = "UTC"))
#' stabilize_dttm_scalar("2024-01-01T12:00:00Z")
#' try(stabilize_dttm_scalar(c(
#'   "2024-01-01T12:00:00Z",
#'   "2024-01-02T12:00:00Z"
#' )))
#' try(stabilize_dttm_scalar(NULL))
#' stabilize_dttm_scalar(NULL, allow_null = TRUE)
stabilize_dttm_scalar <- function(
  x,
  ...,
  tz = "UTC",
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL,
  accepted_datetime_formats = locale_datetime_formats(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls_scalar(
    x,
    to_cls_scalar_fn = .to_dttm_locale_scalar,
    to_cls_scalar_args = list(
      tz = tz,
      accepted_datetime_formats = accepted_datetime_formats
    ),
    check_cls_value_fn = .check_value_dttm,
    check_cls_value_fn_args = list(
      min_value = min_value,
      max_value = max_value,
      allowed_values = allowed_values
    ),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    allow_na = allow_na,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
#' @rdname stabilize_dttm_scalar
stabilise_dttm_scalar <- stabilize_dttm_scalar

#' @export
#' @rdname stabilize_dttm_scalar
stabilize_datetime_scalar <- stabilize_dttm_scalar

#' @export
#' @rdname stabilize_dttm_scalar
stabilise_datetime_scalar <- stabilize_dttm_scalar

#' Coerce to date-time, trying `accepted_datetime_formats` for character input
#'
#' Used by [stabilize_dttm()] in place of [to_dttm()], so that character input
#' can be tried against a list of `accepted_datetime_formats` (with an
#' optional UTC offset) rather than only the strict RFC 3339 shape that
#' [to_dttm()] enforces. Non-character input (and factors, once converted to
#' character) is delegated to [to_dttm()] unchanged.
#'
#' @inheritParams .shared-params
#' @inheritParams to_dttm
#' @returns The input as a [base::POSIXct] vector.
#' @keywords internal
.to_dttm_locale <- function(
  x,
  ...,
  tz,
  accepted_datetime_formats,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  tz <- .check_tz(tz, call = call)
  if (inherits(x, "factor")) {
    return(.to_dttm_locale(
      as.character(x),
      tz = tz,
      accepted_datetime_formats = accepted_datetime_formats,
      x_arg = x_arg,
      call = call,
      x_class = x_class
    ))
  }
  if (!is.character(x)) {
    return(to_dttm(
      x,
      ...,
      tz = tz,
      x_arg = x_arg,
      call = call,
      x_class = x_class
    ))
  }
  result <- .try_dttm_formats(x, accepted_datetime_formats, tz = tz)
  .check_cast_failures(
    x,
    result$failures,
    x_class,
    .datetime_type_obj(),
    "invalid or ambiguous date-time format",
    x_arg,
    call
  )
  attr(result$parsed, "tzone") <- tz
  return(result$parsed)
}

#' Coerce to length-1 date-time, trying `accepted_datetime_formats`
#'
#' The scalar counterpart of [.to_dttm_locale()], used by
#' [stabilize_dttm_scalar()] in place of [to_dttm_scalar()].
#'
#' @inheritParams .shared-params
#' @inheritParams to_dttm
#' @returns The input as a length-1 [base::POSIXct] vector.
#' @keywords internal
.to_dttm_locale_scalar <- function(
  x,
  ...,
  tz,
  accepted_datetime_formats,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_cls_scalar(
    x,
    is_rlang_cls_scalar = .is_scalar_dttm,
    to_cls_fn = .to_dttm_locale,
    to_cls_args = list(
      tz = tz,
      accepted_datetime_formats = accepted_datetime_formats
    ),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' Check date-time values against min, max, and allowed values
#'
#' Base R has no C-level range routines for [base::POSIXct] as it does for
#' double, so the comparisons are performed in plain R. `min_value`,
#' `max_value`, and `allowed_values` are coerced to [base::POSIXct] first so
#' that character or numeric bounds are accepted.
#'
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if `x` passes all checks.
#' @keywords internal
.check_value_dttm <- function(
  x,
  min_value,
  max_value,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  min_value <- to_dttm_scalar(min_value, allow_null = TRUE, call = call)
  max_value <- to_dttm_scalar(max_value, allow_null = TRUE, call = call)

  not_na <- !is.na(x)
  min_failures <- if (!is.null(min_value)) not_na & x < min_value
  max_failures <- if (!is.null(max_value)) not_na & x > max_value

  if (!any(min_failures) && !any(max_failures)) {
    allowed_values <- to_dttm(
      allowed_values,
      allow_null = TRUE,
      call = call
    )
    .check_allowed_values(
      x,
      allowed_values = allowed_values,
      x_arg = x_arg,
      call = call
    )
    return(invisible(NULL))
  }

  min_msg <- .describe_failure_dttm_value(
    x,
    failures = min_failures,
    direction = "low",
    target_value = min_value,
    x_arg = x_arg
  )
  max_msg <- .describe_failure_dttm_value(
    x,
    failures = max_failures,
    direction = "high",
    target_value = max_value,
    x_arg = x_arg
  )
  locations <- sort(unique(c(
    if (!is.null(min_failures)) which(min_failures),
    if (!is.null(max_failures)) which(max_failures)
  )))
  .stbl_abort(
    c(min_msg, max_msg),
    subclass = "outside_range",
    call = call,
    message_env = rlang::current_env(),
    locations = locations
  )
}

#' Describe a date-time value validation failure
#'
#' @param x `(POSIXct)` The vector being checked.
#' @param failures `(logical)` Which elements failed the check.
#' @param direction `(character)` One of `"low"` or `"high"`.
#' @param target_value `(POSIXct)` The value against which `x` is being
#'   compared.
#' @inheritParams .shared-params
#' @returns A named character vector for [.stbl_abort()], or `NULL`.
#' @keywords internal
.describe_failure_dttm_value <- function(
  x,
  failures,
  direction,
  target_value,
  x_arg
) {
  if (is.null(failures) || !any(failures)) {
    return(NULL)
  }
  direction_sign <- if (direction == "low") ">" else "<"
  msg_main <- format_inline(
    "{.arg {x_arg}} must be {direction_sign}= {format(target_value, usetz = TRUE)}."
  )
  failure_locations <- which(failures)
  # Format explicitly (with the time zone) so cli reports readable date-times
  # rather than their numeric (seconds-since-epoch) representation.
  failure_values <- format(x[failure_locations], usetz = TRUE)
  if (length(x) == 1) {
    return(c(
      msg_main,
      "x" = format_inline("{.val {failure_values}} is too {direction}.")
    ))
  }
  n_failures <- length(failure_locations)
  c(
    msg_main,
    "i" = glue("Some values are too {direction}."),
    "x" = format_inline("{qty(n_failures)}Location{?s}: {failure_locations}"),
    "x" = format_inline("{qty(n_failures)}Value{?s}: {failure_values}")
  )
}

#' Convert a strptime()-style format string to a field-capturing regex
#'
#' Unlike [.format_to_regex()], this keeps track of which calendar field each
#' capture group corresponds to, so the captured digits can be reassembled
#' regardless of the order in which the format places them (for example
#' `"%m/%d/%Y"` vs. `"%Y-%m-%d"`).
#'
#' @inheritParams .format_to_regex
#' @returns A list with:
#'   - `regex`: the unanchored regex body (not yet wrapped in `^`/`$`).
#'   - `fields`: a character vector naming the calendar field (one of `"Y"`,
#'   `"m"`, `"d"`, `"H"`, `"M"`, or `"S"`) captured by each group, in the
#'   order the groups appear in `regex`.
#' @keywords internal
.format_to_capture_regex <- function(fmt) {
  tokens <- regmatches(fmt, gregexpr("%[YmdHMS]|[^%]+", fmt))[[1]]
  group_patterns <- c(
    Y = "(\\d{4})",
    m = "(\\d{2})",
    d = "(\\d{2})",
    H = "(\\d{2})",
    M = "(\\d{2})",
    S = "(\\d{2})"
  )
  is_specifier <- grepl("^%[YmdHMS]$", tokens)
  fields <- substr(tokens[is_specifier], 2, 2)
  regex_parts <- tokens
  regex_parts[is_specifier] <- group_patterns[fields]
  list(regex = paste(regex_parts, collapse = ""), fields = fields)
}

#' Try candidate date-time formats against a character vector
#'
#' Like [.try_date_formats()], but for date-time strings, with an optional
#' trailing UTC offset (`"Z"` or a numeric offset such as `"+05:00"`).
#' Elements with an offset are converted using that offset; elements without
#' one are treated as wall-clock time in `tz`.
#'
#' @inheritParams .try_date_formats
#' @param tz `(character(1))` The time zone to assume for date-times with no
#'   explicit offset, and to attach to the result.
#' @returns A list with `parsed` (a [base::POSIXct] vector, in `tz`) and
#'   `failures` (a logical vector, the same length as `x`).
#' @keywords internal
.try_dttm_formats <- function(x, formats, tz) {
  not_na <- !is.na(x)
  offset_group <- "(Z|z|[+-]\\d{2}:\\d{2})?"
  first <- NULL
  for (fmt in formats) {
    parts <- .format_to_capture_regex(fmt)
    pattern <- paste0("^", parts$regex, offset_group, "$")
    matches <- regmatches(x, regexec(pattern, x))
    well_shaped <- lengths(matches) > 0L
    parsed <- as.POSIXct(rep(NA_character_, length(x)), tz = tz)
    to_parse <- not_na & well_shaped
    if (any(to_parse)) {
      parsed[to_parse] <- .parse_dttm_matches(
        matches[to_parse],
        parts$fields,
        tz
      )
    }
    failures <- not_na & (!well_shaped | is.na(parsed))
    result <- list(parsed = parsed, failures = failures)
    if (is.null(first)) {
      first <- result
    }
    if (!any(failures)) {
      return(result)
    }
  }
  first
}

#' Parse capture-group matches from `.try_dttm_formats()` into instants
#'
#' @param matches `(list)` Regex captures from [regmatches()]: the full
#'   match, one group per calendar field named in `fields`, and a trailing
#'   UTC-offset group (possibly `""` when absent).
#' @param fields `(character)` Which calendar field (`"Y"`, `"m"`, `"d"`,
#'   `"H"`, `"M"`, or `"S"`) each non-offset capture group corresponds to, in
#'   the order the groups appear.
#' @param tz `(character(1))` The time zone to assume for elements with no
#'   explicit offset.
#' @returns A [base::POSIXct] vector (in `tz`), the same length as `matches`,
#'   with `NA` at any position that describes an impossible date-time (such
#'   as `"2024-02-30"`).
#' @keywords internal
.parse_dttm_matches <- function(matches, fields, tz) {
  parts <- do.call(rbind, matches)
  n_fields <- length(fields)
  get_field <- function(letter, default) {
    idx <- which(fields == letter)
    if (length(idx) == 0L) {
      return(rep(default, nrow(parts)))
    }
    as.integer(parts[, idx + 1L])
  }
  # ISOdatetime() (unlike as.POSIXct(format = ...)) returns NA for
  # out-of-range components instead of rolling over, so it doubles as the
  # calendar validity check.
  naive <- ISOdatetime(
    year = get_field("Y", 1970L),
    month = get_field("m", 1L),
    day = get_field("d", 1L),
    hour = get_field("H", 0L),
    min = get_field("M", 0L),
    sec = get_field("S", 0L),
    tz = "UTC"
  )
  offset_chr <- parts[, n_fields + 2L]
  has_offset <- offset_chr != ""
  offset_seconds <- ifelse(has_offset, .parse_dttm_offset(offset_chr), 0)
  from_offset <- as.numeric(naive) - offset_seconds
  # Elements without an offset are wall-clock time in `tz`; reinterpret the
  # same digits (currently tagged UTC by ISOdatetime()) as local time in
  # `tz` instead.
  from_tz <- as.numeric(as.POSIXct(
    format(naive, "%Y-%m-%d %H:%M:%S", tz = "UTC"),
    tz = tz
  ))
  result_seconds <- ifelse(has_offset, from_offset, from_tz)
  as.POSIXct(result_seconds, origin = "1970-01-01", tz = tz)
}
