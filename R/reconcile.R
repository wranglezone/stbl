#' Reconcile equivalent values into their narrowest common representation
#'
#' Check that every value in `...` is *equivalent* to every other value, and
#' return the narrowest representation of them. The result doesn't depend on the
#' order of the values.
#'
#' @section Equivalence:
#' Equivalence is defined by stbl's own conversions:
#'
#' - Values of the same type are equivalent only if they are [identical()].
#' - Values of different types are equivalent when `identical(to(x, y), y)` and
#'   `identical(to(y, x), x)`. A failed conversion means "not equivalent".
#'
#' Requiring both directions keeps lossy conversions out. For example,
#' `to_lgl(0.5)` is `TRUE`, but `to_dbl(TRUE)` is `1`, so `0.5` and `TRUE` are
#' not equivalent. Neither are `"1.0"` and `1L`, nor `"true"` and `TRUE`.
#'
#' Equivalent pairs include `1L` and `1`, `1L` and `TRUE`, `"1"` and `1L`,
#' `"TRUE"` and `TRUE`, `as.Date("2024-01-02")` and `"2024-01-02"`, and a
#' factor and the character vector of its labels. A factor and an ordered
#' factor are not equivalent, and neither are two factors with the same labels
#' but different levels, because those pairs have the same type and are not
#' identical. The same rule makes date-times with different time zones not
#' equivalent. `NA` matches only `NA`, and `NaN` matches only `NaN`.
#'
#' Conversions between Date and POSIXct values use the time zone of the
#' date-time value, so results don't depend on the time zone of your session
#' (unless the date-time has no time zone of its own).
#'
#' Equivalence is not strictly transitive: `"TRUE"` is equivalent to `TRUE`, and
#' `TRUE` to `1L`, but `"TRUE"` is not equivalent to `1L`. When `...` contains
#' three or more values, every pair must be equivalent.
#'
#' @section Narrowest type:
#' When values are equivalent, the result has the narrowest type of the inputs,
#' by this fixed ranking (narrowest first): factor, Date, POSIXct, hms, Period,
#' logical, integer, double, character. Classed types rank ahead of their
#' underlying types, so a result keeps the class a caller asked for.
#'
#' Values of a type outside the ranking (for example, classes handled by the
#' [vctrs::vec_cast()] fallback in [to()]) are equivalent only to values of the
#' same class, compared with [vctrs::vec_equal()].
#'
#' @section Containers:
#' Lists, data frames, `NULL`, and functions are separate categories, and
#' values of different categories are never equivalent. For example, `1:2` and
#' `list(1, 2)` are not equivalent, even though [to_lst()] and [to_int()]
#' convert between them.
#'
#' - **Lists** are reconciled element by element, with the same rules applied
#'   to every element. Length, names, and other attributes must match.
#' - **Data frames** are reconciled column by column. The class, row names, and
#'   column names and order must match.
#' - **Functions** and `NULL` are equivalent only when identical.
#'
#' The result can combine the narrowest elements of its inputs, so it might not
#' equal any single input. For `list(a = 1L, b = 2)` and `list(a = 1, b = 2L)`,
#' the result is `list(a = 1L, b = 2L)`.
#'
#' @param ... The values to reconcile.
#' @inheritParams .shared-params
#'
#' @returns The narrowest common representation of the values in `...` if they
#'   are all equivalent. A single value is returned unchanged. Otherwise, an
#'   error condition with classes `<stbl-error>`, `<stbl-condition>`,
#'   `<rlang_error>`, `<error>`, `<condition>`, and a specific class by failure
#'   mode:
#'   - `<stbl-error-cant_reconcile>` when any two values are not equivalent.
#'   The message names the pair that disagreed and, for nested values, the path
#'   to the first difference.
#'   - `<stbl-error-empty_values>` when no values are supplied in `...`.
#' @family multiple type functions
#' @seealso [stabilize_all_of()], which uses `reconcile()` to combine the
#'   results of several specs.
#' @export
#'
#' @examples
#' reconcile(1L, 1)
#' reconcile(as.double(1:10), 1:10)
#' reconcile("1", 1L, 1)
#'
#' # The narrowest type wins, even for the elements of a list.
#' reconcile(list(a = 1L, b = 2), list(a = 1, b = 2L))
#'
#' # Factors are equivalent to the character vector of their labels.
#' reconcile(c("a", "b"), factor(c("a", "b"), levels = c("b", "a")))
#'
#' # Lossy conversions are not equivalent.
#' try(reconcile(0.5, TRUE))
#'
#' # Nested differences are reported with their path.
#' try(reconcile(list(a = 1:2), list(a = c(1L, 3L))))
#'
#' # Values of the same type must be identical.
#' try(reconcile(
#'   factor(c("a", "b")),
#'   factor(c("a", "b"), levels = c("b", "a"))
#' ))
reconcile <- function(..., call = caller_env()) {
  force(call)
  values <- rlang::list2(...)
  labels <- .reconcile_labels(rlang::enexprs(...), length(values))
  .reconcile_labeled(values, labels, call = call)
}

