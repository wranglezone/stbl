#' Create a specified factor stabilizer function
#'
#' `specify_fct()` creates a function that will call [stabilize_fct()] with the
#' provided arguments. `specify_fct_scalar()` creates a function that will call
#' [stabilize_fct_scalar()] with the provided arguments. `specify_factor()` is a
#' synonym of `specify_fct()`, and `specify_factor_scalar()` is a synonym of
#' `specify_fct_scalar()`.
#'
#' @inheritParams stabilize_fct
#' @inheritParams .shared-params
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_fct()] or [stabilize_fct_scalar()] with the provided arguments.
#'   The generated function will also accept `...` for additional arguments to
#'   pass to `stabilize_fct()` or `stabilize_fct_scalar()`. You can copy/paste
#'   the body of the resulting function if you want to provide additional
#'   context or functionality.
#' @family factor functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_lowercase_letter <- specify_fct(levels = letters)
#' stabilize_lowercase_letter(c("s", "t", "b", "l"))
#' try(stabilize_lowercase_letter("A"))
specify_fct <- function(
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  levels = NULL,
  to_na = character()
) {
  factory_args <- .capture_factory_args()
  .specify_cls("fct", factory_args)
}

#' @export
#' @rdname specify_fct
specify_fct_scalar <- function(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  levels = NULL,
  to_na = character()
) {
  factory_args <- .capture_factory_args()
  .specify_cls("fct", factory_args, scalar = TRUE)
}

#' @export
#' @rdname specify_fct
specify_factor <- specify_fct

#' @export
#' @rdname specify_fct
specify_factor_scalar <- specify_fct_scalar
