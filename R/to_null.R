#' Ensure an argument is NULL
#'
#' If `allow_null` is `TRUE`, coerce `x` to `NULL`. Otherwise throw an
#' informative error.
#'
#' @inheritParams .shared-params
#' @returns `NULL` or an error.
#' @keywords internal
.to_null <- function(
  x,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  if (missing(x)) {
    .stop_must("must not be missing.", x_arg = "unknown arg", call = call)
  }
  allow_null <- to_lgl_scalar(allow_null, call = call)
  if (allow_null) {
    return(NULL)
  }
  .stop_null(x_arg, call)
}