# helpers ----

#' The types stbl can rank, narrowest first
#'
#' Keep the ranked types in one place so new `to_*()` families can be added.
#'
#' @keywords internal
.reconcile_ranking <- c(
  "factor",
  "Date",
  "POSIXct",
  "hms",
  "Period",
  "logical",
  "integer",
  "double",
  "character"
)

#' Reconcile values that already have labels
#'
#' @param values `(list)` The values to reconcile.
#' @param labels `(character)` One label per element of `values`, for messages.
#' @inheritParams .shared-params
#' @returns The reconciled value, or an error.
#' @keywords internal
.reconcile_labeled <- function(values, labels, call) {
  if (!length(values)) {
    .stbl_abort(
      "{.fn reconcile} requires at least one value.",
      "empty_values",
      call = call
    )
  }
  result <- .reconcile_values(values)
  if (.is_mismatch(result)) {
    .stop_cant_reconcile(result, labels, call = call)
  }
  result
}

#' Label the values passed to `reconcile()`
#'
#' @param exprs `(list)` The captured expressions of the values.
#' @param n `(integer(1))` The number of values.
#' @returns A character vector of length `n`.
#' @keywords internal
.reconcile_labels <- function(exprs, n) {
  if (!length(exprs)) {
    return(character())
  }
  nms <- names(exprs) %||% rep("", n)
  vapply(
    seq_len(n),
    \(i) if (nzchar(nms[[i]])) nms[[i]] else rlang::as_label(exprs[[i]]),
    character(1)
  )
}

#' Reconcile a list of values
#'
#' @param values `(list)` At least one value.
#' @returns The reconciled value, or a mismatch (see `.new_mismatch()`).
#' @keywords internal
.reconcile_values <- function(values) {
  out <- .reconcile(values)
  mismatch <- out$mismatch
  if (is.null(mismatch)) {
    return(out$result)
  }
  .new_mismatch(
    mismatch$i,
    mismatch$j,
    .mismatch_path(values[[1L]], mismatch$at),
    .reconcile_reason(mismatch$reason)
  )
}

# The reasons the C code can give for a mismatch
#
# The position in this vector is the reason code in `stbl.h`.
.reconcile_reasons <- c(
  "Lengths differ.",
  "Names differ.",
  "Ordering differs.",
  "Levels differ.",
  "Time zones differ.",
  "Classes differ.",
  "Column names differ.",
  "Row names differ.",
  "Attributes differ."
)

#' Describe a reason code as a message
#'
#' @param code `(integer(1))` A reason code from C, or `0` for no specific
#'   reason.
#' @returns A single string, or `NULL` if there is no specific reason.
#' @keywords internal
.reconcile_reason <- function(code) {
  if (code == 0L) {
    return(NULL)
  }
  .reconcile_reasons[[code]]
}

#' Describe the location of the first difference
#'
#' @param x The first of the values being reconciled.
#' @param at `(integer)` The position of the difference, from the top.
#' @returns A string like `"$a[[2]]"`, or `""` at the top level.
#' @keywords internal
.mismatch_path <- function(x, at) {
  path <- ""
  for (i in at) {
    path <- paste0(path, .path_step(names(x), i))
    x <- x[[i]]
  }
  path
}

#' Compare two atomic vectors, for the C code
#'
#' Called from C for pairs it doesn't compare itself.
#'
#' @inheritParams .atomics_equivalent
#' @returns `-1L` if `x` and `y` are equivalent. Otherwise the reason code of
#'   the difference (see `.reconcile_reasons`), or `0L` for no specific reason.
#' @keywords internal
.atomic_mismatch <- function(x, y) {
  if (.atomics_equivalent(x, y)) {
    return(-1L)
  }
  reason <- .atomic_difference(x, y)
  if (is.null(reason)) {
    return(0L)
  }
  match(reason, .reconcile_reasons)
}

#' Find the ranked type of a value
#'
#' @param x The value to check.
#' @returns An element of `.reconcile_ranking`, or `NA_character_` if the type
#'   of `x` isn't ranked.
#' @keywords internal
.reconcile_type <- function(x) {
  if (is.factor(x)) {
    return("factor")
  }
  for (class_type in c("Date", "POSIXct", "hms", "Period")) {
    if (inherits(x, class_type)) {
      return(class_type)
    }
  }
  if (is.object(x)) {
    return(NA_character_)
  }
  base_type <- typeof(x)
  if (base_type %in% .reconcile_ranking) {
    return(base_type)
  }
  NA_character_
}

