#' Shared parameters
#'
#' These parameters are used in multiple functions. They are defined here to
#' make them easier to import and to find.
#'
#' @param ... Arguments passed to methods.
#' @param allow_na `(length-1 logical)` Are NA values ok?
#' @param allow_null `(length-1 logical)` Is NULL an acceptable value?
#' @param allow_zero_length `(length-1 logical)` Are zero-length vectors
#'   acceptable?
#' @param are_cls_ish_fn The `are_*_ish` function to apply to each element.
#' @param call `(environment)` The execution environment to mention as the
#'   source of error messages.
#' @param cast_fn `(function)` The `as.*()` function to use for coercion.
#' @param check_cls_value_fn `(function)` A function to check the values of `x`
#'   after coercion.
#' @param check_cls_value_fn_args `(list)` A list of additional arguments to
#'   pass to `check_cls_value_fn()`.
#' @param coerce_character `(length-1 logical)` Should character vectors such as
#'   "1" and "2.0" be considered numeric-ish?
#' @param coerce_factor `(length-1 logical)` Should factors with values such as
#'   "1" and "2.0" be considered numeric-ish? Note that this package uses the
#'   character value from the factor, while [as.integer()] and [as.double()] use
#'   the integer index of the factor.
#' @param coerce_function `(length-1 logical)` Should functions be coerced?
#' @param depth `(length-1 integer)` Current recursion depth. Do not manually
#'   set this parameter.
#' @param is_rlang_cls_scalar `(function)` An `is_scalar_*()` function from
#'   rlang, used for a fast path if `x` is already the right type.
#' @param levels `(character)` The desired factor levels.
#' @param message_env (`environment`) The execution environment to use to
#'   evaluate variables in error messages.
#' @param min_size `(length-1 integer)` The minimum size of the object. Object
#'   size will be tested using [vctrs::vec_size()].
#' @param min_value `(length-1 numeric)` The lowest allowed value for `x`. If
#'   `NULL` (default) values are not checked.
#' @param max_size `(length-1 integer)` The maximum size of the object. Object
#'   size will be tested using [vctrs::vec_size()].
#' @param max_value `(length-1 numeric)` The highest allowed value for `x`. If
#'   `NULL` (default) values are not checked.
#' @param package `(length-1 character)` The name of the package to use in
#'   classes.
#' @param parent A parent condition, as you might create during a
#'   [rlang::try_fetch()]. See [rlang::abort()] for additional information.
#' @param regex `(character, list, or stringr_pattern)` One or more optional
#'   regular expressions to test against the values of `x`. This can be a
#'   character vector, a list of character vectors, or a pattern object from the
#'   \{stringr\} package (e.g., `stringr::fixed("a.b")`). The default error
#'   message for non-matching values will include the pattern itself (see
#'   [regex_must_match()]). To provide a custom message, supply a named
#'   character vector where the value is the regex pattern and the name is the
#'   message that should be displayed. To check that a pattern is *not* matched,
#'   attach a `negate` attribute set to `TRUE`. If a complex regex pattern
#'   throws an error, try installing the stringi package.
#' @param to_class `(length-1 character)` The name of the class to coerce to.
#' @param to_cls_args `(list)` A list of additional arguments to pass to
#'   `to_cls_fn()`.
#' @param to_cls_fn `(function)` The `to_*()` function to use for coercion.
#' @param to_cls_scalar_args `(list)` A list of additional arguments to pass to
#'   `to_cls_scalar_fn()`.
#' @param to_cls_scalar_fn `(function)` The `to_*_scalar()` function to use for
#'   coercion.
#' @param to_na `(character)` Values to convert to `NA`.
#' @param to_type_obj An empty object of the target type (e.g., `integer()`).
#' @param x The argument to stabilize.
#' @param x_arg `(length-1 character)` An argument name for x. The automatic
#'   value will work in most cases, or pass it through from higher-level
#'   functions to make error messages clearer in unexported functions.
#' @param x_class `(length-1 character)` The class name of `x` to use in error
#'   messages. Use this if you remove a special class from `x` before checking
#'   its coercion, but want the error message to match the original class.
#'
#' @name .shared-params
#' @keywords internal
NULL

#' Shared parameters for check functions
#'
#' @param x The object to check.
#'
#' @name .shared-params-check
#' @keywords internal
NULL
