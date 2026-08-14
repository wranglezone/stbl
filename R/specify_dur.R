#' Create a specified duration stabilizer function
#'
#' `specify_dur()` creates a function that will call [stabilize_dur()] with the
#' provided arguments. `specify_dur_scalar()` creates a function that will call
#' [stabilize_dur_scalar()] with the provided arguments. `specify_duration()` is
#' a synonym of `specify_dur()`, and `specify_duration_scalar()` is a synonym of
#' `specify_dur_scalar()`.
#'
#' @inheritParams .shared-params
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_dur()] or [stabilize_dur_scalar()] with the provided arguments.
#'   The generated function will also accept `...` for additional arguments to
#'   pass to `stabilize_dur()` or `stabilize_dur_scalar()`. You can copy/paste
#'   the body of the resulting function if you want to provide additional
#'   context or functionality.
#' @family duration functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_short <- specify_dur(max_value = "P1D")
#' stabilize_short("PT12H")
#' try(stabilize_short("P2D"))
specify_dur <- function(
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
) {
  factory_args <- .capture_factory_args()
  .specify_cls("dur", factory_args)
}

#' @export
#' @rdname specify_dur
specify_dur_scalar <- function(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
) {
  factory_args <- .capture_factory_args()
  .specify_cls("dur", factory_args, scalar = TRUE)
}

#' @export
#' @rdname specify_dur
specify_duration <- specify_dur

#' @export
#' @rdname specify_dur
specify_duration_scalar <- specify_dur_scalar