#' Check whether two atomic vectors are equivalent
#'
#' @param x,y The values to compare.
#' @returns `TRUE` or `FALSE`.
#' @keywords internal
.atomics_equivalent <- function(x, y) {
  if (length(x) != length(y) || !identical(names(x), names(y))) {
    return(FALSE)
  }
  x_type <- .reconcile_type(x)
  y_type <- .reconcile_type(y)
  if (is.na(x_type) || is.na(y_type)) {
    return(is.na(x_type) && is.na(y_type) && .unranked_equal(x, y))
  }
  if (x_type == y_type) {
    return(identical(x, y))
  }
  .round_trips(x, y) && .round_trips(y, x)
}

#' Check whether two values of an unranked type are equal
#'
#' @inheritParams .atomics_equivalent
#' @returns `TRUE` or `FALSE`.
#' @keywords internal
.unranked_equal <- function(x, y) {
  if (!identical(class(x), class(y))) {
    return(FALSE)
  }
  tryCatch(
    isTRUE(all(vctrs::vec_equal(x, y, na_equal = TRUE))),
    error = \(cnd) FALSE
  )
}

#' Check whether converting `x` to the type of `y` gives back `y`
#'
#' @inheritParams .atomics_equivalent
#' @returns `TRUE` or `FALSE`.
#' @keywords internal
.round_trips <- function(x, y) {
  converted <- tryCatch(.convert_for_reconcile(x, y), error = \(cnd) NULL)
  identical(converted, y)
}

#' Convert `x` to the type of `y`, independent of the session time zone
#'
#' When going from a date-time to a Date, the date depends on the time zone, so
#' use the time zone of the date-time.
#'
#' @inheritParams .atomics_equivalent
#' @returns `x` converted to the type of `y`.
#' @keywords internal
.convert_for_reconcile <- function(x, y) {
  if (inherits(x, "POSIXct") && inherits(y, "Date")) {
    return(to(x, y, tz = resolve_tz(x)))
  }
  to(x, y)
}

#' Explain why two atomic vectors aren't equivalent
#'
#' @inheritParams .atomics_equivalent
#' @returns A single string, or `NULL` if there is nothing specific to say.
#' @keywords internal
.atomic_difference <- function(x, y) {
  if (length(x) != length(y)) {
    return("Lengths differ.")
  }
  if (!identical(names(x), names(y))) {
    return("Names differ.")
  }
  NULL
}

#' Describe the location of an element within a list
#'
#' @param nms `(character)` The names of the list, or `NULL`.
#' @param i `(integer(1))` The position of the element.
#' @param is_df `(logical(1))` Whether the list is a data frame.
#' @returns A string like `"$a"` or `"[[2]]"`.
#' @keywords internal
.path_step <- function(nms, i, is_df = FALSE) {
  nm <- nms[[i]] %||% ""
  if (is.na(nm) || !nzchar(nm)) {
    return(paste0("[[", i, "]]"))
  }
  if (identical(make.names(nm), nm)) {
    return(paste0("$", nm))
  }
  paste0("$`", nm, "`")
}

#' Create a record of two values that can't be reconciled
#'
#' @param i,j `(integer(1))` The positions of the values that disagree.
#' @param path `(character(1))` The path within the values to the first
#'   difference.
#' @param reason `(character(1))` A description of the difference, or `NULL`.
#' @returns A `stbl_mismatch` object.
#' @keywords internal
.new_mismatch <- function(i, j, path, reason = NULL) {
  structure(
    list(i = i, j = j, path = path, reason = reason),
    class = "stbl_mismatch"
  )
}

#' Check for a mismatch record
#'
#' @param x The object to check.
#' @returns `TRUE` or `FALSE`.
#' @keywords internal
.is_mismatch <- function(x) {
  inherits(x, "stbl_mismatch")
}

#' Signal an error when values can't be reconciled
#'
#' @param mismatch A `stbl_mismatch` object.
#' @param labels `(character)` The labels of the values.
#' @inheritParams .shared-params
#' @returns Does not return; throws an error.
#' @keywords internal
.stop_cant_reconcile <- function(mismatch, labels, call) {
  label_x <- labels[[mismatch$i]]
  label_y <- labels[[mismatch$j]]
  msg <- c("{.arg {label_x}} and {.arg {label_y}} must be equivalent.")
  if (!is.null(mismatch$reason)) {
    msg <- c(msg, x = mismatch$reason)
  }
  if (nzchar(mismatch$path)) {
    path <- mismatch$path
    msg <- c(msg, i = "The first difference is at {.code {path}}.")
  }
  .stbl_abort(
    msg,
    "cant_reconcile",
    call = call,
    message_env = rlang::current_env()
  )
}
