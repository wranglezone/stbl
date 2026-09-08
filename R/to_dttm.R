#' Coerce to date-time
#'
#' Checks whether a vector can be coerced to a [base::POSIXct] without losing
#' information, returning it silently if so. Otherwise an informative error
#' message is signaled. `to_datetime()` is a synonym of `to_dttm()`.
#'
#' Character vectors must use the [RFC
#' 3339](https://datatracker.ietf.org/doc/html/rfc3339) `date-time` format
#' (`"YYYY-MM-DDTHH:MM:SS"`, optionally followed by fractional seconds and
#' either `"Z"` or a numeric offset such as `"+05:00"`); any other shape is
#' rejected (but see [stabilize_dttm()]). A space may be used instead of `"T"`
#' to separate the date and time. All values are normalized to the time zone
#' named by `tz` (`"UTC"` by default); the underlying instant in time is
#' preserved, only its display time zone changes. Numeric and integer values are
#' treated as the number of seconds since the Unix epoch (`"1970-01-01 00:00:00
#' UTC"`). [base::Date] values are treated as midnight UTC on that date.
#'
#' @inheritParams .shared-params
#' @param tz (`character(1)`) The time zone to normalize `x` to. Must be `""` or
#'   a value from [OlsonNames()]. Defaults to `"UTC"`.
#'
#' @returns The input as a [base::POSIXct] vector, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-incompatible_values-datetime>` when some values cannot be
#'   safely converted to datetime.
#'   - `<stbl-error-bad_tz>` when `tz` is not `""` or a value from
#'   [OlsonNames()].
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#' @family datetime functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_dttm(as.POSIXct("2024-01-01 12:00:00", tz = "UTC"))
#' to_dttm("2024-01-01T12:00:00Z")
#' to_dttm("2024-01-01T12:00:00-05:00")
#' to_dttm(c("2024-01-01T12:00:00Z", NA))
#' to_dttm(0L)
#' to_dttm(as.Date("2024-01-01"))
#' to_dttm(NULL)
#' try(to_dttm("2024-01-01 12:00:00"))
#' try(to_dttm(c("2024-01-01T12:00:00Z", "not-a-datetime")))
to_dttm <- function(
  x,
  ...,
  tz = "UTC",
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to_dttm")
}

#' @export
#' @rdname to_dttm
to_datetime <- to_dttm

#' @export
#' @rdname to_dttm
to_dttm.POSIXct <- function(x, ..., tz = "UTC", call = caller_env()) {
  tz <- .check_tz(tz, call = call)
  attr(x, "tzone") <- tz
  return(x)
}

#' @export
#' @rdname to_dttm
to_dttm.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
#' @rdname to_dttm
to_dttm.character <- function(
  x,
  ...,
  tz = "UTC",
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  tz <- .check_tz(tz, call = call)
  not_na <- !is.na(x)
  # RFC 3339 date-time, with an optional space instead of "T" and optional
  # fractional seconds.
  pattern <- paste0(
    "^(\\d{4})-(\\d{2})-(\\d{2})[Tt ](\\d{2}):(\\d{2}):(\\d{2})",
    "(\\.\\d+)?(Z|z|[+-]\\d{2}:\\d{2})$"
  )
  matches <- regmatches(x, regexec(pattern, x))
  well_shaped <- lengths(matches) > 0L
  parsed <- as.POSIXct(rep(NA_character_, length(x)), tz = tz)
  to_parse <- not_na & well_shaped
  if (any(to_parse)) {
    parsed[to_parse] <- .parse_dttm_parts(matches[to_parse])
  }
  failures <- not_na & (!well_shaped | is.na(parsed))
  .check_cast_failures(
    x,
    failures,
    x_class,
    .datetime_type_obj(),
    "invalid or ambiguous date-time format",
    x_arg,
    call
  )
  attr(parsed, "tzone") <- tz
  return(parsed)
}

#' Parse the regex captures from `to_dttm.character()` into instants
#'
#' @param matches `(list)` A list of character vectors, each the result of
#'   [regmatches()] on a single well-shaped RFC 3339 date-time string: the full
#'   match followed by year, month, day, hour, minute, second, optional
#'   fractional seconds, and the time zone offset.
#' @returns A [base::POSIXct] vector (in UTC) the same length as `matches`, with
#'   `NA` at any position that describes an impossible date-time (such as
#'   `"2024-02-30"`).
#' @keywords internal
.parse_dttm_parts <- function(matches) {
  parts <- do.call(rbind, matches)
  frac_chr <- parts[, 8]
  frac_seconds <- ifelse(frac_chr == "", 0, as.numeric(paste0("0", frac_chr)))
  # ISOdatetime() (unlike as.POSIXct(format = ...)) returns NA for
  # out-of-range components instead of rolling over, so it doubles as the
  # calendar validity check.
  naive_utc <- ISOdatetime(
    year = as.integer(parts[, 2]),
    month = as.integer(parts[, 3]),
    day = as.integer(parts[, 4]),
    hour = as.integer(parts[, 5]),
    min = as.integer(parts[, 6]),
    sec = as.integer(parts[, 7]),
    tz = "UTC"
  )
  offset_seconds <- .parse_dttm_offset(parts[, 9])
  return(naive_utc - offset_seconds + frac_seconds)
}

