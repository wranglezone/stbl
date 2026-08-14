#' Coerce to time-of-day
#'
#' Checks whether a vector can be coerced to an [hms::hms()] time-of-day vector
#' without losing information, returning it silently if so. Otherwise an
#' informative error message is signaled.
#'
#' Character vectors must use the [RFC
#' 3339](https://datatracker.ietf.org/doc/html/rfc3339) `full-time` format
#' (`"HH:MM:SS"`, optionally followed by fractional seconds and a mandatory
#' offset of either `"Z"` or a numeric offset such as `"+05:00"`); any other
#' shape is rejected. The offset is used only to normalize the value to UTC and
#' is not retained: `to_time()` always returns the time-of-day expressed in UTC.
#' [base::POSIXct] and [base::POSIXlt] values are likewise converted to UTC
#' before their time-of-day component is extracted. Numeric and [base::difftime]
#' values are treated as (fractional) seconds since midnight and must resolve to
#' a value in `[0, 86400)`.
#'
#' `to_time()` requires the \pkg{hms} package.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as an [hms::hms()] vector, always expressed in UTC.
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
#' to_time(as.POSIXct("2024-01-01 13:20:00", tz = "UTC"))
#' to_time(NULL)
#' try(to_time("13:20:00"))
#' try(to_time(c("13:20:00Z", "not-a-time")))
to_time <- function(
  x,
  ...,
  x_arg = caller_arg(x),
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
  .check_cast_failures(
    failures,
    x_class,
    .time_type_obj(),
    "invalid or ambiguous time format",
    x_arg,
    call
  )
  return(hms::as_hms(utc_seconds))
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
  call = caller_env(),
  x_class = object_type(x)
) {
  to_time(as.character(x), ..., x_arg = x_arg, call = call, x_class = x_class)
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
  return(hms::as_hms(x))
}

#' @export
#' @rdname to_time
to_time.POSIXlt <- function(x, ..., call = caller_env()) {
  to_time.POSIXct(as.POSIXct(x), call = call)
}

#' @export
#' @rdname to_time
to_time.numeric <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  rlang::check_installed(
    "hms",
    reason = "to convert numeric seconds to a time of day"
  )
  # Numeric values are seconds since midnight; anything outside a single day
  # doesn't unambiguously resolve to a time of day.
  failures <- !is.na(x) & (x < 0 | x >= 86400)
  .check_cast_failures(
    failures,
    x_class,
    .time_type_obj(),
    "not a valid number of seconds since midnight (must be at least 0 and less than 86400)",
    x_arg,
    call
  )
  return(hms::as_hms(as.numeric(x)))
}

#' @export
#' @rdname to_time
to_time.integer <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_time.numeric(x, x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to_time
to_time.difftime <- function(
  x,
  ...,
  x_arg = caller_arg(x),
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
  to_time.numeric(seconds, x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
to_time.default <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  vctrs::vec_cast(x, .time_type_obj(), x_arg = x_arg, call = call)
}

#' Coerce to length-1 time-of-day
#'
#' Checks whether a vector can be coerced to a length-1 [hms::hms()] vector.
#'
#' @inheritParams .shared-params
#' @inheritParams to_time
#'
#' @returns The input as a length-1 [hms::hms()] vector.
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
  allow_null = FALSE,
  allow_zero_length = FALSE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_cls_scalar(
    x,
    is_rlang_cls_scalar = .is_scalar_time,
    to_cls_fn = to_time,
    to_cls_args = list(...),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
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
#' `"time"` in its coercion classes and messages, to match the
#' `to_time()`/`stabilize_time()` function names. This returns an empty object
#' that renders as `"time"` so error subclasses read
#' `<stbl-error-incompatible_values-time>`.
#'
#' @returns A zero-length object whose [object_type()] is `"time"`.
#' @keywords internal
.time_type_obj <- function() {
  structure(double(), class = "time")
}
