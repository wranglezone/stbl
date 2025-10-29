#' Ensure a character argument meets expectations
#'
#' @description `to_chr()` checks whether an argument can be coerced to
#'   character without losing information, returning it silently if so.
#'   Otherwise an informative error message is signaled.
#'
#'   `stabilize_chr()` can check more details about the argument, but is slower
#'   than `to_chr()`.
#'
#'   `stabilize_chr_scalar()` and `to_chr_scalar()` are optimized to check for
#'   length-1 character vectors.
#'
#' @details These functions have two important differences from
#'   [base::as.character()]:
#'
#' - `list`s and `data.frame`s are *not* coerced to character. In base R, such
#'   objects are coerced to character representations of their elements. For
#'   example, `as.character(list(1:3))` returns "1:10". In the unlikely event
#'   that this is the expected behavior, use `as.character()` instead.
#' - `NULL` values can be rejected as part of the call to this function (with
#'   `allow_null = FALSE`).
#'
#' @inheritParams .shared-params
#'
#' @returns The argument as a character vector.
#' @family character functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_chr("a")
#' to_chr(letters)
#' to_chr(1:10)
#' to_chr(1 + 0i)
#' to_chr(NULL)
#' try(to_chr(NULL, allow_null = FALSE))
#'
#' to_chr_scalar("a")
#' try(to_chr_scalar(letters))
#'
#' stabilize_chr(letters)
#' stabilize_chr(1:10)
#' stabilize_chr(NULL)
#' try(stabilize_chr(NULL, allow_null = FALSE))
#' try(stabilize_chr(c("a", NA), allow_na = FALSE))
#' try(stabilize_chr(letters, min_size = 50))
#' try(stabilize_chr(letters, max_size = 20))
#' try(stabilize_chr(c("hide", "find", "find", "hide"), regex = "hide"))
#'
#' stabilize_chr_scalar(TRUE)
#' stabilize_chr_scalar("TRUE")
#' try(stabilize_chr_scalar(c(TRUE, FALSE, TRUE)))
#' stabilize_chr_scalar(NULL)
#' try(stabilize_chr_scalar(NULL, allow_null = FALSE))
stabilize_chr <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls(
    x,
    to_cls_fn = to_chr,
    check_cls_value_fn = .check_value_chr,
    check_cls_value_fn_args = list(regex = regex),
    allow_null = allow_null,
    allow_na = allow_na,
    min_size = min_size,
    max_size = max_size,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
#' @rdname stabilize_chr
stabilize_character <- stabilize_chr

#' @export
#' @rdname stabilize_chr
stabilize_chr_scalar <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls_scalar(
    x,
    to_cls_scalar_fn = to_chr_scalar,
    check_cls_value_fn = .check_value_chr,
    check_cls_value_fn_args = list(regex = regex),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    allow_na = allow_na,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
#' @rdname stabilize_chr
stabilize_character_scalar <- stabilize_chr_scalar

#' Check character values against one or more regex patterns
#'
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if `x` passes all checks.
#' @keywords internal
.check_value_chr <- function(
  x,
  regex,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  if (is.null(regex)) {
    return(invisible(NULL))
  }

  rules <- if (is.list(regex)) regex else list(regex)

  error_msgs <- lapply(
    X = rules,
    FUN = .apply_regex_rule,
    x = x,
    x_arg = x_arg,
    call = call
  )

  error_msgs <- unlist(error_msgs)

  if (length(error_msgs)) {
    .stbl_abort(
      message = error_msgs,
      subclass = "must",
      call = call,
      message_env = rlang::current_env()
    )
  }

  invisible(NULL)
}

#' Apply a single regex rule to a character vector
#'
#' @param rule `(length-1 character)` A regex rule (possibly with a `name` and
#'   `negate` attribute).
#' @inheritParams .shared-params
#'
#' @returns A character vector of error messages if the rule fails, otherwise
#'   `NULL`.
#' @keywords internal
.apply_regex_rule <- function(rule, x, x_arg, call) {
  rule <- to_chr_scalar(rule, call = call)
  negate <- isTRUE(attr(rule, "negate"))
  success <- .has_regex_pattern(x, rule) == !negate

  if (all(success)) {
    return(NULL)
  }

  main_msg <- .define_main_msg(
    x_arg,
    names(rule) %||% names(regex_must_match(rule))
  )
  additional_msg <- .describe_failure_chr(x, success, negate)

  c(main_msg, additional_msg)
}

#' Detect a regex pattern in a character vector
#'
#' A wrapper around [stringi::stri_detect_regex()] and [base::grepl()] that
#' prefers the `stringi` implementation if the package is available.
#'
#' @inheritParams .shared-params
#' @returns A logical vector of matches in `x` to `regex`.
#' @keywords internal
.has_regex_pattern <- function(x, regex) {
  if (inherits(regex, "stringr_pattern")) {
    rlang::check_installed("stringr", "to apply a stringr-style regex pattern.")
    return(is.na(x) | stringr::str_detect(x, regex))
  }

  if (requireNamespace("stringi", quietly = TRUE)) {
    return(is.na(x) | stringi::stri_detect_regex(x, regex))
  }
  return(is.na(x) | grepl(regex, x)) # nocov
}

#' Describe a character-based validation failure
#'
#' @inheritParams .shared-params
#' @param success `(logical)` A logical vector indicating which elements of `x`
#'   passed the check.
#' @param negate `(length-1 logical)` Was the check a negative one?
#'
#' @returns A named character vector to be used as `additional_msg` in
#'   [.stop_must()].
#' @keywords internal
.describe_failure_chr <- function(x, success, negate = FALSE) {
  locations <- which(!success)

  if (length(x) == 1) {
    return(c(x = cli::format_inline("{.val {x}} fails the check.")))
  }

  c(
    x = glue("Some values fail the check."),
    "*" = cli::format_inline("Locations: {locations}"),
    "*" = cli::format_inline("Values: {x[locations]}")
  )
}
