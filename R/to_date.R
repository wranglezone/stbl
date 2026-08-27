#' Coerce to date
#'
#' Checks whether a vector can be coerced to a [base::Date] without losing
#' information, returning it silently if so. Otherwise an informative error
#' message is signaled.
#'
#' Character vectors must use the [RFC
#' 3339](https://datatracker.ietf.org/doc/html/rfc3339) `full-date` format
#' (`"YYYY-MM-DD"`); any other shape (such as `"11/13/2018"`) is rejected (but
#' see [stabilize_date()]). `POSIXct` and `POSIXlt` values are truncated to
#' their date component, discarding the time-of-day and timezone offset. Numeric
#' and integer values are treated as the number of days since the Unix epoch
#' (`"1970-01-01"`).
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a [base::Date] vector.
#' @family date functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_date(as.Date("2024-01-01"))
#' to_date("2024-01-01")
#' to_date(c("2024-01-01", NA))
#' to_date(0L)
#' to_date(as.POSIXct("2024-01-01 23:00:00", tz = "UTC"))
#' to_date(NULL)
#' try(to_date("11/13/2018"))
#' try(to_date(c("2024-01-01", "not-a-date")))
to_date <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to_date")
}

#' @export
to_date.Date <- function(x, ...) {
  return(x)
}

#' @export
#' @rdname to_date
to_date.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
#' @rdname to_date
to_date.character <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  # Only non-NA elements can fail; NA elements pass through as NA dates.
  not_na <- !is.na(x)
  # Enforce the RFC 3339 full-date shape up front so ambiguous formats such as
  # "11/13/2018" are rejected rather than silently reinterpreted.
  well_shaped <- grepl("^\\d{4}-\\d{2}-\\d{2}$", x)
  parsed <- as.Date(x, format = "%Y-%m-%d")
  failures <- not_na & (!well_shaped | is.na(parsed))
  .check_cast_failures(
    x,
    failures,
    x_class,
    .date_type_obj(),
    "invalid or ambiguous date format",
    x_arg,
    call
  )
  return(parsed)
}

#' @export
#' @rdname to_date
to_date.factor <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_date(as.character(x), ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to_date
to_date.POSIXct <- function(x, ...) {
  # Base R's Date method for POSIXct respects the tzone attribute, discarding
  # time-of-day and timezone offset.
  return(as.Date(x))
}

#' @export
#' @rdname to_date
to_date.POSIXlt <- function(x, ...) {
  return(as.Date(x))
}

#' @export
#' @rdname to_date
to_date.numeric <- function(x, ...) {
  # Numeric values are days since the Unix epoch.
  return(as.Date(x, origin = "1970-01-01"))
}

#' @export
#' @rdname to_date
to_date.integer <- function(x, ...) {
  return(as.Date(x, origin = "1970-01-01"))
}

#' @export
to_date.default <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  vctrs::vec_cast(x, as.Date("2026-01-01"), x_arg = x_arg, call = call)
}

#' Coerce to length-1 date
#'
#' Checks whether a vector can be coerced to a length-1 [base::Date] vector.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a length-1 [base::Date] vector.
#' @family date functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_date_scalar("2024-01-01")
#' try(to_date_scalar(c("2024-01-01", "2024-01-02")))
to_date_scalar <- function(
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
    is_rlang_cls_scalar = .is_scalar_date,
    to_cls_fn = to_date,
    to_cls_args = list(...),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' Test for a length-1 date vector
#'
#' @inheritParams .shared-params-check
#' @returns `TRUE` if `x` is a length-1 [base::Date] vector, else `FALSE`.
#' @keywords internal
.is_scalar_date <- function(x) {
  inherits(x, "Date") && length(x) == 1L
}

#' An empty date object for error messages
#'
#' [object_type()] renders a [base::Date] as `"Date"`, but the date family uses
#' the lowercase `"date"` in its coercion classes and messages. This returns an
#' empty object that renders as `"date"` so error subclasses read
#' `<stbl-error-incompatible_values-date>`.
#'
#' @returns A zero-length object whose [object_type()] is `"date"`.
#' @keywords internal
.date_type_obj <- function() {
  structure(double(), class = "date")
}
