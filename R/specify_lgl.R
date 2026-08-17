#' Create a specified logical stabilizer function
#'
#' `specify_lgl()` creates a function that will call [stabilize_lgl()] with the
#' provided arguments. `specify_lgl_scalar()` creates a function that will call
#' [stabilize_lgl_scalar()] with the provided arguments. `specify_logical()` is
#' a synonym of `specify_lgl()`, and `specify_logical_scalar()` is a synonym of
#' `specify_lgl_scalar()`.
#'
#' @inheritParams .shared-params
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_lgl()] or [stabilize_lgl_scalar()] with the provided arguments.
#'   The generated function will also accept `...` for additional arguments to
#'   pass to `stabilize_lgl()` or `stabilize_lgl_scalar()`. You can copy/paste
#'   the body of the resulting function if you want to provide additional
#'   context or functionality.
#' @family logical functions
#' @family specification functions
#' @export
#' @examples
#' stabilize_few_lgl <- specify_lgl(max_size = 5)
#' stabilize_few_lgl(c(TRUE, "False", TRUE))
#' try(stabilize_few_lgl(rep(TRUE, 10)))
specify_lgl <- function(
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  allowed_values = NULL
) {
  factory_args <- .capture_factory_args()
  .specify_cls("lgl", factory_args)
}

#' @export
#' @rdname specify_lgl
specify_lgl_scalar <- function(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  allowed_values = NULL
) {
  factory_args <- .capture_factory_args()
  .specify_cls("lgl", factory_args, scalar = TRUE)
}

#' @export
#' @rdname specify_lgl
specify_logical <- specify_lgl

#' @export
#' @rdname specify_lgl
specify_logical_scalar <- specify_lgl_scalar
