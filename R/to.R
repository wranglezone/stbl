#' Convert a value to a target type
#'
#' `to()` coerces `x` to the type of `.to`, dispatching on the class of `.to`
#' to the appropriate `to_*()` function.
#'
#' @param .to A prototype that determines the target type (e.g., `integer()`,
#'   `factor(levels = c("a", "b"))`).
#' @param ... Arguments passed to methods and on to `to_*()` functions.
#' @inheritParams .shared-params
#'
#' @returns `x` coerced to the type of `.to`, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - The failure classes documented for the `to_*()` function corresponding
#'   to the class of `.to` (for example [to_int()] for `.to = integer()`).
#'   - `<stbl-error-coerce-*>` when the class of `.to` has no corresponding
#'   `to_*()` function and [vctrs::vec_cast()] cannot cast `x` to `.to`.
#'
#' @details
#' When the class of `.to` does not have a corresponding `to_*()` function,
#' `to()` falls back to [vctrs::vec_cast()]. Arguments in `...` are passed to
#' `to_*()` functions but are ignored by the [vctrs::vec_cast()] fallback.
#'
#' @family character functions
#' @family double functions
#' @family integer functions
#' @family logical functions
#' @family factor functions
#' @family function functions
#' @family list functions
#' @family data frame functions
#' @family date functions
#' @family datetime functions
#' @family time functions
#' @family duration functions
#' @export
#'
#' @examples
#' to(1L, double())
#' to(1.0, integer())
#' to(TRUE, character())
#' to("1", integer())
#' to(c("a", "b"), factor(levels = c("a", "b", "c")))
#' to("mean", mean)
#' to("2024-01-01", as.Date("2024-01-01"))
#' to("2024-01-01T12:00:00Z", as.POSIXct("2024-01-01", tz = "UTC"))
to <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to", .to)
}

#' @export
#' @rdname to
to.character <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_chr(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.double <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_dbl(
    x,
    ...,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to
to.Date <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_date(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.data.frame <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  # Subclasses of data.frame (e.g. tibble) are not stbl targets; let vctrs
  # handle them.
  if (!identical(class(.to), "data.frame")) {
    return(to.default(
      x,
      .to,
      x_arg = x_arg,
      call = call,
      x_class = x_class
    ))
  }
  to_df(x, ..., x_arg = x_arg, call = call)
}

#' @export
#' @rdname to
to.factor <- function(
  x,
  .to,
  ...,
  levels = NULL,
  ordered = is.ordered(x) || is.ordered(.to),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  levels <- levels %||% levels(.to)
  to_fct(
    x,
    ...,
    levels = levels,
    ordered = ordered,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to
to.function <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_fn(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.integer <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_int(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.logical <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_lgl(
    x,
    ...,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to
to.list <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  # Subclasses of list (e.g. vctrs_list_of) are not stbl targets; let vctrs
  # handle them.
  if (!identical(class(.to), "list")) {
    return(to.default(
      x,
      .to,
      x_arg = x_arg,
      call = call,
      x_class = x_class
    ))
  }
  # Language objects (calls, symbols) are data, not lists to splice.
  if (is.language(x)) {
    return(list(x))
  }
  to_lst(x, ..., x_arg = x_arg, call = call)
}

#' @export
#' @rdname to
to.matrix <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  # Matrices and arrays are not stbl targets; let vctrs handle them.
  to.default(x, .to, x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.array <- to.matrix

#' @export
#' @rdname to
to.NULL <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_null(x, ..., x_arg = x_arg, call = call)
}

#' @export
#' @rdname to
to.hms <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_time(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.Period <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_dur(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.POSIXct <- function(
  x,
  .to,
  ...,
  tz = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  # The tzone attribute can be a 3-element vector (zone plus standard and
  # daylight abbreviations); only the zone name is relevant here.
  tz <- tz %||% attr(.to, "tzone")[1] %||% "UTC"
  if (is.na(tz) || !nzchar(tz)) {
    tz <- "UTC"
  }
  to_dttm(x, ..., tz = tz, x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.default <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  rlang::try_fetch(
    vctrs::vec_cast(x, .to),
    error = function(cnd) {
      .stop_cant_coerce(
        from_class = x_class,
        to_class = object_type(.to),
        x_arg = x_arg,
        call = call
      )
    }
  )
}
