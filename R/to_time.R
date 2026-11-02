# target class: hms

#' Convert to time-of-day
#'
#' Checks whether a vector can be converted to an [hms::hms()] time-of-day
#' vector without losing information, returning it silently if so. Otherwise an
#' informative error message is signaled.
#'
#' Character vectors must use the [RFC
#' 3339](https://datatracker.ietf.org/doc/html/rfc3339) `full-time` format
#' (`"HH:MM:SS"`, optionally followed by fractional seconds and a mandatory
#' offset of either `"Z"` or a numeric offset such as `"+05:00"`); any other
#' shape is rejected. The offset is used only to normalize the value to UTC and
#' is not retained: `to_time()` always returns the time-of-day expressed in UTC.
#' [base::POSIXct] and [base::POSIXlt] values are likewise converted to UTC
#' before their time-of-day component is extracted. Numeric values are
#' interpreted according to `treat_number_as`, by default as (fractional)
#' seconds since midnight, and must resolve to a time within a single day (for
#' example, `0.5` is 12:00:00 with `treat_number_as = "days"`). [base::difftime]
#' values carry their own unit and must resolve to a value in `[0, 86400)`
#' seconds since midnight. `treat_number_as` is ignored for non-numeric input.
#'
#' `to_time()` requires the \pkg{hms} package.
#'
#' @param treat_number_as (`character(1)`) How to interpret numeric input:
#'   `"seconds"` or `"milliseconds"` since midnight, `"days"` as a fraction of a
#'   day (so `0.5` is 12:00:00), or `"error"` to reject numbers. Ignored for
#'   non-numeric input.
#' @inheritParams .shared-params
#'
#' @returns The input as an [hms::hms()] vector, always expressed in UTC, or an
#'   error condition with classes `<stbl-error>`, `<stbl-condition>`,
#'   `<rlang_error>`, `<error>`, `<condition>`, and a specific class by failure
#'   mode:
#'   - `<stbl-error-coerce-time>` when numbers are rejected by
#'   `treat_number_as = "error"`.
#'   - `<stbl-error-incompatible_values-time>` when some values cannot be
#'   safely converted to a time of day.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#' @family time functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_time(hms::hms(0, 20, 13))
#' to_time("13:20:00Z")
#' to_time("13:20:00-05:00")
#' to_time(c("13:20:00Z", NA))
#' to_time(3600)
#' to_time(3600000, treat_number_as = "milliseconds")
#' to_time(0.5, treat_number_as = "days")
#' try(to_time(3600, treat_number_as = "error"))
#' to_time(as.POSIXct("2024-01-01 13:20:00", tz = "UTC"))
#' to_time(NULL)
#' try(to_time("13:20:00"))
#' try(to_time(c("13:20:00Z", "not-a-time")))
to_time <- function(
  x,
  ...,
  treat_number_as = c("seconds", "milliseconds", "days", "error"),
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to_time")
}

#' @export
#' @rdname to_time
to_time.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
#' @rdname to_time
to_time.character <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
) {
  rlang::check_installed(
    "hms",
    reason = "to parse character time-of-day values"
  )
  not_na <- !is.na(x)
  # RFC 3339 full-time: partial-time (with optional fractional seconds)
  # followed by a mandatory time-offset.
  pattern <- "^(\\d{2}):(\\d{2}):(\\d{2})(\\.\\d+)?(Z|z|[+-]\\d{2}:\\d{2})$"
  matches <- regmatches(x, regexec(pattern, x))
  well_shaped <- lengths(matches) > 0L
  utc_seconds <- rep(NA_real_, length(x))
  to_parse <- not_na & well_shaped
  if (any(to_parse)) {
    utc_seconds[to_parse] <- .parse_time_parts(matches[to_parse])
  }
  failures <- not_na & (!well_shaped | is.na(utc_seconds))
  .check_conversion_failures(
    x,
    failures,
    x_class,
    .time_type_obj(),
    "invalid or ambiguous time format",
    x_arg,
    call,
    to_arg
  )
  return(.copy_names(hms::as_hms(utc_seconds), x))
}

#' Parse the regex captures from `to_time.character()` into seconds
#'
#' @param matches `(list)` A list of character vectors, each the result of
#'   [regmatches()] on a single well-shaped RFC 3339 `full-time` string: the
#'   full match followed by hour, minute, second, optional fractional seconds,
#'   and the time-offset.
#' @returns A numeric vector the same length as `matches`, giving the UTC
#'   time-of-day in seconds since midnight (always in `[0, 86400)`), or `NA` at
#'   any position that describes an impossible time (such as `"25:00:00Z"`).
#' @keywords internal
.parse_time_parts <- function(matches) {
  parts <- do.call(rbind, matches)
  hour <- as.integer(parts[, 2])
  minute <- as.integer(parts[, 3])
  # RFC 3339 permits a value of 60 in the seconds place to represent a leap
  # second; that case is handled naturally by the modulo wraparound below.
  second <- as.integer(parts[, 4])
  frac_chr <- parts[, 5]
  frac_seconds <- ifelse(frac_chr == "", 0, as.numeric(paste0("0", frac_chr)))
  valid <- hour <= 23L & minute <= 59L & second <= 60L
  offset_seconds <- .parse_dttm_offset(parts[, 6])
  local_seconds <- hour * 3600 + minute * 60 + second + frac_seconds
  utc_seconds <- (local_seconds - offset_seconds) %% 86400
  utc_seconds[!valid] <- NA_real_
  return(utc_seconds)
}

