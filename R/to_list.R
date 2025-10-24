#' Ensure a list argument meets expectations
#'
#' @description `to_list()` checks whether an argument can be coerced to a list
#'   without losing information, returning it silently if so. Otherwise an
#'   informative error message is signaled. `to_lst()` is an alias of
#'   `to_list()`.
#'
#' @details This function has three important distinctions from
#'   [base::as.list()]:
#' - Functions can be rejected as part of the call to this function (with
#'   `coerce_function = FALSE`, the default). If they are allowed, they'll be
#'   coerced to a list concatenating their formals and body (as with
#'   [base::as.list()].
#' - Primitive functions (such as [base::is.na()] or [base::is.list()]) always
#'   throw an error, rather than returning `list(NULL)`.
#' - `NULL` values can be rejected as part of the call to this function (with
#'   `allow_null = FALSE`).
#'
#' @param ... Arguments passed to [base::as.list()] or other methods.
#' @inheritParams .shared-params
#'
#' @returns The argument as a list.
#' @export
to_list <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  UseMethod("to_list")
}

#' @export
#' @rdname to_list
to_lst <- to_list

#' @export
#' @rdname to_list
to_list.list <- function(x, ...) {
  x
}

#' @export
#' @rdname to_list
to_list.default <- function(x, ...) {
  as.list(x, ...)
}

#' @export
#' @rdname to_list
to_list.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
#' @rdname to_list
to_list.function <- function(
  x,
  ...,
  coerce_function = FALSE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .check_function_allowed(x, coerce_function, x_arg = x_arg, call = call)
  .check_is_not_primitive(x, x_arg = x_arg, call = call)
  as.list(x, ...)
}

#' Check whether functions are allowed
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#'
#' @returns `NULL`, invisibly, if `x` passes the check.
#' @keywords internal
.check_function_allowed <- function(
  x,
  coerce_function = FALSE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  if (is.function(x) && !coerce_function) {
    .stop_function(x_arg = x_arg, call = call)
  }
}

#' Abort because an argument must not be a function
#'
#' @inheritParams .stbl_abort
#' @inheritParams .shared-params
#'
#' @returns This function is called for its side effect of throwing an error and
#'   does not return a value.
#' @keywords internal
.stop_function <- function(x_arg, call) {
  .stop_must(
    "must not be a {.cls function}.",
    x_arg = x_arg,
    call = call,
    subclass = "bad_function"
  )
}

#' Error if an object is a primitive function
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#'
#' @returns `NULL`, invisibly, if `x` passes the check.
#' @keywords internal
.check_is_not_primitive <- function(
  x,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  if (is.primitive(x)) {
    .stop_cant_coerce(
      "primitive function",
      "list",
      x_arg = x_arg,
      call = call
    )
  }
}
