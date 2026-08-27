#' Coerce to a duration
#'
#' Checks whether a vector can be coerced to a [lubridate::Period-class] without
#' losing information, returning it silently if so. Otherwise an informative
#' error message is signaled.
#'
#' `Period` is chosen as the target class because it preserves the calendar
#' components (years, months, days, hours, minutes, seconds) of an [RFC
#' 3339](https://datatracker.ietf.org/doc/html/rfc3339) / [ISO
#' 8601](https://en.wikipedia.org/wiki/ISO_8601) duration string separately,
#' rather than collapsing them into a single number of seconds. That fidelity
#' comes at a cost: years and months have no fixed length, so comparisons
#' (`min_value`, `max_value`, `allowed_values` in [stabilize_dur()]) use
#' lubridate's approximate, nominal lengths (a 365.25-day year, a 30.4375-day
#' month) and may not reflect the actual elapsed time implied by a specific
#' calendar date.
#'
#' Character vectors must use the [RFC
#' 3339](https://datatracker.ietf.org/doc/html/rfc3339) `duration` format: `"P"`
#' followed by an optional number of years (`Y`), months (`M`), and days (`D`),
#' then an optional `"T"`-prefixed block of hours (`H`), minutes (`M`), and
#' seconds (`S`) (for example `"P3Y6M4DT12H30M5S"`, `"P23DT23H"`, or `"PT1M"`);
#' or a stand-alone week form (`"P4W"`). The date/time form and the week form
#' cannot be mixed, fractional components are not permitted, and `"P"` or `"PT"`
#' alone (with no components) are not valid durations. [base::difftime] values
#' (including [hms::hms()]) are converted directly, preserving their unit.
#' Numeric and integer values are treated as a (fractional) number of seconds
#' and broken into day/hour/minute/second components, with no year or month
#' component, since a number of seconds cannot unambiguously imply a calendar
#' length.
#'
#' `to_dur()` requires the \pkg{lubridate} package.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a [lubridate::Period-class] vector.
#' @family duration functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_dur(lubridate::period(year = 1, month = 2, day = 3))
#' to_dur("P3Y6M4DT12H30M5S")
#' to_dur("PT1M")
#' to_dur("P4W")
#' to_dur(c("P1D", NA))
#' to_dur(3661)
#' to_dur(as.difftime(90, units = "mins"))
#' to_dur(NULL)
#' try(to_dur("P"))
#' try(to_dur(c("P1D", "not-a-duration")))
to_dur <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to_dur")
}

#' @export
#' @rdname to_dur
to_duration <- to_dur

#' @export
#' @rdname to_dur
to_dur.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
#' @rdname to_dur
to_dur.Period <- function(x, ...) {
  return(x)
}

#' @export
#' @rdname to_dur
to_dur.character <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  rlang::check_installed(
    "lubridate",
    reason = "to parse character duration values"
  )
  not_na <- !is.na(x)

  # RFC 3339 duration grammar: an optional Y/M/D date part followed by an
  # optional "T"-prefixed H/M/S time part, or a stand-alone week form; the
  # two forms cannot be mixed, and (unlike full ISO 8601) fractional
  # components are not permitted.
  date_time_pattern <- paste0(
    "^P(?:([0-9]+)Y)?(?:([0-9]+)M)?(?:([0-9]+)D)?",
    "(T(?:([0-9]+)H)?(?:([0-9]+)M)?(?:([0-9]+)S)?)?$"
  )
  week_pattern <- "^P([0-9]+)W$"

  dt_matches <- regmatches(x, regexec(date_time_pattern, x))
  dt_shaped <- lengths(dt_matches) > 0L
  wk_matches <- regmatches(x, regexec(week_pattern, x))
  wk_shaped <- lengths(wk_matches) > 0L

  year <- month <- day <- hour <- minute <- second <- rep(NA_real_, length(x))
  well_shaped <- rep(FALSE, length(x))

  to_parse_dt <- not_na & dt_shaped
  if (any(to_parse_dt)) {
    parsed <- .parse_dur_date_time_parts(dt_matches[to_parse_dt])
    year[to_parse_dt] <- parsed$year
    month[to_parse_dt] <- parsed$month
    day[to_parse_dt] <- parsed$day
    hour[to_parse_dt] <- parsed$hour
    minute[to_parse_dt] <- parsed$minute
    second[to_parse_dt] <- parsed$second
    well_shaped[to_parse_dt] <- parsed$valid
  }

  to_parse_wk <- not_na & wk_shaped & !dt_shaped
  if (any(to_parse_wk)) {
    weeks <- as.numeric(vapply(wk_matches[to_parse_wk], `[[`, character(1), 2))
    year[to_parse_wk] <- 0
    month[to_parse_wk] <- 0
    day[to_parse_wk] <- weeks * 7
    hour[to_parse_wk] <- 0
    minute[to_parse_wk] <- 0
    second[to_parse_wk] <- 0
    well_shaped[to_parse_wk] <- TRUE
  }

  failures <- not_na & !well_shaped
  .check_cast_failures(
    x,
    failures,
    x_class,
    .duration_type_obj(),
    "invalid or ambiguous duration format",
    x_arg,
    call
  )

  .new_period_vec(year, month, day, hour, minute, second)
}

