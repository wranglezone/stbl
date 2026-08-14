#' Create a specified time-of-day stabilizer function
#'
#' `specify_time()` creates a function that will call [stabilize_time()] with
#' the provided arguments. `specify_time_scalar()` creates a function that will
#' call [stabilize_time_scalar()] with the provided arguments.
#'
#' @inheritParams .shared-params
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_time()] or [stabilize_time_scalar()] with the provided
#'   arguments. The generated function will also accept `...` for additional
#'   arguments to pass to `stabilize_time()` or `stabilize_time_scalar()`. You
#'   can copy/paste the body of the resulting function if you want to provide
#'   additional context or functionality.
#' @family time functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_afternoon <- specify_time(min_value = "12:00:00Z")
#' stabilize_afternoon("13:00:00Z")
#' try(stabilize_afternoon("06:00:00Z"))
specify_time <- function(
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
  .specify_cls("time", factory_args)
}

#' @export
#' @rdname specify_time
specify_time_scalar <- function(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
) {
  factory_args <- .capture_factory_args()
  .specify_cls("time", factory_args, scalar = TRUE)
}
