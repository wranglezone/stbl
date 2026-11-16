#' Normalize a `required`/`.required` specification
#'
#' Converts the accepted forms of a requirements argument (`NULL`, a character
#' vector, or a list with unnamed entries for unconditional requirements and
#' named entries for conditional requirements) into a canonical nested list with
#' elements `always` (`character`) and `when` (a named list of canonical
#' specifications keyed by trigger). Named atomic vectors are treated like the
#' equivalent list. Duplicate triggers are merged by union.
#'
#' @param required `NULL`, a character vector, or a list.
#' @param required_arg (`character(1)`) Name of the argument, for error
#'   messages.
#' @inheritParams .shared-params
#' @returns A canonical requirements list.
#' @keywords internal
.normalize_required <- function(required, required_arg, call) {
  if (is.null(required)) {
    return(.new_required())
  }
  if (!is.list(required)) {
    required_nms <- names(required)
    required <- as.list(
      to_chr(required, x_arg = required_arg, call = call)
    )
    names(required) <- required_nms
  }
  .normalize_required_list(required, required_arg, call)
}

#' Create an empty canonical requirements list
#'
#' @param always `(character)` Unconditionally required names.
#' @param when `(list)` Named list of canonical requirements by trigger.
#' @returns A canonical requirements list.
#' @keywords internal
.new_required <- function(always = character(), when = list()) {
  list(always = always, when = when)
}

#' Normalize a list-valued requirements specification
#'
#' @inheritParams .normalize_required
#' @returns A canonical requirements list.
#' @keywords internal
.normalize_required_list <- function(required, required_arg, call) {
  result <- .new_required()
  entry_nms <- rlang::names2(required)
  for (i in seq_along(required)) {
    entry <- required[[i]]
    trigger <- entry_nms[[i]]
    if (is.null(entry)) {
      next
    }
    if (is.na(trigger) || !nzchar(trigger)) {
      .check_required_leaf(entry, required_arg, call)
      result$always <- union(result$always, entry)
      next
    }
    entry_spec <- if (is.list(entry)) {
      .normalize_required_list(entry, required_arg, call)
    } else {
      .check_required_leaf(entry, required_arg, call)
      .new_required(always = unique(entry))
    }
    result$when[[trigger]] <- .merge_required(
      result$when[[trigger]],
      entry_spec
    )
  }
  result
}

#' Check that a requirements leaf is a non-missing character vector
#'
#' @param leaf The value to check.
#' @inheritParams .normalize_required
#' @returns `NULL`, invisibly, if the leaf is valid.
#' @keywords internal
.check_required_leaf <- function(leaf, required_arg, call) {
  if (is.character(leaf) && !anyNA(leaf)) {
    return(invisible(NULL))
  }
  .stbl_abort(
    c(
      "{.arg {required_arg}} must contain only non-missing character vectors.",
      i = paste(
        "Unnamed entries are always required, and named entries are",
        "conditional on their name."
      )
    ),
    subclass = "bad_required",
    call = call,
    message_env = rlang::current_env()
  )
}

#' Merge two canonical requirements lists by union
#'
#' @param x,y Canonical requirements lists. `x` may be `NULL`.
#' @returns A canonical requirements list.
#' @keywords internal
.merge_required <- function(x, y) {
  if (is.null(x)) {
    return(y)
  }
  result <- .new_required(always = union(x$always, y$always), when = x$when)
  for (trigger in names(y$when)) {
    result$when[[trigger]] <- .merge_required(
      result$when[[trigger]],
      y$when[[trigger]]
    )
  }
  result
}

#' List every name mentioned in a canonical requirements list
#'
#' @param required A canonical requirements list.
#' @returns A character vector of unique names: required names, triggers, and
#'   dependents, at any nesting level.
#' @keywords internal
.required_names <- function(required) {
  unique(c(
    required$always,
    names(required$when),
    unlist(lapply(required$when, .required_names), use.names = FALSE)
  ))
}

#' Find the required names that are absent
#'
#' @param required A canonical requirements list.
#' @param present `(character)` Names that are present.
#' @param triggers `(character)` The chain of triggers leading to `required`.
#'   Used for recursion.
#' @returns A list with one entry per group of missing names. Each entry is a
#'   list with elements `missing` (`character`) and `triggers` (`character`).
#' @keywords internal
.find_missing_required <- function(required, present, triggers = character()) {
  result <- list()
  missing_names <- setdiff(required$always, present)
  if (length(missing_names)) {
    result <- list(list(missing = missing_names, triggers = triggers))
  }
  for (trigger in intersect(names(required$when), present)) {
    result <- c(
      result,
      .find_missing_required(
        required$when[[trigger]],
        present,
        c(triggers, trigger)
      )
    )
  }
  result
}

#' Check that required names are present
#'
#' @param required A canonical requirements list from `.normalize_required()`.
#' @param present `(character)` Names that are present.
#' @param noun (`character(1)`) What the names refer to, such as `"name"`,
#'   `"element"`, or `"column"`.
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @keywords internal
.check_required_present <- function(required, present, noun, x_arg, call) {
  missing_groups <- .find_missing_required(required, present)
  if (!length(missing_groups)) {
    return(invisible(NULL))
  }
  msgs <- vapply(
    missing_groups,
    .format_missing_required,
    character(1),
    noun = noun
  )
  # Reference messages by index so braces in names aren't re-interpreted.
  extra_idx <- seq_along(msgs)[-1]
  .stop_must(
    "{msgs[[1]]}",
    x_arg = x_arg,
    additional_msg = if (length(extra_idx)) {
      rlang::set_names(
        sprintf("{msgs[[%d]]}", extra_idx),
        rep("x", length(extra_idx))
      )
    },
    call = call,
    subclass = "missing_element",
    message_env = rlang::current_env()
  )
}

#' Describe one group of missing required names
#'
#' @param group A list with elements `missing` and `triggers`.
#' @param noun (`character(1)`) What the names refer to.
#' @returns A character string.
#' @keywords internal
.format_missing_required <- function(group, noun) {
  missing_names <- group$missing
  triggers <- group$triggers
  if (!length(triggers)) {
    return(format_inline(
      "must contain {noun}{qty(length(missing_names))}{?s} {.val {missing_names}}."
    ))
  }
  format_inline(
    "must contain {noun}{qty(length(missing_names))}{?s} {.val {missing_names}} when {.val {triggers}} ",
    "{qty(length(triggers))}{?is/are} present."
  )
}

#' Check that required names without specs are compatible with `.named`
#'
#' A required name that has no spec can only be present if extra named elements
#' are allowed, so an explicit `FALSE` is an inconsistent call.
#'
#' @param required A canonical requirements list.
#' @param spec_names `(character)` Names that have a spec.
#' @param named The extra-element control (`.named` or `.extra_cols`).
#' @param named_arg (`character(1)`) Name of the `named` argument.
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if the check passes.
#' @keywords internal
.check_required_have_specs <- function(
  required,
  spec_names,
  named,
  named_arg,
  call
) {
  unspecced <- setdiff(.required_names(required), spec_names)
  if (!length(unspecced) || !isFALSE(named)) {
    return(invisible(NULL))
  }
  .stbl_abort(
    c(
      paste(
        "Every name in the requirements must have a spec in {.arg ...} when",
        "{.arg {named_arg}} is {.code FALSE}."
      ),
      x = "Missing spec{?s} for: {.val {unspecced}}",
      i = "Use {.code NULL} to allow required names without specs."
    ),
    subclass = "bad_required",
    call = call,
    message_env = rlang::current_env()
  )
}
