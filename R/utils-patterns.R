#' Validate a `.patterns` argument
#'
#' @param patterns A named list of stabilizers, or `NULL`.
#' @param patterns_arg (`character(1)`) Name of the argument, for messages.
#' @inheritParams .shared-params
#' @returns `patterns`, with `NULL` converted to an empty list.
#' @keywords internal
.normalize_patterns <- function(patterns, patterns_arg, call) {
  if (is.null(patterns)) {
    return(list())
  }
  if (!is.list(patterns)) {
    .stop_bad_patterns(
      "must be a named list of stabilizers.",
      "not_list",
      patterns_arg,
      call
    )
  }
  if (!length(patterns)) {
    return(list())
  }
  pattern_nms <- rlang::names2(patterns)
  if (anyNA(pattern_nms) || !all(nzchar(pattern_nms))) {
    .stop_bad_patterns(
      "must have a regular expression as the name of every element.",
      "missing_name",
      patterns_arg,
      call
    )
  }
  valid <- vapply(pattern_nms, .is_valid_regex, logical(1))
  if (!all(valid)) {
    bad <- pattern_nms[!valid]
    .stop_bad_patterns(
      "must have valid regular expressions as names.",
      "invalid_regex",
      patterns_arg,
      call,
      detail = format_inline("Invalid pattern{?s}: {.val {bad}}")
    )
  }
  is_spec <- vapply(patterns, is.function, logical(1))
  if (!all(is_spec)) {
    bad <- pattern_nms[!is_spec]
    .stop_bad_patterns(
      "must have a stabilizer function as every value.",
      "invalid_spec",
      patterns_arg,
      call,
      detail = format_inline("Invalid spec{?s} for: {.val {bad}}")
    )
  }
  patterns
}

#' Check whether a string is a valid regular expression
#'
#' @param pattern (`character(1)`) The candidate regular expression.
#' @returns (`logical(1)`) `TRUE` if `pattern` compiles without an error or
#'   warning.
#' @keywords internal
.is_valid_regex <- function(pattern) {
  tryCatch(
    {
      .detect_regex("", pattern)
      TRUE
    },
    error = function(cnd) FALSE,
    warning = function(cnd) FALSE
  )
}

#' Abort because `.patterns` is invalid
#'
#' @param msg (`character(1)`) The problem, appended to the argument name.
#' @param kind (`character(1)`) Error subclass added after `"bad_patterns"`.
#' @param patterns_arg (`character(1)`) Name of the argument, for messages.
#' @param detail (`character(1)` or `NULL`) Optional extra bullet describing the
#'   offending values.
#' @inheritParams .shared-params
#' @returns Does not return; always throws an error.
#' @keywords internal
.stop_bad_patterns <- function(msg, kind, patterns_arg, call, detail = NULL) {
  .stbl_abort(
    c(
      paste0("{.arg {patterns_arg}} ", msg),
      if (!is.null(detail)) c(x = detail)
    ),
    subclass = c("bad_patterns", kind),
    call = call,
    message_env = rlang::current_env()
  )
}

#' Find which patterns match each name
#'
#' @param nms `(character)` Names to match. Empty names never match.
#' @param patterns `(list)` Normalized `.patterns`.
#' @returns A logical matrix with a row per name and a column per pattern.
#' @keywords internal
.match_patterns <- function(nms, patterns) {
  out <- matrix(FALSE, nrow = length(nms), ncol = length(patterns))
  for (j in seq_along(patterns)) {
    out[, j] <- nzchar(nms) & .detect_regex(nms, names(patterns)[[j]])
  }
  out
}

#' Validate elements whose names match `.patterns`
#'
#' Elements matching several patterns (or an exact spec and a pattern) have
#' every spec applied to the original value, and the results are reconciled.
#' Failures are collected and reported together.
#'
#' @inheritParams .shared-params-lst
#' @returns The updated list.
#' @keywords internal
.validate_pattern_elements <- function(
  .x,
  nms,
  element_specs,
  patterns,
  matches,
  .x_arg,
  .call
) {
  failed <- integer()
  errors <- list()
  for (i in which(rowSums(matches) > 0L)) {
    specs <- unname(patterns[matches[i, ]])
    exact <- element_specs[[nms[[i]]]]
    if (!is.null(exact)) {
      specs <- c(list(exact), specs)
    }
    nm_arg <- if (sum(nms == nms[[i]]) == 1L) deparse(nms[[i]]) else i
    element_arg <- paste0(.x_arg, "[[", nm_arg, "]]")
    result <- rlang::try_fetch(
      .apply_specs_for_element(specs, .x[[i]], element_arg, .call),
      error = function(cnd) cnd
    )
    if (inherits(result, "error")) {
      failed <- c(failed, i)
      errors <- c(errors, list(result))
    } else {
      # Assign via list() so a NULL result doesn't drop the element.
      .x[i] <- list(result)
    }
  }
  if (length(failed)) {
    .stop_cant_stabilize_patterns(errors, failed, .x_arg, .call)
  }
  .x
}

#' Apply one or more specs to a single element
#'
#' With several specs, every spec is applied to the original value and the
#' results are reconciled.
#'
#' @param specs (`list`) Stabilizer functions to apply.
#' @param value (`any`) The element value.
#' @inheritParams .shared-params
#' @returns The stabilized value.
#' @keywords internal
.apply_specs_for_element <- function(specs, value, x_arg, call) {
  if (length(specs) == 1L) {
    return(.call_specified_fn(specs[[1L]], value, .x_arg = x_arg, .call = call))
  }
  results <- lapply(
    specs,
    .call_specified_fn,
    value,
    .x_arg = x_arg,
    .call = call
  )
  consensus <- .reconcile_values(results)
  if (.is_mismatch(consensus)) {
    .stop_inconsistent_all_of(x_arg = x_arg, call = call)
  }
  consensus
}

#' Abort because elements matching `.patterns` failed their specs
#'
#' @param errors (`list`) Conditions caught while applying specs.
#' @param locations (`integer`) Positions of the failing elements.
#' @inheritParams .shared-params
#' @returns Does not return; always throws an error.
#' @keywords internal
.stop_cant_stabilize_patterns <- function(errors, locations, x_arg, call) {
  msgs <- vapply(errors, .extract_stabilizer_msg, character(1L))
  additional_msg <- stats::setNames(
    paste0("Location ", locations, ": ", msgs),
    rep("x", length(msgs))
  )
  .stop_must(
    msg = "must have every element matching `.patterns` satisfy its spec.",
    x_arg = x_arg,
    additional_msg = additional_msg,
    call = call,
    subclass = "cant_stabilize_patterns",
    message_env = rlang::current_env(),
    locations = locations
  )
}

#' Get the names that match any pattern
#'
#' @inheritParams .match_patterns
#' @returns (`character`) The elements of `nms` matching at least one pattern.
#' @keywords internal
.names_matching_patterns <- function(nms, patterns) {
  if (!length(nms) || !length(patterns)) {
    return(character())
  }
  nms[rowSums(.match_patterns(nms, patterns)) > 0L]
}
