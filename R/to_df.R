#' Ensure a data frame argument meets expectations
#'
#' `to_df()` checks whether an argument can be coerced to a data frame,
#' returning it silently if so. Otherwise an informative error message is
#' signaled. `to_data_frame()` is a synonym of `to_df()`.
#'
#' @param ... Arguments passed to [base::as.data.frame()] or other methods.
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
#' try(to_df(c("a", "b", "c")))
#' to_df(letters)
to_df <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x),
  x_expr = substitute(x)
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
  if (length(x) > 0L) {
    lens <- lengths(x)
    non_one <- lens[lens != 1L]
    if (length(unique(non_one)) > 1L) {
      nms <- names(x)
      if (is.null(nms)) {
        nms <- paste0("[[", seq_along(x), "]]")
      }
      elem_pairs <- paste(
        paste0(nms[lens != 1L], " = ", non_one),
        collapse = ", "
      )
      .stop_cant_coerce(
        from_class = x_class,
        to_class = "data.frame",
        x_arg = x_arg,
        call = call,
        additional_msg = c(
          i = "All list elements must have equal length (or length 1).",
          x = "Element lengths: {elem_pairs}."
        ),
        message_env = rlang::current_env()
      )
    }
  }

  as.data.frame(x, ...)
}

#' @export
to_df.default <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x),
  x_expr = substitute(x)
) {
  .stop_cant_coerce(
    from_class = x_class,
    to_class = "data.frame",
    x_arg = x_arg,
    call = call
  )
}

#' Coerce a vector to a one-column data frame
#'
#' Called by `to_df.*` methods for atomic vector types. Succeeds only when `x`
#' was supplied as a named symbol (variable), not as an inline expression. This
#' prevents data frames with syntactically ugly column names.
#'
#' @param x_expr `(language)` The unevaluated expression for `x`, captured via
#'   `substitute(x)` in the calling method.
#' @inheritParams .shared-params
#'
#' @returns A one-column data frame.
#' @keywords internal
.to_df_vector <- function(x, x_expr, x_arg, call, x_class, ...) {
  if (!is.symbol(x_expr)) {
    .stop_cant_coerce(
      from_class = x_class,
      to_class = "data.frame",
      x_arg = x_arg,
      call = call
    )
  }

  as.data.frame(x, ..., nm = deparse(x_expr))
}

#' @export
to_df.character <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x),
  x_expr = substitute(x)
) {
  .to_df_vector(
    x,
    x_expr = x_expr,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
to_df.integer <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x),
  x_expr = substitute(x)
) {
  .to_df_vector(
    x,
    x_expr = x_expr,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
to_df.numeric <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x),
  x_expr = substitute(x)
) {
  .to_df_vector(
    x,
    x_expr = x_expr,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
to_df.logical <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x),
  x_expr = substitute(x)
) {
  .to_df_vector(
    x,
    x_expr = x_expr,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
to_df.complex <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x),
  x_expr = substitute(x)
) {
  .to_df_vector(
    x,
    x_expr = x_expr,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
to_df.raw <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x),
  x_expr = substitute(x)
) {
  .to_df_vector(
    x,
    x_expr = x_expr,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
to_df.factor <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x),
  x_expr = substitute(x)
) {
  .to_df_vector(
    x,
    x_expr = x_expr,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}
