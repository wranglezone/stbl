#' Create a names stabilizer function
#'
#' `specify_names()` creates a function that calls [stabilize_names()] with
#' pre-configured arguments, so the same name checks can be reused.
#'
#' @inheritParams stabilize_names
#'
#' @returns A function that takes `x` (plus `x_arg` and `call`) and returns `x`
#'   with stabilized names, or throws the errors described in
#'   [stabilize_names()].
#' @family names functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_snake_names <- specify_names(
#'   spec = specify_chr(regex = "^[a-z_]+$"),
#'   required = "id"
#' )
#' stabilize_snake_names(c(id = 1, value_a = 2))
#' try(stabilize_snake_names(c(id = 1, ValueA = 2)))
specify_names <- function(
  allowed_names = NULL,
  spec = NULL,
  required = NULL,
  allow_duplicate_names = FALSE
) {
  structure(
    function(x, x_arg = caller_arg(x), call = caller_env()) {
      stabilize_names(
        x,
        allowed_names = allowed_names,
        spec = spec,
        required = required,
        allow_duplicate_names = allow_duplicate_names,
        x_arg = x_arg,
        call = call
      )
    },
    class = c("stbl_specified_fn", "function")
  )
}
