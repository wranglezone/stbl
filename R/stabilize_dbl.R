#' Ensure a double argument meets expectations
#'
#' @description `to_dbl()` checks whether an argument can be coerced to double
#'   without losing information, returning it silently if so. Otherwise an
#'   informative error message is signaled. `to_double` is a synonym of
#'   `to_dbl()`.
#'
#'   `stabilize_dbl()` can check more details about the argument, but is slower
#'   than `to_dbl()`. `stabilise_dbl()`, `stabilize_double()`, and
#'   `stabilise_double()` are synonyms of `stabilize_dbl()`.
#'
#'   `stabilize_dbl_scalar()` and `to_dbl_scalar()` are optimized to check for
#'   length-1 double vectors. `stabilise_dbl_scalar`,
#'   `stabilize_double_scalar()`, and `stabilise_double_scalar` are synonyms of
#'   `stabilize_dbl_scalar()`, and `to_double_scalar()` is a synonym of
#'   `to_dbl_scalar()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The argument as a double vector.
#' @family double functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_dbl(1:10)
#' to_dbl("1.1")
#' to_dbl(1 + 0i)
#' to_dbl(NULL)
#' try(to_dbl("a"))
#' try(to_dbl("1.1", coerce_character = FALSE))
#'
#' to_dbl_scalar("1.1")
#' try(to_dbl_scalar(1:10))
#'
#' stabilize_dbl(1:10)
#' stabilize_dbl("1.1")
#' stabilize_dbl(1 + 0i)
#' stabilize_dbl(NULL)
#' try(stabilize_dbl(NULL, allow_null = FALSE))
#' try(stabilize_dbl(c(1.1, NA), allow_na = FALSE))
#' try(stabilize_dbl(letters))
#' try(stabilize_dbl("1.1", coerce_character = FALSE))
#' try(stabilize_dbl(factor(c("1.1", "a"))))
#' try(stabilize_dbl(factor("1.1"), coerce_factor = FALSE))
#' try(stabilize_dbl(1:10, min_value = 3.5))
#' try(stabilize_dbl(1:10, max_value = 7.5))
#'
#' stabilize_dbl_scalar(1.0)
#' stabilize_dbl_scalar("1.1")
#' try(stabilize_dbl_scalar(1:10))
#' stabilize_dbl_scalar(NULL)
#' try(stabilize_dbl_scalar(NULL, allow_null = FALSE))
stabilize_dbl <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls(
    x,
    to_cls_fn = to_dbl,
    to_cls_args = list(
      coerce_character = coerce_character,
      coerce_factor = coerce_factor
    ),
    check_cls_value_fn = .check_value_dbl,
    check_cls_value_fn_args = list(
      min_value = min_value,
      max_value = max_value
    ),
    allow_null = allow_null,
    allow_na = allow_na,
    min_size = min_size,
    max_size = max_size,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
#' @rdname stabilize_dbl
stabilize_double <- stabilize_dbl

#' @export
#' @rdname stabilize_dbl
stabilise_dbl <- stabilize_dbl

#' @export
#' @rdname stabilize_dbl
stabilise_double <- stabilize_dbl

#' @export
#' @rdname stabilize_dbl
stabilize_dbl_scalar <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls_scalar(
    x,
    to_cls_scalar_fn = to_dbl_scalar,
    to_cls_scalar_args = list(
      coerce_character = coerce_character,
      coerce_factor = coerce_factor
    ),
    check_cls_value_fn = .check_value_dbl,
    check_cls_value_fn_args = list(
      min_value = min_value,
      max_value = max_value
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
#' @rdname stabilize_dbl
stabilize_double_scalar <- stabilize_dbl_scalar

#' @export
#' @rdname stabilize_dbl
stabilise_dbl_scalar <- stabilize_dbl_scalar

#' @export
#' @rdname stabilize_dbl
stabilise_double_scalar <- stabilize_dbl_scalar

#' Check double values against min and max values
#'
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if `x` passes all checks.
#' @keywords internal
.check_value_dbl <- function(
  x,
  min_value,
  max_value,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  min_value <- to_dbl_scalar(min_value, call = call)
  max_value <- to_dbl_scalar(max_value, call = call)
  min_failure_locations <- .find_failures(x, min_value, `<`)
  max_failure_locations <- .find_failures(x, max_value, `>`)
  if (is.null(min_failure_locations) && is.null(max_failure_locations)) {
    return(invisible(NULL))
  }
  min_msg <- .describe_failure_dbl_value(
    x,
    failure_locations = min_failure_locations,
    direction = "low",
    target_value = min_value,
    x_arg = x_arg
  )

  max_msg <- .describe_failure_dbl_value(
    x,
    failure_locations = max_failure_locations,
    direction = "high",
    target_value = max_value,
    x_arg = x_arg
  )
  .stbl_abort(
    c(min_msg, max_msg),
    subclass = "outside_range",
    call = call,
    message_env = rlang::current_env()
  )
}

#' Describe a numeric value validation failure
#'
#' @param x `(numeric)` The vector being checked.
#' @param failure_locations `(integer)` Indices where the check failed.
#' @param direction `(character)` One of `"low"` or `"high"`.
#' @param target_value `(numeric)` The value against which `x` is being compared.
#' @inheritParams .shared-params
#'
#' @returns A named character vector for `.stbl_abort()`.
#' @keywords internal
.describe_failure_dbl_value <- function(
  x,
  failure_locations,
  direction,
  target_value,
  x_arg
) {
  if (is.null(failure_locations)) {
    return(NULL)
  }
  direction_sign <- if (direction == "low") ">" else "<"
  msg_main <- format_inline(
    "{.arg {x_arg}} must be {direction_sign}= {target_value}."
  )
  if (length(x) == 1) {
    return(.describe_failure_dbl_value_single(x, msg_main, direction))
  }
  .describe_failure_dbl_value_multi(
    x,
    msg_main = msg_main,
    failure_locations = failure_locations,
    direction = direction
  )
}

#' Describe a single numeric value failure
#'
#' @param msg_main `(character)` The main error message.
#' @inheritParams .describe_failure_dbl_value
#' @returns A named character vector.
#' @keywords internal
.describe_failure_dbl_value_single <- function(x, msg_main, direction) {
  c(
    msg_main,
    "x" = format_inline("{.val {x}} is too {direction}.")
  )
}

#' Describe multiple numeric value failures
#'
#' @inheritParams .describe_failure_dbl_value_single
#' @returns A named character vector.
#' @keywords internal
.describe_failure_dbl_value_multi <- function(
  x,
  msg_main,
  failure_locations,
  direction
) {
  n_failures <- length(failure_locations)
  failure_values <- x[failure_locations]
  c(
    msg_main,
    "i" = glue("Some values are too {direction}."),
    "x" = format_inline("{qty(n_failures)}Location{?s}: {failure_locations}"),
    "x" = format_inline("{qty(n_failures)}Value{?s}: {failure_values}")
  )
}
