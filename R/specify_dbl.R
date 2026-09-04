#' Create a specified double stabilizer function
#'
#' `specify_dbl()` creates a function that will call [stabilize_dbl()] with the
#' provided arguments. `specify_dbl_scalar()` creates a function that will call
#' [stabilize_dbl_scalar()] with the provided arguments. `specify_double()` is a
#' synonym of `specify_dbl()`, and `specify_double_scalar()` is a synonym of
#' `specify_dbl_scalar()`.
#'
#' @inheritParams .shared-params
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_dbl()] or [stabilize_dbl_scalar()] with the provided arguments.
#'   The generated function will also accept `...` for additional arguments to
#'   pass to `stabilize_dbl()` or `stabilize_dbl_scalar()`. You can copy/paste
#'   the body of the resulting function if you want to provide additional
#'   context or functionality.
#' @family double functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_3_to_5 <- specify_dbl(min_value = 3, max_value = 5)
#' stabilize_3_to_5(c(3.3, 4.4, 5))
#' try(stabilize_3_to_5(c(1:6)))
specify_dbl <- function(
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  exclusive_min_value = NULL,
  exclusive_max_value = NULL,
  allowed_values = NULL,
  multiple_of = NULL
) {
  factory_args <- .capture_factory_args()
  .specify_cls("dbl", factory_args)
}

#' @export
#' @rdname specify_dbl
specify_dbl_scalar <- function(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  exclusive_min_value = NULL,
  exclusive_max_value = NULL,
  allowed_values = NULL,
  multiple_of = NULL
) {
  factory_args <- .capture_factory_args()
  .specify_cls("dbl", factory_args, scalar = TRUE)
}

#' @export
#' @rdname specify_dbl
specify_double <- specify_dbl

#' @export
#' @rdname specify_dbl
specify_double_scalar <- specify_dbl_scalar
