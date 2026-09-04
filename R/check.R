#' Check for NA values
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
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
      message_env = rlang::current_env(),
      locations = locations
    )
  }
  return(invisible(NULL))
}

#' Check the size of an object
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
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

  x_size <- vctrs::vec_size(x)

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

#' Check that all elements are unique
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @keywords internal
.check_unique <- function(
  x,
  unique = FALSE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  unique <- to_lgl_scalar(unique, call = call)
  if (!unique || !length(x)) {
    return(invisible(NULL))
  }

  # base::duplicated() silently mishandles some S4 vector classes (e.g.
  # lubridate's Period): is.atomic() reports TRUE for them, which sends
  # duplicated() down a primitive fast path that only looks at the object's
  # `.Data` slot, ignoring its other slots. vec_duplicate_id() compares full
  # vctrs identity instead, so this gives the same result as duplicated()
  # (only later occurrences are flagged) but works for every vector type. In
  # contrast, vctrs::vec_duplicate_detect() reports all duplicated values, not
  # just the second and subsequent repetitions.
  locations <- which(vctrs::vec_duplicate_id(x) != seq_along(x))
  if (!length(locations)) {
    return(invisible(NULL))
  }

  # Convert to character so cli treats the substitution's *length* (not its
  # numeric value) as the pluralization quantity; a numeric substitution used
  # for pluralization must have length 1.
  location_chrs <- as.character(locations)
  additional_msg <- c(
    x = "Duplicate location{?s}: {location_chrs}"
  )
  if (is.atomic(x)) {
    duplicate_value_chrs <- as.character(x[locations])
    additional_msg <- c(
      additional_msg,
      x = "Duplicate value{?s}: {duplicate_value_chrs}"
    )
  }
  .stop_must(
    "must contain unique elements.",
    x_arg = x_arg,
    additional_msg = additional_msg,
    call = call,
    subclass = "duplicate_elements",
    message_env = rlang::current_env(),
    locations = locations
  )
}

#' Check if an object is a scalar
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
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

  x_size <- vctrs::vec_size(x)

  if (identical(x_class, "NULL")) {
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
#' @returns (`logical(1)`) `TRUE` if `x` is `NULL` and `allow_null` is
#'   `TRUE`, else `FALSE`.
#' @keywords internal
.is_allowed_null <- function(x, allow_null = TRUE, call = caller_env()) {
  allow_null <- to_lgl_scalar(allow_null, call = call)
  return(is.null(x) && allow_null)
}

#' Check that one value is not greater than another
#'
#' @param y The value to compare against.
#' @param y_arg (`character(1)`) The name of the `y` value to use in error
#'   messages.
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
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
#' @inherit .shared-return-conditions return
#' @keywords internal
.check_cast_failures <- function(
  x,
  failures,
  x_class,
  to,
  due_to,
  x_arg,
  call
) {
  if (any(failures)) {
    .stop_incompatible(
      x = x,
      x_class = x_class,
      to = to,
      failures = failures,
      due_to = due_to,
      x_arg = x_arg,
      call = call
    )
  }
}

#' Check that all elements are members of an allowed set of values
#'
#' @param allowed_values A vector of permitted values, already coerced to the
#'   same type as `x`. `NULL` or zero-length skips the check.
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @keywords internal
.check_allowed_values <- function(
  x,
  allowed_values,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  if (is.null(allowed_values) || !length(allowed_values)) {
    return(invisible(NULL))
  }

  failures <- !is.na(x) & !(x %in% allowed_values)
  if (!any(failures)) {
    return(invisible(NULL))
  }

  locations <- which(failures)
  location_chrs <- as.character(locations)
  # Some S4 vector classes (e.g. lubridate's Period) report is.atomic() ==
  # TRUE, which sends base::unique() down a primitive fast path that ignores
  # their attributes and silently returns the wrong result; vec_unique()
  # compares full vctrs identity instead, so this works for every type.
  bad_value_chrs <- as.character(vctrs::vec_unique(x[failures]))
  allowed_value_chrs <- as.character(allowed_values)
  .stop_must(
    "must be one of the allowed values.",
    x_arg = x_arg,
    additional_msg = c(
      "i" = "Allowed value{?s}: {.val {allowed_value_chrs}}.",
      "x" = "Unexpected location{?s}: {location_chrs}",
      "x" = "Unexpected value{?s}: {.val {bad_value_chrs}}."
    ),
    call = call,
    subclass = "allowed_values",
    message_env = rlang::current_env(),
    locations = locations
  )
}

#' Check that all elements are integer multiples of a value
#'
#' Doubles are compared with a small relative tolerance
#' (`sqrt(.Machine$double.eps)`, the same default used by
#' [base::all.equal()]) so that representable rounding error (e.g.
#' `0.3 / 0.1`) doesn't produce spurious failures.
#'
#' @param multiple_of (`numeric(1)`) The value `x` must be a multiple of,
#'   already coerced to double. `NULL` skips the check.
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @keywords internal
.check_multiple_of <- function(
  x,
  multiple_of,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  if (is.null(multiple_of)) {
    return(invisible(NULL))
  }
  if (multiple_of <= 0) {
    .stbl_abort(
      message = c(
        "{.arg multiple_of} must be positive.",
        "x" = "{.arg multiple_of} = {multiple_of}."
      ),
      subclass = "bad_multiple_of",
      call = call,
      message_env = rlang::current_env()
    )
  }

  ratio <- x / multiple_of
  tolerance <- sqrt(.Machine$double.eps)
  failures <- !is.na(x) & abs(ratio - round(ratio)) > tolerance
  if (!any(failures)) {
    return(invisible(NULL))
  }

  locations <- which(failures)
  location_chrs <- as.character(locations)
  bad_value_chrs <- as.character(x[failures])
  .stop_must(
    "must be a multiple of {multiple_of}.",
    x_arg = x_arg,
    additional_msg = c(
      "x" = "Unexpected location{?s}: {location_chrs}",
      "x" = "Unexpected value{?s}: {.val {bad_value_chrs}}."
    ),
    call = call,
    subclass = "not_multiple",
    message_env = rlang::current_env(),
    locations = locations
  )
}

#' Check that all list elements are named
#'
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
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
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
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
  locations <- unname(which(short_mask))
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
    message_env = rlang::current_env(),
    locations = locations
  )
}
