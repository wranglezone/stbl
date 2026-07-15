#' Coerce to a function
#'
#' `to_fn()` coerces `x` to a function. `to_function()` is a synonym of
#' `to_fn()`.
#'
#' @details
#' Unlike [rlang::as_function()], `to_fn()` supports namespaced function names
#' such as `"pkg::fn"` in the character method. When the input is a
#' length-0 character vector, `to_fn()` returns `NULL` (subject to
#' `allow_null`). An input of length > 1 is always an error.
#'
#' @param allow_null `(length-1 logical)` Is `NULL` an acceptable return value?
#'   When `TRUE` (the default), a length-0 character input or a `NULL` input
#'   returns `NULL`. When `FALSE`, those inputs throw an error.
#' @param definition_env `(environment)` The environment in which to look up
#'   function names. Defaults to [rlang::global_env()]. This argument is named
#'   `definition_env` to avoid confusion with [rlang::fn_env()], which returns
#'   the environment *enclosed* by an existing function. This argument is
#'   ignored when the input is a namespaced string of the form `"pkg::fn"`, in
#'   which case the package namespace is used instead.
#' @inheritParams .shared-params
#' @returns A function.
#' @family function functions
#' @export
#'
#' @examples
#' to_fn("mean")
#' to_fn(~ . + 1)
#' to_fn(mean)
#' to_fn("stats::median")
#' to_fn(NULL)
to_fn <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to_fn")
}

#' @export
#' @rdname to_fn
to_function <- to_fn

#' @export
to_fn.function <- function(x, ...) {
  return(x)
}

#' @export
#' @rdname to_fn
to_fn.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
#' @rdname to_fn
to_fn.character <- function(
  x,
  ...,
  allow_null = TRUE,
  definition_env = rlang::global_env(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  if (!length(x)) {
    return(.to_null(NULL, allow_null = allow_null, x_arg = x_arg, call = call))
  }
  if (length(x) > 1L) {
    x_size <- length(x)
    .stop_must(
      "must be a single function name.",
      x_arg = x_arg,
      call = call,
      additional_msg = c(x = "{.arg {x_arg}} has {no(x_size)} values."),
      subclass = "non_scalar",
      message_env = rlang::current_env()
    )
  }
  try_fetch(
    .Call(stbl_chr_to_fn, x, definition_env),
    stbl_invalid_function_name = function(cnd) {
      .stop_must(
        "must be a valid function name.",
        x_arg = x_arg,
        call = call,
        subclass = "invalid_function_name",
        message_env = rlang::current_env()
      )
    },
    stbl_unknown_function = function(cnd) {
      .stop_must(
        "must be the name of a known function.",
        x_arg = x_arg,
        call = call,
        additional_msg = c(x = "Can't find function {.fn {x}}."),
        subclass = "unknown_function",
        message_env = rlang::current_env()
      )
    }
  )
}

#' @export
#' @rdname to_fn
to_fn.default <- function(
  x,
  ...,
  definition_env = rlang::global_env(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  try_fetch(
    rlang::as_function(x, env = definition_env, arg = x_arg, call = call),
    error = function(cnd) {
      .stop_cant_coerce(
        from_class = x_class,
        to_class = "function",
        x_arg = x_arg,
        call = call
      )
    }
  )
}