#' @export
#' @rdname to_time
to_time.factor <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
) {
  to_time(
    .as_chr_named(x),
    ...,
    x_arg = x_arg,
    to_arg = to_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to_time
to_time.POSIXct <- function(x, ..., call = caller_env()) {
  rlang::check_installed(
    "hms",
    reason = "to extract time-of-day from POSIXct values"
  )
  # Normalize to UTC before extracting the time-of-day so the result does not
  # depend on the instant's display time zone.
  attr(x, "tzone") <- "UTC"
  return(.copy_names(hms::as_hms(x), x))
}

#' @export
#' @rdname to_time
to_time.POSIXlt <- function(x, ..., call = caller_env()) {
  .copy_names(to_time.POSIXct(as.POSIXct(x), call = call), x)
}

#' @export
#' @rdname to_time
to_time.numeric <- function(
  x,
  ...,
  treat_number_as = c("seconds", "milliseconds", "days", "error"),
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
) {
  treat_number_as <- rlang::arg_match(treat_number_as, error_call = call)
  if (treat_number_as == "error") {
    .stop_cant_convert(
      from_class = x_class,
      to_class = "time",
      x_arg = x_arg,
      to_arg = to_arg,
      call = call
    )
  }
  rlang::check_installed(
    "hms",
    reason = "to convert numeric values to a time of day"
  )
  # Convert to seconds since midnight. Anything outside a single day doesn't
  # unambiguously resolve to a time of day.
  seconds <- switch(
    treat_number_as,
    seconds = as.numeric(x),
    milliseconds = as.numeric(x) / 1000,
    days = as.numeric(x) * 86400
  )
  failures <- !is.na(seconds) & (seconds < 0 | seconds >= 86400)
  problem <- switch(
    treat_number_as,
    seconds = "not a valid number of seconds since midnight (must be at least 0 and less than 86400)",
    milliseconds = "not a valid number of milliseconds since midnight (must be at least 0 and less than 86400000)",
    days = "not a valid fraction of a day (must be at least 0 and less than 1)"
  )
  .check_conversion_failures(
    x,
    failures,
    x_class,
    .time_type_obj(),
    problem,
    x_arg,
    call,
    to_arg
  )
  return(.copy_names(hms::as_hms(seconds), x))
}

#' @export
#' @rdname to_time
to_time.difftime <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
) {
  rlang::check_installed(
    "hms",
    reason = "to convert difftime values to a time of day"
  )
  # This also handles hms::hms() input (class c("hms", "difftime")), since
  # there is no to_time.hms() method; hms values that are already valid times
  # of day round-trip through this path unchanged.
  seconds <- as.numeric(x, units = "secs")
  # difftime carries its own unit, so treat_number_as doesn't apply.
  .copy_names(
    to_time.numeric(
      seconds,
      treat_number_as = "seconds",
      x_arg = x_arg,
      to_arg = to_arg,
      call = call,
      x_class = x_class
    ),
    x
  )
}

#' @export
to_time.default <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
) {
  try_fetch(
    vctrs::vec_cast(x, .time_type_obj(), x_arg = x_arg, call = call),
    error = function(cnd) {
      .stop_cant_convert(
        from_class = x_class,
        to_class = "time",
        x_arg = x_arg,
        to_arg = to_arg,
        call = call
      )
    }
  )
}

#' Convert to length-1 time-of-day
#'
#' Checks whether a vector can be converted to a length-1 [hms::hms()] vector.
#'
#' @inheritParams to_time
#' @inheritParams .shared-params
#'
#' @returns The input as a length-1 [hms::hms()] vector, or an error
#'   condition with classes `<stbl-error>`, `<stbl-condition>`,
#'   `<rlang_error>`, `<error>`, `<condition>`, and a specific class by
#'   failure mode:
#'   - `<stbl-error-incompatible_values-time>` when some values cannot be
#'   safely converted to a time of day.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#' @family time functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_time_scalar("13:20:00Z")
#' try(to_time_scalar(c("13:20:00Z", "14:20:00Z")))
to_time_scalar <- function(
  x,
  ...,
  treat_number_as = c("seconds", "milliseconds", "days", "error"),
  allow_null = FALSE,
  allow_zero_length = FALSE,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_cls_scalar(
    x,
    is_rlang_cls_scalar = .is_scalar_time,
    to_cls_fn = to_time,
    to_cls_args = c(list(treat_number_as = treat_number_as), list(...)),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    to_arg = to_arg,
    call = call,
    x_class = x_class
  )
}

#' Test for a length-1 time-of-day vector
#'
#' @inheritParams .shared-params-check
#' @returns `TRUE` if `x` is a length-1 [hms::hms()] vector, else `FALSE`.
#' @keywords internal
.is_scalar_time <- function(x) {
  inherits(x, "hms") && length(x) == 1L
}

#' An empty time object for error messages
#'
#' [object_type()] renders an [hms::hms()] as `"hms"`, but the time family uses
#' `"time"` in its conversion classes and messages, to match the
#' `to_time()`/`stabilize_time()` function names. This returns an empty object
#' that renders as `"time"` so error subclasses read
#' `<stbl-error-incompatible_values-time>`.
#'
#' @returns A zero-length object whose [object_type()] is `"time"`.
#' @keywords internal
.time_type_obj <- function() {
  structure(double(), class = "time")
}
