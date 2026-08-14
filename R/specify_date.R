#' Create a specified date stabilizer function
#'
#' `specify_date()` creates a function that will call [stabilize_date()] with
#' the provided arguments. `specify_date_scalar()` creates a function that will
#' call [stabilize_date_scalar()] with the provided arguments.
#'
#' @inheritParams .shared-params
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_date()] or [stabilize_date_scalar()] with the provided
#'   arguments. The generated function will also accept `...` for additional
#'   arguments to pass to `stabilize_date()` or `stabilize_date_scalar()`. You
#'   can copy/paste the body of the resulting function if you want to provide
#'   additional context or functionality.
#' @family date functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_recent <- specify_date(min_value = "2000-01-01")
#' stabilize_recent("2024-01-01")
#' try(stabilize_recent("1999-12-31"))
specify_date <- function(
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
  .specify_cls("date", factory_args)
}

#' @export
#' @rdname specify_date
specify_date_scalar <- function(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
) {
  factory_args <- .capture_factory_args()
  .specify_cls("date", factory_args, scalar = TRUE)
}
