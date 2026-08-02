#' Coerce to character with additional checks
#'
#' Compared to [to_chr()], `stabilize_chr()` checks more details, but is
#' slower. `stabilise_chr()`, `stabilize_character()`, and
#' `stabilise_character()` are synonyms of `stabilize_chr()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a character vector, or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-character>` when `x` cannot be coerced to character.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-size_too_small>` when the vector is shorter than `min_size`.
#'   - `<stbl-error-size_too_large>` when the vector is longer than `max_size`.
#'   - `<stbl-error-must>` when `regex` checks fail.
#' @family character functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_chr(letters)
#' stabilize_chr(1:10)
#' stabilize_chr(NULL)
#' try(stabilize_chr(NULL, allow_null = FALSE))
#' try(stabilize_chr(c("a", NA), allow_na = FALSE))
#' try(stabilize_chr(letters, min_size = 50))
#' try(stabilize_chr(letters, max_size = 20))
#' try(stabilize_chr(c("hide", "find", "find", "hide"), regex = "hide"))
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
  x_quo <- rlang::enquo(x)
  if (is.function(x)) {
    force(x_class)
    x <- x_quo
  }
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
stabilise_chr <- stabilize_chr

#' @export
#' @rdname stabilize_chr
stabilise_character <- stabilize_chr

#' Coerce to length-1 character with additional checks
#'
#' Checks whether a vector can be coerced to a length-1 character vector.
#' `stabilize_chr_scalar()` is optimized to check for length-1 character
#' vectors (compared to [stabilize_chr()] with `max_size = 1`).
#' `stabilise_chr_scalar`, `stabilize_character_scalar()`, and
#' `stabilise_character_scalar` are synonyms of `stabilize_chr_scalar()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a length-1 character vector, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-character>` when `x` cannot be coerced to character.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-must>` when `regex` checks fail.
#' @family character functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_chr_scalar(TRUE)
#' try(stabilize_chr_scalar(c(TRUE, FALSE, TRUE)))
#' try(stabilize_chr_scalar(NULL))
#' stabilize_chr_scalar(NULL, allow_null = TRUE)
stabilize_chr_scalar <- function(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  # enquo() must precede is.function(); see to_chr() for explanation.
  x_quo <- rlang::enquo(x)
  if (is.function(x)) {
    force(x_class)
    x <- x_quo
  }
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
#' @rdname stabilize_chr_scalar
stabilize_character_scalar <- stabilize_chr_scalar

#' @export
#' @rdname stabilize_chr_scalar
stabilise_chr_scalar <- stabilize_chr_scalar

#' @export
#' @rdname stabilize_chr_scalar
stabilise_character_scalar <- stabilize_chr_scalar

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

  rule_failures <- lapply(
    X = rules,
    FUN = .apply_regex_rule,
    x = x,
    x_arg = x_arg,
    call = call
  )

  error_msgs <- unlist(lapply(rule_failures, `[[`, "message"))

  if (length(error_msgs)) {
    locations <- sort(unique(unlist(
      lapply(rule_failures, `[[`, "locations")
    )))
    .stbl_abort(
      message = error_msgs,
      subclass = "must",
      call = call,
      message_env = rlang::current_env(),
      locations = locations
    )
  }

  invisible(NULL)
}

#' Apply a single regex rule to a character vector
#'
#' @param rule `(length-1 character)` A regex rule (possibly with a `name` and
#'   `negate` attribute).
#' @inheritParams .shared-params
#' @returns A list with a `message` character vector and integer `locations` of
#'   the failing elements if the rule fails, otherwise `NULL`.
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

  list(
    message = c(main_msg, additional_msg),
    locations = which(!success)
  )
}

#' Detect a regex pattern in a character vector
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
#' @returns A named character vector to be used as `additional_msg` in
#'   [.stop_must()].
#' @keywords internal
.describe_failure_chr <- function(x, success, negate = FALSE) {
  locations <- which(!success)
  if (length(x) == 1) {
    return(c(x = format_inline("{.val {x}} fails the check.")))
  }
  c(
    x = glue("Some values fail the check."),
    "x" = format_inline("Location{?s}: {as.character(locations)}"),
    "x" = format_inline("Value{?s}: {x[locations]}")
  )
}
