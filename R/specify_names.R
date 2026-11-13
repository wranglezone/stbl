#' Create a names stabilizer function
#'
#' `specify_names()` creates a function that calls [stabilize_names()] with
#' pre-configured arguments, so the same name checks can be reused.
#'
#' @inheritParams stabilize_names
#'
#' @returns A function that takes `x` (plus `...`, `x_arg`, and `call`) and
#'   returns `x` with stabilized names, or throws the errors described in
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
  ...,
  allowed_names = NULL,
  spec = NULL,
  required = NULL,
  allow_duplicate_names = FALSE
) {
  check_dots_empty0(...)
  factory_args <- .capture_factory_args()
  .specify_cls("names", factory_args, include_x_class = FALSE)
}
