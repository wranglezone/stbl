#' Create a regex matching rule
#'
#' Attach a standardized error message to a `regex` argument. By default, the
#' message will be "must match the regex pattern \{regex\}". If the input
#' `regex` has a `negate` attribute set to `TRUE` (set automatically by
#' `regex_must_not_match()`), the message will instead be "must not match...".
#' This message can be used with [stabilize_chr()] and [stabilize_chr_scalar()].
#'
#' @param regex `(character)` The regular expression pattern.
#'
#' @returns For `regex_must_match`, the `regex` value with [names()] equal to
#'   the generated error message.
#' @export
#'
#' @examples
#' regex_must_match("[aeiou]")
#'
#' # With negation:
#' regex <- "[aeiou]"
#' attr(regex, "negate") <- TRUE
#' regex_must_match(regex)
regex_must_match <- function(regex) {
  verb <- if (isTRUE(attr(regex, "negate"))) {
    "must not match"
  } else {
    "must match"
  }

  rlang::set_names(
    regex,
    paste(verb, "the regex pattern", .cli_mark(.cli_escape(regex), "val"))
  )
}

#' @returns For `regex_must_not_match()`, the `regex` value with a `negate`
#'   attribute and with [names()] equal to the generated "must not match" error
#'   message.
#' @export
#'
#' @examples
#' regex_must_not_match("[aeiou]")
#' @rdname regex_must_match
regex_must_not_match <- function(regex) {
  attr(regex, "negate") <- TRUE
  regex_must_match(regex)
}
