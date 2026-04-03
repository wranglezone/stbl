#' Check for NA values
#'
#' Checks for `NA` values in `x`, throwing an error if any are found and
#' `allow_na` is `FALSE`.
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#'
#' @returns `NULL`, invisibly, if `x` passes the check.
#' @keywords internal
.check_na <- function(
  x,
  allow_na = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  allow_na <- to_lgl_scalar(allow_na, call = call)
  if (allow_na) {
    return(invisible(NULL))
  }

  failures <- is.na(x)
  if (any(failures)) {
    locations <- which(failures)
    .stop_must(
      msg = "must not contain NA values.",
      x_arg = x_arg,
      additional_msg = c("*" = "NA locations: {locations}"),
      call = call,
      subclass = "bad_na",
      message_env = rlang::current_env()
    )
  }
  return(invisible(NULL))
}

#' Check the size of an object
#'
#' Checks if the size of `x` (from [vctrs::vec_size()]) is within the bounds of
#' `min_size` and `max_size`.
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#'
#' @returns `NULL`, invisibly, if `x` passes the check.
#' @keywords internal
.check_size <- function(
  x,
  min_size,
  max_size,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  if (is.null(min_size) && is.null(max_size)) {
    return(invisible(NULL))
  }

  min_size <- to_int_scalar(min_size, allow_null = TRUE, call = call)
  max_size <- to_int_scalar(max_size, allow_null = TRUE, call = call)
  .check_x_no_more_than_y(min_size, max_size, call = call)

  x_size <- vec_size(x)

  min_ok <- is.null(min_size) || x_size >= min_size
  max_ok <- is.null(max_size) || x_size <= max_size

  if (min_ok && max_ok) {
    return(invisible(NULL))
  }

  if (max_ok) {
    .stop_must(
      msg = "must have size >= {min_size}.",
      x_arg = x_arg,
      additional_msg = c(x = "{x_size} is too small."),
      call = call,
      subclass = "size_too_small",
      message_env = rlang::current_env()
    )
  }

  .stop_must(
    msg = "must have size <= {max_size}.",
    x_arg = x_arg,
    additional_msg = c(x = "{x_size} is too big."),
    call = call,
    subclass = "size_too_large",
    message_env = rlang::current_env()
  )
}

#' Check if an object is a scalar
#'
#' Checks if an object is a scalar, allowing for `NULL` and zero-length vectors
#' if specified.
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#'
#' @returns `NULL`, invisibly, if `x` passes the check.
#' @keywords internal
.check_scalar <- function(
  x,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  subclass <- "non_scalar"
  if (!length(x)) {
    if (is.null(x)) {
      if (.is_allowed_null(x, allow_null = allow_null, call = call)) {
        return(invisible(NULL))
      }
    } else {
      allow_zero_length <- to_lgl_scalar(
        allow_zero_length,
        call = call
      )
      if (allow_zero_length) {
        return(invisible(NULL)) # nocov (may not be possible to get here)
      }
      x_class <- paste(x_class, "(non-empty)")
      subclass <- "bad_empty"
    }
  }

  if (is_scalar_vector(x)) {
    return(invisible(NULL))
  }

  x_size <- vec_size(x)

  if (x_class == "NULL") {
    x_class <- "non-NULL"
  }
  .stop_must(
    "must be a single {.cls {x_class}}.",
    x_arg = x_arg,
    call = call,
    additional_msg = c(x = "{.arg {x_arg}} has {no(x_size)} values."),
    subclass = subclass,
    message_env = rlang::current_env()
  )
}

#' Check if a value is NULL and NULLs are allowed
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#'
#' @returns `(length-1 logical)` `TRUE` if `x` is `NULL` and `allow_null` is
#'   `TRUE`.
#' @keywords internal
.is_allowed_null <- function(x, allow_null = TRUE, call = caller_env()) {
  allow_null <- to_lgl_scalar(allow_null, call = call)
  return(is.null(x) && allow_null)
}

#' Check that one value is not greater than another
#'
#' @param y The value to compare against.
#' @param y_arg `(length-1 character)` The name of the `y` argument.
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#'
#' @returns `NULL`, invisibly, if `x` is not greater than `y`.
#' @keywords internal
.check_x_no_more_than_y <- function(
  x,
  y,
  x_arg = caller_arg(x),
  y_arg = caller_arg(y),
  call = caller_env()
) {
  if (!is.null(x) && !is.null(y) && x > y) {
    .stbl_abort(
      message = c(
        "{.arg {x_arg}} can't be larger than {.arg {y_arg}}.",
        "*" = "{.arg {x_arg}} = {x}",
        "*" = "{.arg {y_arg}} = {y}"
      ),
      call = call,
      subclass = "size_x_vs_y",
      message_env = rlang::current_env()
    )
  }
}

#' Check for coercion failures and stop if any are found
#'
#' @param failures `(logical)` A logical vector where `TRUE` indicates a
#'   coercion failure.
#' @inheritParams .stop_incompatible
#' @keywords internal
.check_cast_failures <- function(failures, x_class, to, due_to, x_arg, call) {
  if (any(failures)) {
    .stop_incompatible(
      x_class = x_class,
      to = to,
      failures = failures,
      due_to = due_to,
      x_arg = x_arg,
      call = call
    )
  }
}

#' Check that all list elements are named
#'
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if all elements have names.
#' @keywords internal
.check_all_named <- function(x, x_arg = caller_arg(x), call = caller_env()) {
  if (rlang::is_named(x)) {
    return(invisible(NULL))
  }
  .stop_must(
    "must have all elements named.",
    x_arg = x_arg,
    call = call,
    subclass = "bad_named"
  )
}

#' Check that list elements do not have jagged (unequal non-1) lengths
#'
#' Expected to be called after `.check_all_named()`, so `names(x)` is
#' guaranteed to be non-`NULL`. Length-1 elements are excluded from the check
#' because they recycle to any length in `as.data.frame()`.
#'
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if the list is not jagged.
#' @keywords internal
.check_not_jagged <- function(
  x,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  if (!length(x)) {
    return(invisible(NULL))
  }
  lens <- lengths(x)
  non_one <- lens[lens != 1L]
  if (length(unique(non_one)) <= 1L) {
    return(invisible(NULL))
  }
  max_len <- max(non_one)
  short_mask <- lens < max_len & lens > 1L
  short_nms <- names(x)[short_mask]
  short_lens <- lens[short_mask]
  short_pairs <- paste(paste0(short_nms, " = ", short_lens), collapse = ", ")
  main_msg <- .glue2(
    "Can't coerce {.arg [x_arg]} {.cls [x_class]} to {.cls data.frame}."
  )
  .stbl_abort(
    message = c(
      main_msg,
      i = "All list elements must have length {max_len} or 1.",
      x = "Short elements: {short_pairs}."
    ),
    subclass = "jagged",
    call = call,
    message_env = rlang::current_env()
  )
}
