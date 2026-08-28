#' Coerce to character
#'
#' Checks whether a vector can be coerced to character without losing
#' information, returning it silently if so. Otherwise an informative error
#' message is signaled. `to_character` is a synonym of `to_chr()`.
#'
#' @details This function has two important differences from
#'   [base::as.character()]:
#'
#' - `list`s and `data.frame`s are *not* coerced to character. In base R, such
#'   objects are coerced to character representations of their elements. For
#'   example, `as.character(list(1:3))` returns "1:3". In the unlikely event
#'   that this is the expected behavior, use `as.character()` instead.
#' - `NULL` values can be rejected as part of the call to this function (with
#'   `allow_null = FALSE`).
#'
#' Named functions are converted to their string name. If the function comes
#' from a package namespace, the result is a `"pkg::fn"` string. For example,
#' `to_chr(mean)` returns `"base::mean"`. Anonymous functions produce an error.
#'
#' To preserve the original call-site symbol when `to_chr()` is called inside
#' a wrapper function, use the embrace operator `{{ }}`. For example:
#'
#' ```r
#' my_wrapper <- function(fn) {
#'   to_chr({{ fn }})
#' }
#' my_wrapper(mean)  # Returns "base::mean"
#' ```
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a character vector, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-character>` when `x` cannot be coerced to character
#'   (for example a `data.frame`, or an anonymous function).
#'   - `<stbl-error-incompatible_values-character>` when some elements of a
#'   list cannot be converted to character.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#' @family character functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_chr("a")
#' to_chr(letters)
#' to_chr(1:10)
#' to_chr(1 + 0i)
#' to_chr(NULL)
#' try(to_chr(NULL, allow_null = FALSE))
#'
#' # Named functions are converted to their string name.
#' to_chr(mean)
#' to_chr(base::mean)
#' try(to_chr(function(x) x))
to_chr <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  x_quo <- rlang::enquo(x)
  if (is.function(x)) {
    force(x_class)
    x <- x_quo
  }
  .to_chr_impl(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to_chr
to_character <- to_chr

#' Internal S3 implementation of to_chr
#'
#' @inheritParams .shared-params
#' @returns The object coerced to character.
#' @keywords internal
.to_chr_impl <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod(".to_chr_impl")
}

#' @export
.to_chr_impl.character <- function(x, ...) {
  return(x)
}

#' @export
.to_chr_impl.integer <- function(x, ...) {
  .Call(stbl_int_to_chr, x)[["result"]]
}

#' @export
.to_chr_impl.double <- function(x, ...) {
  .Call(stbl_dbl_to_chr, x)[["result"]]
}

#' @export
.to_chr_impl.logical <- function(x, ...) {
  .Call(stbl_lgl_to_chr, x)[["result"]]
}

#' @export
.to_chr_impl.factor <- function(x, ...) {
  .Call(stbl_fct_to_chr, x)[["result"]]
}

#' @export
.to_chr_impl.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
.to_chr_impl.list <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  res <- .Call(stbl_lst_to_chr, x)
  .check_lst_failures(x, res[["valid"]], character(), x_class, x_arg, call)
  res[["result"]]
}

#' @export
.to_chr_impl.data.frame <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stop_cant_coerce(
    from_class = x_class,
    to_class = "character",
    x_arg = x_arg,
    call = call
  )
}

#' @export
.to_chr_impl.quosure <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  x_expr <- rlang::quo_get_expr(x)
  if (rlang::is_call(x_expr, c("::", ":::"))) {
    return(.chr_from_op_call(x_expr))
  }
  .stop_if_anon_fn(x_expr, x_class = x_class, x_arg = x_arg, call = call)
  .chr_from_fn_sym(x, x_name = rlang::as_string(x_expr))
}

#' Build a string from a `::` or `:::` call expression
#'
#' @param x_expr A `::` or `:::` call expression.
#' @returns A length-1 character string, e.g. `"base::mean"`.
#' @keywords internal
.chr_from_op_call <- function(x_expr) {
  op <- rlang::as_string(x_expr[[1]])
  paste0(rlang::as_string(x_expr[[2]]), op, rlang::as_string(x_expr[[3]]))
}

#' Error if a function expression is anonymous (not a symbol)
#'
#' @param x_expr The expression from the quosure.
#' @inheritParams .shared-params
#' @keywords internal
.stop_if_anon_fn <- function(x_expr, x_class, x_arg, call) {
  if (!rlang::is_symbol(x_expr)) {
    .stop_cant_coerce(
      from_class = x_class,
      to_class = "character",
      x_arg = x_arg,
      call = call,
      additional_msg = c(
        i = "Anonymous functions can't be converted to a string name."
      )
    )
  }
}

#' Return the name of a function
#'
#' @param x A quosure wrapping the function.
#' @param x_name The name used to refer to the function at the call site.
#' @returns A length-1 character string.
#' @keywords internal
.chr_from_fn_sym <- function(x, x_name) {
  fn <- rlang::eval_tidy(x)
  fn_env <- rlang::fn_env(fn)
  if (!rlang::is_namespace(fn_env)) {
    return(x_name)
  }
  .maybe_qualify_fn_name(fn, fn_env, x_name)
}

#' Return a package-qualified name if the name resolves to the same function
#'
#' @param fn The function.
#' @param fn_env The namespace environment of `fn`.
#' @param x_name The name used to refer to `fn` at the call site.
#' @returns `"pkg::x_name"` if `x_name` resolves to `fn` in `fn_env`, otherwise
#'   `x_name`.
#' @keywords internal
.maybe_qualify_fn_name <- function(fn, fn_env, x_name) {
  # Guard against corner-case aliased functions (e.g.,
  # `abs <- mean; to_chr(abs)`).
  if (
    rlang::env_has(fn_env, x_name, inherit = FALSE) &&
      .same_fn(fn, rlang::env_get(fn_env, x_name, inherit = FALSE))
  ) {
    pkg_name <- sub("^namespace:", "", rlang::env_name(fn_env))
    return(paste0(pkg_name, "::", x_name))
  }
  x_name
}

#' Check if two functions have the same definition
#'
#' @param x,y Functions to compare.
#' @returns `TRUE` if the functions are the same, `FALSE` otherwise.
#' @keywords internal
.same_fn <- function(x, y) {
  if (rlang::is_primitive(x) || rlang::is_primitive(y)) {
    return(identical(x, y))
  }
  identical(rlang::fn_body(x), rlang::fn_body(y)) &&
    identical(rlang::fn_fmls(x), rlang::fn_fmls(y))
}

#' @keywords internal
.to_chr_impl.default <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  try_fetch(
    as.character(x),
    error = function(cnd) {
      .stop_cant_coerce(
        from_class = x_class,
        to_class = "character",
        x_arg = x_arg,
        call = call
      )
    }
  )
}

#' Coerce to length-1 character
#'
#' Checks whether a vector can be coerced to a length-1 character vector.
#' `to_character_scalar()` is a synonym of `to_chr_scalar()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a length-1 character vector, or an error condition
#'   with classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`,
#'   `<error>`, `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-character>` when `x` cannot be coerced to character
#'   (for example a `data.frame`, or an anonymous function).
#'   - `<stbl-error-incompatible_values-character>` when some elements of a
#'   list cannot be converted to character.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#' @family character functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_chr_scalar("a")
#' try(to_chr_scalar(letters))
to_chr_scalar <- function(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  x_quo <- rlang::enquo(x)
  if (is.function(x)) {
    force(x_class)
    x <- x_quo
  }
  .to_cls_scalar(
    x,
    is_rlang_cls_scalar = is_scalar_character,
    to_cls_fn = to_chr,
    to_cls_args = list(...),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to_chr_scalar
to_character_scalar <- to_chr_scalar
