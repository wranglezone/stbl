#' @export
#' @rdname stabilize_fct
to_fct <- function(
  x,
  ...,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to_fct")
}

#' @export
#' @rdname stabilize_fct
to_factor <- to_fct

#' @export
to_fct.factor <- function(
  x,
  ...,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env()
) {
  levels <- levels %||% levels(x)
  return(.coerce_fct_levels(x, levels, to_na, x_arg, call))
}

#' @export
to_fct.character <- function(
  x,
  ...,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env()
) {
  return(.coerce_fct_levels(x, levels, to_na, x_arg, call))
}

#' @export
#' @rdname stabilize_fct
to_fct.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
to_fct.list <- function(
  x,
  ...,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_cls_from_list(
    x,
    to_fct,
    "factor",
    ...,
    levels = levels,
    to_na = to_na,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
to_fct.default <- function(
  x,
  ...,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  try_fetch(
    {
      x <- as.factor(x)
    },
    error = function(cnd) {
      .stop_cant_coerce(
        from_class = x_class,
        to_class = "factor",
        x_arg = x_arg,
        call = call
      )
    }
  )
  return(.coerce_fct_levels(x, levels, to_na, x_arg, call))
}

#' Coerce to factor with specified levels
#'
#' A wrapper around level-coercion helpers.
#'
#' @inheritParams .shared-params
#' @returns `x` as a factor with specified levels and NAs.
#' @keywords internal
.coerce_fct_levels <- function(
  x,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env()
) {
  x <- .coerce_fct_to_na(x, to_na, call)
  x <- .coerce_fct_levels_impl(x, levels, to_na, x_arg, call)
  return(x)
}

#' Coerce specified values to NA
#'
#' A helper that converts specified values in `x` to `NA`.
#'
#' @inheritParams .shared-params
#' @returns `x` with specified values converted to `NA`.
#' @keywords internal
.coerce_fct_to_na <- function(x, to_na = character(), call = caller_env()) {
  to_na <- to_chr(to_na, call = call)
  if (length(to_na)) {
    x[x %in% to_na] <- NA
  }
  return(x)
}

#' Core implementation for applying factor levels
#'
#' Checks for values in `x` that are not present in `levels` and throws an error
#' if any are found.
#'
#' @inheritParams .shared-params
#' @returns `x` as a factor with the specified levels.
#' @keywords internal
.coerce_fct_levels_impl <- function(
  x,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env()
) {
  levels <- to_chr(levels, call = call)
  if (length(levels)) {
    # Don't send to_na because it has already been applied
    bad_casts <- .are_not_fct_ish_chr(x, levels)
    if (any(bad_casts)) {
      .stop_bad_levels(x, bad_casts, levels, to_na, x_arg, call)
    }
    return(factor(as.character(x), levels = levels))
  }
  return(factor(x))
}

#' Stop for bad factor levels
#'
#' Throws a standardized error when values are not found in the provided factor
#' levels.
#'
#' @param bad_casts `(logical)` A logical vector indicating which elements of
#'   `x` are not in the allowed levels.
#' @inheritParams .shared-params
#' @returns This function is called for its side effect of throwing an error and
#'   does not return a value.
#' @keywords internal
.stop_bad_levels <- function(x, bad_casts, levels, to_na, x_arg, call) {
  bad_values <- unique(x[bad_casts])
  msg <- c(
    "Each value of {.arg {x_arg}} must be in the expected levels.",
    "i" = "Allowed levels: {.str {levels}}."
  )
  if (length(to_na)) {
    msg <- c(
      msg,
      "i" = "Values that are converted to {.code NA}: {.str {to_na}}."
    )
  }
  msg <- c(
    msg,
    "x" = "Unexpected values: {.str {bad_values}}."
  )
  .stbl_abort(
    message = msg,
    subclass = "fct_levels",
    call = call,
    message_env = rlang::current_env()
  )
}

#' @export
#' @rdname stabilize_fct
to_fct_scalar <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_cls_scalar(
    x,
    is_rlang_cls_scalar = .fast_false,
    to_cls_fn = to_fct,
    to_cls_args = list(levels = levels, to_na = to_na, ...),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname stabilize_fct
to_factor_scalar <- to_fct_scalar

#' Always return FALSE
#'
#' A helper to force the slow path in [`.to_cls_scalar()`] for factors, since
#' `rlang::is_scalar_factor()` does not exist.
#'
#' @param x An object (ignored).
#' @returns `FALSE`, always.
#' @keywords internal
.fast_false <- function(x) {
  FALSE
}