#' Convert an RFC 3339 time-offset to a number of seconds
#'
#' @param x `(character)` Time-offset strings, each either `"Z"`/`"z"` or a
#'   numeric offset such as `"+05:00"` or `"-05:30"`.
#' @returns A numeric vector of offsets from UTC, in seconds. Local time minus
#'   the offset gives the UTC instant.
#' @keywords internal
.parse_dttm_offset <- function(x) {
  is_zulu <- x %in% c("Z", "z")
  sign <- ifelse(startsWith(x, "-"), -1, 1)
  hours <- as.integer(substr(x, 2, 3))
  minutes <- as.integer(substr(x, 5, 6))
  offset_seconds <- sign * (hours * 3600 + minutes * 60)
  offset_seconds[is_zulu] <- 0
  return(offset_seconds)
}

#' @export
#' @rdname to_dttm
to_dttm.factor <- function(
  x,
  ...,
  tz = "UTC",
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_dttm(
    as.character(x),
    ...,
    tz = tz,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to_dttm
to_dttm.POSIXlt <- function(x, ..., tz = "UTC", call = caller_env()) {
  tz <- .check_tz(tz, call = call)
  return(as.POSIXct(x, tz = tz))
}

#' @export
#' @rdname to_dttm
to_dttm.Date <- function(x, ..., tz = "UTC", call = caller_env()) {
  tz <- .check_tz(tz, call = call)
  # A Date has no time-of-day; treat it as midnight UTC on that date, then
  # display in the requested time zone (matching as.POSIXct.Date()).
  return(as.POSIXct(x, tz = tz))
}

#' @export
#' @rdname to_dttm
to_dttm.numeric <- function(x, ..., tz = "UTC", call = caller_env()) {
  tz <- .check_tz(tz, call = call)
  # Numeric values are seconds since the Unix epoch.
  return(as.POSIXct(x, origin = "1970-01-01", tz = tz))
}

#' @export
#' @rdname to_dttm
to_dttm.integer <- function(x, ..., tz = "UTC", call = caller_env()) {
  to_dttm.numeric(x, tz = tz, call = call)
}

#' @export
to_dttm.default <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  vctrs::vec_cast(x, .datetime_type_obj(), x_arg = x_arg, call = call)
}

#' Coerce to length-1 date-time
#'
#' Checks whether a vector can be coerced to a length-1 [base::POSIXct] vector.
#' `to_datetime_scalar()` is a synonym of `to_dttm_scalar()`.
#'
#' @inheritParams .shared-params
#' @inheritParams to_dttm
#'
#' @returns The input as a length-1 [base::POSIXct] vector, or an error
#'   condition with classes `<stbl-error>`, `<stbl-condition>`,
#'   `<rlang_error>`, `<error>`, `<condition>`, and a specific class by
#'   failure mode:
#'   - `<stbl-error-incompatible_values-datetime>` when some values cannot be
#'   safely converted to datetime.
#'   - `<stbl-error-bad_tz>` when `tz` is not `""` or a value from
#'   [OlsonNames()].
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#' @family datetime functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_dttm_scalar("2024-01-01T12:00:00Z")
#' try(to_dttm_scalar(c(
#'   "2024-01-01T12:00:00Z",
#'   "2024-01-02T12:00:00Z"
#' )))
to_dttm_scalar <- function(
  x,
  ...,
  tz = "UTC",
  allow_null = FALSE,
  allow_zero_length = FALSE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_cls_scalar(
    x,
    is_rlang_cls_scalar = .is_scalar_dttm,
    to_cls_fn = to_dttm,
    to_cls_args = c(list(tz = tz), list(...)),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to_dttm_scalar
to_datetime_scalar <- to_dttm_scalar

#' Test for a length-1 date-time vector
#'
#' @inheritParams .shared-params-check
#' @returns `TRUE` if `x` is a length-1 [base::POSIXct] vector, else `FALSE`.
#' @keywords internal
.is_scalar_dttm <- function(x) {
  inherits(x, "POSIXct") && length(x) == 1L
}

#' Check that a time zone is valid
#'
#' @param tz (`character(1)`) The time zone to validate.
#' @inheritParams .shared-params
#' @returns `tz`, coerced to a scalar character, if it is valid.
#' @keywords internal
.check_tz <- function(tz, x_arg = "tz", call = caller_env()) {
  tz <- to_chr_scalar(tz, x_arg = x_arg, call = call)
  if (identical(tz, "") || tz %in% OlsonNames()) {
    return(tz)
  }
  .stop_must(
    "must be \"\" or a value from {.fun OlsonNames}.",
    x_arg = x_arg,
    additional_msg = c(x = "{.val {tz}} is not a recognized time zone."),
    call = call,
    subclass = "bad_tz",
    message_env = rlang::current_env()
  )
}

#' An empty date-time object for error messages
#'
#' [object_type()] renders a [base::POSIXct] as `"POSIXct"`, but the datetime
#' family uses `"datetime"` in its coercion classes and messages, to match the
#' `to_dttm()`/`stabilize_dttm()` function names. This returns an empty
#' object that renders as `"datetime"` so error subclasses read
#' `<stbl-error-incompatible_values-datetime>`.
#'
#' @returns A zero-length object whose [object_type()] is `"datetime"`.
#' @keywords internal
.datetime_type_obj <- function() {
  structure(double(), class = "datetime")
}
