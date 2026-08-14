#' Coerce to date with additional checks
#'
#' Compared to [to_date()], `stabilize_date()` checks more details, but is
#' slower. `stabilise_date()` is a synonym of `stabilize_date()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a [base::Date] vector, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-date>` when `x` cannot be coerced to date.
#'   - `<stbl-error-incompatible_values-date>` when some values cannot be safely
#'   converted to date.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-size_too_small>` when the vector is shorter than `min_size`.
#'   - `<stbl-error-size_too_large>` when the vector is longer than `max_size`.
#'   - `<stbl-error-duplicate_elements>` when `unique = TRUE` and duplicates are
#'   present.
#'   - `<stbl-error-outside_range>` when values fall outside `min_value` or
#'   `max_value`.
#'   - `<stbl-error-allowed_values>` when values are not in `allowed_values`.
#' @family date functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_date(as.Date("2024-01-01"))
#' stabilize_date("2024-01-01")
#' stabilize_date(NULL)
#' try(stabilize_date(NULL, allow_null = FALSE))
#' try(stabilize_date(c(as.Date("2024-01-01"), NA), allow_na = FALSE))
#' try(stabilize_date("11/13/2018"))
#' try(stabilize_date("2024-01-01", min_value = "2024-06-01"))
#' try(stabilize_date("2024-12-01", max_value = "2024-06-01"))
#' try(stabilize_date(
#'   c("2024-01-01", "2024-01-02"),
#'   allowed_values = "2024-01-01"
#' ))
stabilize_date <- function(
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
    to_cls_fn = to_date,
    check_cls_value_fn = .check_value_date,
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
#' @rdname stabilize_date
stabilise_date <- stabilize_date

#' Coerce to length-1 date with additional checks
#'
#' Checks whether a vector can be coerced to a length-1 [base::Date] vector.
#' `stabilize_date_scalar()` is optimized to check for length-1 date vectors
#' (compared to [stabilize_date()] with `max_size = 1`). `stabilise_date_scalar`
#' is a synonym of `stabilize_date_scalar()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a length-1 [base::Date] vector, or an error condition
#'   with classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`,
#'   `<error>`, `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-date>` when `x` cannot be coerced to date.
#'   - `<stbl-error-incompatible_values-date>` when some values cannot be safely
#'   converted to date.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-outside_range>` when values fall outside `min_value` or
#'   `max_value`.
#'   - `<stbl-error-allowed_values>` when the value is not in `allowed_values`.
#' @family date functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_date_scalar(as.Date("2024-01-01"))
#' stabilize_date_scalar("2024-01-01")
#' try(stabilize_date_scalar(c("2024-01-01", "2024-01-02")))
#' try(stabilize_date_scalar(NULL))
#' stabilize_date_scalar(NULL, allow_null = TRUE)
stabilize_date_scalar <- function(
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
    to_cls_scalar_fn = to_date_scalar,
    check_cls_value_fn = .check_value_date,
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
#' @rdname stabilize_date_scalar
stabilise_date_scalar <- stabilize_date_scalar

#' Check date values against min, max, and allowed values
#'
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if `x` passes all checks.
#' @keywords internal
.check_value_date <- function(
  x,
  min_value,
  max_value,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  min_value <- to_date_scalar(min_value, allow_null = TRUE, call = call)
  max_value <- to_date_scalar(max_value, allow_null = TRUE, call = call)

  not_na <- !is.na(x)
  min_failures <- if (!is.null(min_value)) not_na & x < min_value
  max_failures <- if (!is.null(max_value)) not_na & x > max_value

  if (!any(min_failures) && !any(max_failures)) {
    allowed_values <- to_date(allowed_values, allow_null = TRUE, call = call)
    .check_allowed_values(
      x,
      allowed_values = allowed_values,
      x_arg = x_arg,
      call = call
    )
    return(invisible(NULL))
  }

  min_msg <- .describe_failure_date_value(
    x,
    failures = min_failures,
    direction = "low",
    target_value = min_value,
    x_arg = x_arg
  )
  max_msg <- .describe_failure_date_value(
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

#' Describe a date value validation failure
#'
#' @param x `(Date)` The vector being checked.
#' @param failures `(logical)` Which elements failed the check.
#' @param direction `(character)` One of `"low"` or `"high"`.
#' @param target_value `(Date)` The value against which `x` is being compared.
#' @inheritParams .shared-params
#' @returns A named character vector for [.stbl_abort()], or `NULL`.
#' @keywords internal
.describe_failure_date_value <- function(
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
    "{.arg {x_arg}} must be {direction_sign}= {as.character(target_value)}."
  )
  failure_locations <- which(failures)
  # Convert to character so cli reports the dates rather than their numeric
  # (days-since-epoch) representation.
  failure_values <- as.character(x[failure_locations])
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
