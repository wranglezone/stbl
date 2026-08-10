#' Coerce to time-of-day with additional checks
#'
#' Compared to [to_time()], `stabilize_time()` checks more details, but is
#' slower. `stabilise_time()` is a synonym of `stabilize_time()`.
#'
#' @inheritParams .shared-params
#' @inheritParams to_time
#'
#' @returns The input as an [hms::hms()] vector, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-time>` when `x` cannot be coerced to a time of
#'   day.
#'   - `<stbl-error-incompatible_values-time>` when some values cannot be
#'   safely converted to a time of day.
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
#' @family time functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_time(hms::hms(0, 20, 13))
#' stabilize_time("13:20:00Z")
#' stabilize_time(NULL)
#' try(stabilize_time(NULL, allow_null = FALSE))
#' try(stabilize_time(c("13:20:00Z", NA), allow_na = FALSE))
#' try(stabilize_time("13:20:00"))
#' try(stabilize_time("13:20:00Z", min_value = "18:00:00Z"))
#' try(stabilize_time("13:20:00Z", max_value = "06:00:00Z"))
stabilize_time <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls(
    x,
    to_cls_fn = to_time,
    check_cls_value_fn = .check_value_time,
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
#' @rdname stabilize_time
stabilise_time <- stabilize_time

#' Coerce to length-1 time-of-day with additional checks
#'
#' Checks whether a vector can be coerced to a length-1 [hms::hms()] vector.
#' `stabilize_time_scalar()` is optimized to check for length-1 time-of-day
#' vectors (compared to [stabilize_time()] with `max_size = 1`).
#' `stabilise_time_scalar` is a synonym of `stabilize_time_scalar()`.
#'
#' @inheritParams .shared-params
#' @inheritParams to_time
#'
#' @returns The input as a length-1 [hms::hms()] vector, or an error condition
#'   with classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`,
#'   `<error>`, `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-time>` when `x` cannot be coerced to a time of
#'   day.
#'   - `<stbl-error-incompatible_values-time>` when some values cannot be
#'   safely converted to a time of day.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-outside_range>` when values fall outside `min_value` or
#'   `max_value`.
#'   - `<stbl-error-allowed_values>` when the value is not in
#'   `allowed_values`.
#' @family time functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_time_scalar(hms::hms(0, 20, 13))
#' stabilize_time_scalar("13:20:00Z")
#' try(stabilize_time_scalar(c("13:20:00Z", "14:20:00Z")))
#' try(stabilize_time_scalar(NULL))
#' stabilize_time_scalar(NULL, allow_null = TRUE)
stabilize_time_scalar <- function(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls_scalar(
    x,
    to_cls_scalar_fn = to_time_scalar,
    check_cls_value_fn = .check_value_time,
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
#' @rdname stabilize_time_scalar
stabilise_time_scalar <- stabilize_time_scalar

#' Check time-of-day values against min, max, and allowed values
#'
#' `min_value`, `max_value`, and `allowed_values` are coerced to [hms::hms()]
#' first so that character or numeric bounds are accepted.
#'
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if `x` passes all checks.
#' @keywords internal
.check_value_time <- function(
  x,
  min_value,
  max_value,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  min_value <- to_time_scalar(min_value, allow_null = TRUE, call = call)
  max_value <- to_time_scalar(max_value, allow_null = TRUE, call = call)

  not_na <- !is.na(x)
  min_failures <- if (!is.null(min_value)) not_na & x < min_value
  max_failures <- if (!is.null(max_value)) not_na & x > max_value

  if (!any(min_failures) && !any(max_failures)) {
    allowed_values <- to_time(allowed_values, allow_null = TRUE, call = call)
    .check_allowed_values(
      x,
      allowed_values = allowed_values,
      x_arg = x_arg,
      call = call
    )
    return(invisible(NULL))
  }

  min_msg <- .describe_failure_time_value(
    x,
    failures = min_failures,
    direction = "low",
    target_value = min_value,
    x_arg = x_arg
  )
  max_msg <- .describe_failure_time_value(
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

#' Describe a time-of-day value validation failure
#'
#' @param x `(hms)` The vector being checked.
#' @param failures `(logical)` Which elements failed the check.
#' @param direction `(character)` One of `"low"` or `"high"`.
#' @param target_value `(hms)` The value against which `x` is being compared.
#' @inheritParams .shared-params
#' @returns A named character vector for [.stbl_abort()], or `NULL`.
#' @keywords internal
.describe_failure_time_value <- function(
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
    "{.arg {x_arg}} must be {direction_sign}= {format(target_value)}."
  )
  failure_locations <- which(failures)
  failure_values <- format(x[failure_locations])
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
