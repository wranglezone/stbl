#' Ensure a data frame argument meets expectations
#'
#' `to_df()` checks whether an argument can be coerced to a data frame,
#' returning it silently if so. Otherwise an informative error message is
#' signaled. `to_data_frame()` is a synonym of `to_df()`.
#'
#' @param ... Arguments passed to methods.
#' @inheritParams .shared-params
#'
#' @returns The argument as a data frame.
#' @family data frame functions
#' @export
#'
#' @examples
#' to_df(mtcars)
#' to_df(list(name = "Alice", age = 30L))
#' to_df(NULL)
#' try(to_df(NULL, allow_null = FALSE))
#' try(to_df("not a data frame"))
to_df <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to_df")
}

#' @export
#' @rdname to_df
to_data_frame <- to_df

#' @export
to_df.data.frame <- function(x, ...) {
  x
}

#' @export
#' @rdname to_df
to_df.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
to_df.list <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  try_fetch(
    as.data.frame(x),
    error = function(cnd) {
      .stop_cant_coerce(
        from_class = x_class,
        to_class = "data.frame",
        x_arg = x_arg,
        call = call
      )
    }
  )
}

#' @export
to_df.default <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stop_cant_coerce(
    from_class = x_class,
    to_class = "data.frame",
    x_arg = x_arg,
    call = call
  )
}
