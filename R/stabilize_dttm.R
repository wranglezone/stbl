#' Coerce to date-time with additional checks
#'
#' Compared to [to_dttm()], `stabilize_dttm()` checks more details, but is
#' slower. Unlike [to_dttm()], character input is tried against a list of
#' `accepted_datetime_formats` rather than only the strict RFC 3339 shape:
#' locale-dependent date orders such as `"11/13/2018"` are accepted where
#' unambiguous, and a UTC offset is no longer required (date-times without
#' one are treated as wall-clock time in `tz`). `stabilise_dttm()`,
#' `stabilize_datetime()`, `stabilise_dttm()`, `stabilize_datetime()`, and
#' `stabilise_datetime()` are synonyms of `stabilize_dttm()`.
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
#'   [OlsonNames()].
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
#'   [OlsonNames()].
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
