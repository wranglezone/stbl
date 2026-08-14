#' Create a specified datetime stabilizer function
#'
#' `specify_dttm()` creates a function that will call [stabilize_dttm()] with
#' the provided arguments. `specify_dttm_scalar()` creates a function that will
#' call [stabilize_dttm_scalar()] with the provided arguments.
#' `specify_datetime()` is a synonym of `specify_dttm()`, and
#' `specify_datetime_scalar()` is a synonym of `specify_dttm_scalar()`.
#'
#' @inheritParams .shared-params
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_dttm()] or [stabilize_dttm_scalar()] with the provided
#'   arguments. The generated function will also accept `...` for additional
#'   arguments to pass to `stabilize_dttm()` or `stabilize_dttm_scalar()`. You
#'   can copy/paste the body of the resulting function if you want to provide
#'   additional context or functionality.
#' @family datetime functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_recent <- specify_dttm(min_value = "2000-01-01T00:00:00Z")
#' stabilize_recent("2024-01-01T00:00:00Z")
#' try(stabilize_recent("1999-12-31T00:00:00Z"))
specify_dttm <- function(
  tz = "UTC",
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
  .specify_cls("dttm", factory_args)
}

#' @export
#' @rdname specify_dttm
specify_dttm_scalar <- function(
  tz = "UTC",
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
) {
  factory_args <- .capture_factory_args()
  .specify_cls("datetime", factory_args, scalar = TRUE)
}

#' @export
#' @rdname specify_dttm
specify_datetime <- specify_dttm

#' @export
#' @rdname specify_dttm
specify_datetime_scalar <- specify_dttm_scalar
