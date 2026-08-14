#' Create a specified integer stabilizer function
#'
#' `specify_int()` creates a function that will call [stabilize_int()] with the
#' provided arguments. `specify_int_scalar()` creates a function that will call
#' [stabilize_int_scalar()] with the provided arguments. `specify_integer()` is
#' a synonym of `specify_int()`, and `specify_integer_scalar()` is a synonym of
#' `specify_int_scalar()`.
#'
#' @inheritParams .shared-params
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_int()] or [stabilize_int_scalar()] with the provided arguments.
#'   The generated function will also accept `...` for additional arguments to
#'   pass to `stabilize_int()` or `stabilize_int_scalar()`. You can copy/paste
#'   the body of the resulting function if you want to provide additional
#'   context or functionality.
#' @family integer functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_3_to_5 <- specify_int(min_value = 3, max_value = 5)
#' stabilize_3_to_5(c(3:5))
#' try(stabilize_3_to_5(c(1:6)))
specify_int <- function(
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
) {
  factory_args <- .capture_factory_args()
  .specify_cls("int", factory_args)
}

#' @export
#' @rdname specify_int
specify_int_scalar <- function(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
) {
  factory_args <- .capture_factory_args()
  .specify_cls("int", factory_args, scalar = TRUE)
}

#' @export
#' @rdname specify_int
specify_integer <- specify_int

#' @export
#' @rdname specify_int
specify_integer_scalar <- specify_int_scalar