#' Parse the regex captures from `to_dur.character()`'s date/time form
#'
#' @param matches `(list)` A list of character vectors, each the result of
#'   [regmatches()] on a single string that matched the RFC 3339 duration
#'   date/time pattern: the full match, followed by year, month, day, the whole
#'   `"T"`-prefixed time block, hour, minute, and second.
#' @returns A list with numeric `year`, `month`, `day`, `hour`, `minute`, and
#'   `second` components (each `0` where the corresponding piece was absent),
#'   and a logical `valid` vector that is `FALSE` where the match does not
#'   describe a real duration (such as `"P"` or `"PT"`, which have no components
#'   at all).
#' @keywords internal
.parse_dur_date_time_parts <- function(matches) {
  parts <- do.call(rbind, matches)
  num <- function(col) ifelse(col == "", 0, as.numeric(col))

  year <- num(parts[, 2])
  month <- num(parts[, 3])
  day <- num(parts[, 4])
  time_block <- parts[, 5]
  hour <- num(parts[, 6])
  minute <- num(parts[, 7])
  second <- num(parts[, 8])

  has_date_component <- parts[, 2] != "" | parts[, 3] != "" | parts[, 4] != ""
  has_time_component <- parts[, 6] != "" | parts[, 7] != "" | parts[, 8] != ""
  # A bare "P" (no components at all) or a "T" block with no hour, minute, or
  # second is not a valid RFC 3339 duration.
  valid <- (has_date_component | has_time_component) &
    !(time_block != "" & !has_time_component)

  list(
    year = year,
    month = month,
    day = day,
    hour = hour,
    minute = minute,
    second = second,
    valid = valid
  )
}

#' @export
#' @rdname to_dur
to_dur.factor <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_dur(
    as.character(x),
    ...,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to_dur
to_dur.difftime <- function(x, ..., call = caller_env()) {
  rlang::check_installed(
    "lubridate",
    reason = "to convert difftime values to a duration"
  )
  # A difftime carries a single fixed unit (secs, mins, hours, days, or
  # weeks); as.period() maps that unit onto the matching Period component,
  # which is lossless (unlike collapsing everything to seconds).
  return(lubridate::as.period(x))
}

#' @export
#' @rdname to_dur
to_dur.numeric <- function(x, ..., call = caller_env()) {
  rlang::check_installed(
    "lubridate",
    reason = "to convert numeric seconds to a duration"
  )
  # Numeric values are treated as (fractional) seconds; lubridate breaks
  # these into day/hour/minute/second components, with no year or month
  # component, since a number of seconds can't unambiguously imply a
  # calendar length.
  return(lubridate::seconds_to_period(x))
}

#' @export
#' @rdname to_dur
to_dur.integer <- function(x, ..., call = caller_env()) {
  to_dur.numeric(x, call = call)
}

#' @export
to_dur.default <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  vctrs::vec_cast(x, .duration_type_obj(), x_arg = x_arg, call = call)
}

#' Build a vector of [lubridate::Period-class] from component vectors
#'
#' `lubridate::period()` pairs a `num` vector elementwise against `units`,
#' rather than building one period per row, so it can't build a vector of
#' independent periods from parallel component vectors. This constructs the
#' `Period` object directly instead, which is vectorized over its slots.
#'
#' @param year,month,day,hour,minute,second `(numeric)` Parallel vectors of
#'   period components, the same length.
#' @returns A [lubridate::Period-class] vector the same length as the inputs.
#' @keywords internal
.new_period_vec <- function(year, month, day, hour, minute, second) {
  methods::new(
    "Period",
    .Data = as.numeric(second),
    year = as.numeric(year),
    month = as.numeric(month),
    day = as.numeric(day),
    hour = as.numeric(hour),
    minute = as.numeric(minute)
  )
}

#' Coerce to length-1 duration
#'
#' Checks whether a vector can be coerced to a length-1
#' [lubridate::Period-class] vector.
#'
#' @inheritParams .shared-params
#' @inheritParams to_dur
#'
#' @returns The input as a length-1 [lubridate::Period-class] vector.
#' @family duration functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_dur_scalar("P1D")
#' try(to_dur_scalar(c("P1D", "P2D")))
to_dur_scalar <- function(
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
    is_rlang_cls_scalar = .is_scalar_dur,
    to_cls_fn = to_dur,
    to_cls_args = list(...),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' Test for a length-1 duration vector
#'
#' @inheritParams .shared-params-check
#' @returns `TRUE` if `x` is a length-1 [lubridate::Period-class] vector, else
#'   `FALSE`.
#' @keywords internal
.is_scalar_dur <- function(x) {
  inherits(x, "Period") && length(x) == 1L
}

#' An empty duration object for error messages
#'
#' [object_type()] renders a [lubridate::Period-class] as `"Period"`, but the
#' duration family uses `"duration"` in its coercion classes and messages, to
#' match the `to_dur()`/`stabilize_dur()` function names. This
#' returns an empty object that renders as `"duration"` so error subclasses
#' read `<stbl-error-incompatible_values-duration>`.
#'
#' @returns A zero-length object whose [object_type()] is `"duration"`.
#' @keywords internal
.duration_type_obj <- function() {
  structure(double(), class = "duration")
}
