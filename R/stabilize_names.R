#' Ensure the names of an object meet expectations
#'
#' Validate and optionally convert only the *names* of an object. The class and
#' values of `x` are left alone, so this is useful for objects (such as S3
#' classes or factors) that you don't want to convert or check.
#' `stabilise_names()` is a synonym of `stabilize_names()`.
#'
#' @param allowed_names `(character)` The permitted names. If supplied, `x` must
#'   be named (every element must have a non-empty name), and every name must be
#'   in this set. `NULL` (default), `NA`, or `character(0)` skip the check.
#' @param spec `(function)` A single stabilizer or conversion function, such as
#'   a `to_*` function ([to_chr()], etc.), a `stabilize_*` function
#'   ([stabilize_chr()], etc.), or a function produced by a `specify_*()` call
#'   ([specify_chr()], etc.). If supplied, `x` must be named (every element must
#'   have a non-empty name), and `spec` is applied to `names(x)`. The result
#'   becomes the names of the returned object. `NULL` (default) skips the check.
#' @param required `(character)` Names that must be present in `x` (after
#'   applying `spec`, if any). `NULL` (default) or `character()` skip the check.
#' @inheritParams .shared-params
#'
#' @returns `x` with stabilized names, or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-bad_named>` when `allowed_names` or `spec` is supplied and
#'   `x` is not fully named.
#'   - `<stbl-error-allowed_names>` when a name is not in `allowed_names`.
#'   - `<stbl-error-duplicate_names>` when duplicate names are present and
#'   `allow_duplicate_names = FALSE`.
#'   - `<stbl-error-missing_element>` when a name in `required` is absent.
#'   - Errors from `spec` when a name does not satisfy it.
#' @family names functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' # Names are checked, but the class and values are untouched
#' stabilize_names(c(a = 1, b = 2))
#'
#' # Duplicate names are rejected by default
#' try(stabilize_names(c(a = 1, a = 2)))
#' stabilize_names(c(a = 1, a = 2), allow_duplicate_names = TRUE)
#'
#' # Require specific names
#' try(stabilize_names(c(a = 1, b = 2), required = c("a", "c")))
#'
#' # Restrict names to an allowed set
#' try(stabilize_names(c(a = 1, z = 2), allowed_names = c("a", "b")))
#'
#' # Convert or validate the names with a spec
#' stabilize_names(c(a = 1, b = 2), spec = toupper)
#' try(stabilize_names(c(a = 1, B = 2), spec = specify_chr(regex = "^[a-z]$")))
stabilize_names <- function(
  x,
  ...,
  allowed_names = NULL,
  spec = NULL,
  required = NULL,
  allow_duplicate_names = FALSE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  force(x_arg)
  force(call)
  check_dots_empty0(..., call = call)
  .check_named(x, named = allowed_names, x_arg = x_arg, call = call)
  if (!is.null(spec)) {
    x <- .stabilize_names_spec(x, spec, x_arg = x_arg, call = call)
  }
  .check_duplicate_names(
    x,
    allow_duplicate_names,
    .x_arg = x_arg,
    .call = call
  )
  .check_required_names(x, required, x_arg = x_arg, call = call)
  x
}

#' @export
#' @rdname stabilize_names
stabilise_names <- stabilize_names
