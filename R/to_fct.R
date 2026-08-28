#' Coerce to factor
#'
#' Checks whether a vector can be coerced to a factor without losing
#' information, returning it silently if so. Otherwise an informative error
#' message is signaled. `to_factor` is a synonym of `to_fct()`.
#'
#' @details This function has important differences from [base::as.factor()]
#'   and [base::factor()]:
#'
#' - Values are never silently coerced to `NA` unless they are explicitly
#'   supplied in the `to_na` argument.
#' - `NULL` values can be rejected as part of the call to this function (with
#'   `allow_null = FALSE`).
#'
#' @inheritParams .shared-params
#' @param levels `(character)` Expected levels. If `NULL` (default), the levels
#'   will be computed by [base::factor()].
#'
#' @returns The input as a factor, or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-factor>` when `x` cannot be coerced to factor.
#'   - `<stbl-error-incompatible_values-factor>` when some elements of a list
#'   cannot be converted to factor.
#'   - `<stbl-error-fct_levels>` when values are not present in `levels`.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#' @family factor functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_fct("a")
#' to_fct(1:10)
#' to_fct(NULL)
#' try(to_fct(letters[1:5], levels = c("a", "c"), to_na = "b"))
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
#' @rdname to_fct
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
to_fct.integer <- function(
  x,
  ...,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env()
) {
  if (is.null(levels)) {
    # Use stbl_int_to_fct for numerically-ordered levels, then pass those
    # levels explicitly to .coerce_fct_levels so to_na and error handling
    # work correctly without re-sorting as strings.
    fct <- .Call(stbl_int_to_fct, x, NULL, FALSE)
    return(.coerce_fct_levels(
      fct[["result"]],
      levels(fct[["result"]]),
      to_na,
      x_arg,
      call
    ))
  }
  x <- .Call(stbl_int_to_chr, x)[["result"]]
  return(.coerce_fct_levels(x, levels, to_na, x_arg, call))
}
#' @export
#' @rdname to_fct
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
  res <- .Call(stbl_lst_to_fct, x)
  .check_lst_failures(x, res[["valid"]], factor(), x_class, x_arg, call)
  .coerce_fct_levels(res[["result"]], levels, to_na, x_arg, call)
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
#' @param bad_casts `(logical)` A logical vector indicating which elements of
#'   `x` are not in the allowed levels.
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @keywords internal
.stop_bad_levels <- function(x, bad_casts, levels, to_na, x_arg, call) {
  locations <- which(bad_casts)
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
    message_env = rlang::current_env(),
    locations = locations
  )
}

#' Coerce to length-1 factor
#'
#' Checks whether a vector can be coerced to a length-1 factor.
#' `to_fct_scalar()` is optimized to check for length-1 factors (compared to
#' [stabilize_fct()] with `max_size = 1`). `to_factor_scalar()` is a synonym
#' of `to_fct_scalar()`.
#'
#' @inheritParams .shared-params
#' @param levels `(character)` Expected levels. If `NULL` (default), the levels
#'   will be computed by [base::factor()].
#'
#' @returns The input as a length-1 factor, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-factor>` when `x` cannot be coerced to factor.
#'   - `<stbl-error-incompatible_values-factor>` when some elements of a list
#'   cannot be converted to factor.
#'   - `<stbl-error-fct_levels>` when values are not present in `levels`.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#' @family factor functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_fct_scalar("a")
#' try(to_fct_scalar(letters))
to_fct_scalar <- function(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
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
#' @rdname to_fct_scalar
to_factor_scalar <- to_fct_scalar

#' Force slow path in `.to_cls_scalar()`
#'
#' @param x An object (ignored).
#' @returns `FALSE`, always.
#' @keywords internal
.fast_false <- function(x) {
  FALSE
}
