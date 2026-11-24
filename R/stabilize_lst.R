#' Ensure a list meets expectations
#'
#' `stabilize_lst()` validates the structure and contents of a list. It can
#' check that specific named elements are present and valid, that extra named
#' elements conform to a shared rule, and that unnamed elements conform to a
#' shared rule. `stabilise_lst()`, `stabilize_list()`, and `stabilise_list()`
#' are synonyms of `stabilize_lst()`.
#'
#' @param ... Named stabilizer functions, such as `stabilize_*` functions
#'   ([stabilize_chr()], etc) or functions produced by `specify_*()` functions
#'   ([specify_chr()], etc). Each name corresponds to an element in `.x`, and
#'   the function is used to validate that element when present. Whether the
#'   element is required (its absence is an error) is controlled by `.required`.
#' @param .named Controls how named elements of `.x` that are *not* explicitly
#'   listed in `...` are handled. One of:
#'   - `NULL` (default): any extra named elements cause an error. Names in
#'   `.required` that have no spec in `...` are allowed, unchecked.
#'   - `FALSE`: any extra named elements cause an error, and every name in
#'   `.required` must have a spec in `...`.
#'   - `TRUE`: extra named elements are allowed, unchecked.
#'   - A single stabilizer function, such as a `stabilize_*` function
#'   ([stabilize_chr()], etc) or a function produced by a `specify_*()` function
#'   ([specify_chr()], etc), used to validate every extra named element.
#' @param .unnamed Controls how unnamed elements of `.x` are handled. One of:
#'   - `NULL` or `FALSE` (default): any unnamed elements cause an error.
#'   - `TRUE`: unnamed elements are allowed, unchecked.
#'   - A single stabilizer function, such as a `stabilize_*` function
#'   ([stabilize_chr()], etc) or a function produced by a `specify_*()` function
#'   ([specify_chr()], etc), used to validate every unnamed element.
#' @param .patterns `(list)` A named list of stabilizers, such as `specify_*()`
#'   results, `stabilize_*()` functions, or `to_*()` functions. Each name is a
#'   regular expression matched against the names of `.x`, and the spec is
#'   applied to every element whose name matches. Matching uses ICU regular
#'   expressions when the stringi package is installed (otherwise [grepl()]).
#'   An element matching any pattern is not an "extra" element, so `.named` does
#'   not apply to it. An element that matches several patterns, or a pattern and
#'   an exact spec in `...`, is checked by every matching spec and the results
#'   are combined with [reconcile()].
#' @param .unique (`logical(1)`) Should all elements in `.x` be distinct? If
#'   `TRUE`, duplicated elements are rejected.
#' @param .required `(character or list)` Names of elements that must be
#'   present in `.x`. Defaults to all names in `...`, so every named spec is
#'   required unless you opt it out. A supplied `.required` *replaces* that
#'   default, so `.required = list(credit_card = "billing_address")` makes every
#'   other spec optional; list the unconditional names explicitly. Specs for
#'   names that are not required are optional: if absent, no error is raised; if
#'   present, they're validated normally. Pass `NULL` or `character()` to make
#'   every named spec optional. Every name in `.required` is enforced, whether
#'   or not it has a spec in `...` (see `.named`). A zero-length `.x` (such as
#'   `list()`) skips this check when `.allow_zero_length = TRUE`. See `required`
#'   in [stabilize_names)()] for details on expressing conditional requirements.
#' @inheritParams .shared-params
#'
#' @returns The validated list (or an atomic vector when `.simplify = TRUE` and
#'   simplification is possible), or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-bad_function>` for functions when `.coerce_function =
#'   FALSE` (the default).
#'   - `<stbl-error-bad_named>` when extra named elements are present but
#'   `.named` is `NULL` or `FALSE`.
#'   - `<stbl-error-bad_null>` for `NULL` values when `.allow_null = FALSE`.
#'   - `<stbl-error-bad_patterns-invalid_regex>` when a name of `.patterns` is
#'   not a valid regular expression.
#'   - `<stbl-error-bad_patterns-invalid_spec>` when an element of `.patterns`
#'   is not a function.
#'   - `<stbl-error-bad_patterns-missing_name>` when an element of `.patterns`
#'   is unnamed.
#'   - `<stbl-error-bad_patterns-not_list>` when `.patterns` is not a list.
#'   - `<stbl-error-bad_required>` when `.required` is invalid, or when
#'   `.named = FALSE` and a name in `.required` has no spec in `...`.
#'   - `<stbl-error-bad_unnamed>` when unnamed elements are present but
#'   `.unnamed` is `NULL` or `FALSE`.
#'   - `<stbl-error-cant_stabilize_patterns>` when elements matching `.patterns`
#'   fail their specs.
#'   - `<stbl-error-coerce-list>` when `.x` cannot be converted to a list.
#'   - `<stbl-error-duplicate_elements>` when `.unique = TRUE` and duplicate
#'   elements are present.
#'   - `<stbl-error-duplicate_names>` when duplicate names are present and
#'   `.allow_duplicate_names = FALSE`.
#'   - `<stbl-error-missing_element>` when a required named element is absent
#'   (including conditionally required elements whose trigger is present).
#'   - `<stbl-error-size_too_large>` when the list is longer than `.max_size`.
#'   - `<stbl-error-size_too_small>` when the list is shorter than `.min_size`.
#'   - `<stbl-error-size_x_vs_y>` when `.min_size` is larger than `.max_size`.
#'   - `<stbl-error-unnamed_spec>` when any element passed through `...` is
#'   unnamed.
#'   - Errors from the specs in `...`, `.named`, or `.unnamed` when an element
#'   does not satisfy its spec.
#' @family list functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' # Basic validation: named required elements
#' stabilize_lst(
#'   list(name = "Alice", age = 30L),
#'   name = specify_chr_scalar(),
#'   age = specify_int_scalar()
#' )
#'
#' # Allow any non-NULL element with assert_present
#' stabilize_lst(list(data = mtcars), data = assert_present)
#'
#' # Validate extra named elements via .named
#' stabilize_lst(
#'   list(a = 1L, b = 2L, c = 3L),
#'   .named = specify_int_scalar()
#' )
#'
#' # Allow extra named elements unchecked with .named = TRUE
#' stabilize_lst(list(a = 1L, b = "anything"), .named = TRUE)
#'
#' # Validate unnamed elements via .unnamed
#' stabilize_lst(list(1L, 2L, 3L), .unnamed = specify_int_scalar())
#'
#' # Allow unnamed elements unchecked with .unnamed = TRUE
#' stabilize_lst(list(1L, "anything"), .unnamed = TRUE)
#'
#' # NULL is allowed by default
#' stabilize_lst(NULL)
#' try(stabilize_lst(NULL, .allow_null = FALSE))
#'
#' # Enforce size constraints
#' try(stabilize_lst(list(a = 1L), .min_size = 2))
#'
#' # Reject duplicate names by default; opt in to allow them
#' try(stabilize_lst(list(a = 1L, a = 2L), .named = specify_int_scalar()))
#' stabilize_lst(
#'   list(a = 1L, a = 2L),
#'   .named = specify_int_scalar(),
#'   .allow_duplicate_names = TRUE
#' )
#'
#' # Mark named specs as optional via .required
#' stabilize_lst(
#'   list(a = 1L),
#'   a = specify_int_scalar(),
#'   b = specify_int_scalar(),
#'   .required = "a"
#' )
#' try(
#'   stabilize_lst(list(a = 1L), a = specify_int_scalar(), b = specify_int_scalar())
#' )
#'
#' # Conditional requirements: when `credit_card` is present, `billing_address`
#' # is required.
#' stabilize_credit_card <- function(x) {
#'   stabilize_lst(
#'     x,
#'     name = specify_chr_scalar(),
#'     credit_card = specify_int_scalar(),
#'     billing_address = specify_chr_scalar(),
#'     .required = list("name", credit_card = "billing_address")
#'   )
#' }
#' stabilize_credit_card(list(name = "Alice"))
#' try(stabilize_credit_card(list(name = "Alice", credit_card = 1234L)))
#'
#' # Validate elements by name pattern
#' stabilize_lst(
#'   list(S_a = "x", I_n = 1L),
#'   .patterns = list("^S_" = stabilize_chr_scalar, "^I_" = stabilize_int_scalar)
#' )
#'
#' # Simplify a list of scalars to an atomic vector
#' stabilize_lst(
#'   list(lon = 1.5, lat = 2L),
#'   lon = specify_dbl_scalar(),
#'   lat = specify_int_scalar(),
#'   .simplify = TRUE
#' )
stabilize_lst <- function(
  .x,
  ...,
  .patterns = NULL,
  .named = NULL,
  .unnamed = NULL,
  .allow_duplicate_names = FALSE,
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .required = ...names(),
  .coerce_function = FALSE,
  .simplify = FALSE,
  .x_arg = caller_arg(.x),
  .call = caller_env(),
  .x_class = object_type(.x)
) {
  force(.x_arg)
  force(.call)
  .simplify <- to_lgl_scalar(.simplify, x_arg = ".simplify", call = .call)
  .required <- .normalize_required(.required, ".required", call = .call)
  .patterns <- .normalize_patterns(.patterns, ".patterns", call = .call)
  .check_required_have_specs(
    .required,
    spec_names = c(
      ...names(),
      .names_matching_patterns(.required_names(.required), .patterns)
    ),
    named = .named,
    named_arg = ".named",
    call = .call
  )
  if (is.null(.x)) {
    return(.to_null(
      .x,
      allow_null = .allow_null,
      x_arg = .x_arg,
      call = .call
    ))
  }
  .x <- to_lst(
    .x,
    coerce_function = .coerce_function,
    x_arg = .x_arg,
    call = .call
  )
  .check_size(
    .x,
    min_size = .min_size,
    max_size = .max_size,
    x_arg = .x_arg,
    call = .call
  )
  .check_specs_named(..., .call = .call)
  .allow_zero_length <- to_lgl_scalar(.allow_zero_length, call = .call)
  if (!length(.x) && .allow_zero_length) {
    return(.x)
  }

  .x <- .validate_named_elements(
    .x,
    ...,
    .patterns = .patterns,
    .named = .named,
    .required = .required,
    .allow_duplicate_names = .allow_duplicate_names,
    .x_arg = .x_arg,
    .call = .call
  )
  .x <- .validate_unnamed_elements(
    .x,
    .unnamed = .unnamed,
    .x_arg = .x_arg,
    .call = .call
  )
  # Run after validation so converted values (e.g. "1" and 1L both becoming
  # 1L) are compared, not the original inputs.
  .check_unique(
    .x,
    unique = .unique,
    x_arg = .x_arg,
    call = .call
  )

  .simplify_each(.x, simplify = .simplify)
}

#' @export
#' @rdname stabilize_lst
stabilize_list <- stabilize_lst

#' @export
#' @rdname stabilize_lst
stabilise_lst <- stabilize_lst

#' @export
#' @rdname stabilize_lst
stabilise_list <- stabilize_lst

# helpers ----

## shared params ----

#' Shared params for list helpers
#'
#' @param element_specs `(list)` Named list of stabilizer functions, such as
#'   `stabilize_*` functions ([stabilize_chr()], etc) or functions produced by
#'   `specify_*()` functions ([specify_chr()], etc). Each name corresponds to an
#'   element in `.x`, and the function is used to validate that element when
#'   present. Whether the element is required is controlled by `.required`.
#' @param is_extra_named `(logical)` Element-wise indicator of extra named
#'   positions.
#' @param named_spec A single stabilizer function, such as a `stabilize_*`
#'   function ([stabilize_chr()], etc) or a function produced by a `specify_*()`
#'   function ([specify_chr()], etc), or `NULL` to disallow extra named
#'   elements.
#' @param nms `(character)` Result of `rlang::names2(.x)`.
#'
#' @name .shared-params-lst
#' @keywords internal
NULL

## functions ----

#' Resolve a `.named`/`.unnamed`-style extra-element control argument
#'
#' Normalizes the three accepted forms of an extra-element control argument
#' (`NULL`/`FALSE` to forbid, `TRUE` to allow unchecked, or a stabilizer
#' function to validate) into either `NULL` (forbid), `TRUE` (allow), or the
#' stabilizer function (validate).
#'
#' @param control `NULL`, `TRUE`, `FALSE`, or a stabilizer function.
#' @param control_arg (`character(1)`) Name of the argument being resolved, used
#'   in error messages if `control` can't be converted to logical.
#' @inheritParams .shared-params
#' @returns `NULL`, `TRUE`, or a stabilizer function.
#' @keywords internal
.resolve_extra_control <- function(control, control_arg, call) {
  if (is.function(control)) {
    return(control)
  }
  control <- to_lgl_scalar(
    control,
    allow_null = TRUE,
    x_arg = control_arg,
    call = call
  )
  if (isTRUE(control)) {
    return(TRUE)
  }
  NULL
}

#' Call a spec function with properly-named context arguments
#'
#' @param spec_fn A stabilizer function.
#' @param .x The value to validate.
#' @param .to_arg,.x_class Optional `to_arg` and `x_class` values, passed on
#'   only when `spec_fn` accepts them and they are not `NULL`.
#' @inheritParams stabilize_lst
#' @returns The validated value.
#' @keywords internal
.call_specified_fn <- function(
  spec_fn,
  .x,
  .x_arg,
  .call,
  .to_arg = NULL,
  .x_class = NULL
) {
  fmls <- rlang::fn_fmls_names(spec_fn)
  x_arg_nm <- grep("^[.]?x_arg$", fmls, value = TRUE)
  call_nm <- grep("^[.]?call$", fmls, value = TRUE)
  args <- list(.x)
  # Only forwarded when supplied, so specs keep their own defaults otherwise.
  if (!is.null(.to_arg) && "to_arg" %in% fmls) {
    args[["to_arg"]] <- .to_arg
  }
  if (!is.null(.x_class) && "x_class" %in% fmls) {
    args[["x_class"]] <- .x_class
  }
  if (length(x_arg_nm)) {
    args[[x_arg_nm[[1L]]]] <- .x_arg
  }
  if (length(call_nm)) {
    args[[call_nm[[1L]]]] <- .call
  }
  do.call(spec_fn, args)
}

#' Validate all named elements (required and extra)
#'
#' @inheritParams stabilize_lst
#' @returns The updated list.
#' @keywords internal
.validate_named_elements <- function(
  .x,
  ...,
  .patterns,
  .named,
  .required,
  .allow_duplicate_names,
  .x_arg,
  .call
) {
  .check_duplicate_names(
    .x,
    .allow_duplicate_names,
    .x_arg = .x_arg,
    .call = .call
  )
  element_specs <- list(...)
  nms <- rlang::names2(.x)
  .check_required_present(
    .required,
    present = nms,
    noun = "element",
    x_arg = .x_arg,
    call = .call
  )
  matches <- .match_patterns(nms, .patterns)
  is_matched <- rowSums(matches) > 0L
  is_extra_named <- .find_extra_named(
    .x,
    nms,
    spec_names = names(element_specs),
    is_matched = is_matched,
    named = .named,
    required = .required
  )
  .x <- .validate_specified_elements(
    .x,
    element_specs,
    nms,
    skip = is_matched,
    .x_arg = .x_arg,
    .call = .call
  )
  .x <- .validate_pattern_elements(
    .x,
    nms,
    element_specs,
    .patterns,
    matches,
    .x_arg = .x_arg,
    .call = .call
  )
  .x <- .validate_extra_named_elements(
    .x,
    nms,
    is_extra_named,
    named_spec = .named,
    .x_arg = .x_arg,
    .call = .call
  )
  .x
}

#' Validate named elements against their spec functions
#'
#' @inheritParams stabilize_lst
#' @inheritParams .shared-params-lst
#' @returns The updated list.
#' @keywords internal
.validate_specified_elements <- function(
  .x,
  element_specs,
  nms,
  skip = rep(FALSE, length(nms)),
  .x_arg,
  .call
) {
  for (nm in names(element_specs)) {
    all_positions <- which(nms == nm)
    positions <- setdiff(all_positions, which(skip))
    if (!length(positions)) {
      next
    }
    for (i in positions) {
      element_arg <- .element_arg(
        .x_arg,
        nm,
        i,
        is_ambiguous = length(all_positions) > 1L
      )
      .x[[i]] <- .call_specified_fn(
        element_specs[[nm]],
        .x[[i]],
        .x_arg = element_arg,
        .call = .call
      )
    }
  }
  .x
}

#' Build the `x_arg` label for one element of a list
#'
#' Uses the element name when unambiguous; falls back to position for
#' duplicated names.
#'
#' @param nm `(character(1))` The element's name.
#' @param position `(integer(1))` The element's position.
#' @param is_ambiguous `(logical(1))` Is `nm` shared with other elements?
#' @inheritParams stabilize_lst
#' @returns `(character(1))` The label, such as `x[["a"]]` or `x[[2]]`.
#' @keywords internal
.element_arg <- function(.x_arg, nm, position, is_ambiguous) {
  nm_arg <- if (is_ambiguous) position else deparse(nm)
  paste0(.x_arg, "[[", nm_arg, "]]")
}

#' Find extra named elements
#'
#' Extra named elements are named, have no exact spec, and match no pattern.
#' When `named` is `NULL` or `FALSE`, names in `required` that lack a spec are
#' known (but unchecked), so they are not extra.
#'
#' @param spec_names `(character)` Names of the exact specs.
#' @param is_matched `(logical)` Element-wise indicator of elements matching
#'   any pattern.
#' @param named The `.named` argument.
#' @param required The normalized `.required` argument.
#' @inheritParams stabilize_lst
#' @inheritParams .shared-params-lst
#' @returns `(logical)` Element-wise indicator of extra named positions.
#' @keywords internal
.find_extra_named <- function(
  .x,
  nms,
  spec_names,
  is_matched,
  named,
  required
) {
  is_extra_named <- rlang::have_name(.x) & !(nms %in% spec_names) & !is_matched
  if (is.null(named) || isFALSE(named)) {
    is_extra_named <- is_extra_named &
      !(nms %in% setdiff(.required_names(required), spec_names))
  }
  is_extra_named
}

#' Validate or reject unnamed elements
#'
#' @inheritParams stabilize_lst
#' @returns The updated list.
#' @keywords internal
.validate_unnamed_elements <- function(.x, .unnamed, .x_arg, .call) {
  is_unnamed <- !rlang::have_name(.x)
  if (!any(is_unnamed)) {
    return(.x)
  }
  .unnamed <- .resolve_extra_control(.unnamed, ".unnamed", .call)
  if (isTRUE(.unnamed)) {
    return(.x)
  }
  if (is.null(.unnamed)) {
    .abort_unnamed(which(is_unnamed), .x_arg, .call)
  }
  for (i in which(is_unnamed)) {
    .x[[i]] <- .call_specified_fn(
      .unnamed,
      .x[[i]],
      .x_arg = paste0(.x_arg, "[[", i, "]]"),
      .call = .call
    )
  }
  .x
}

#' Abort because unnamed elements are not allowed
#'
#' @param unnamed_positions `(integer)` Positions of the unnamed elements.
#' @inheritParams stabilize_lst
#' @returns Does not return; always signals an error.
#' @keywords internal
.abort_unnamed <- function(unnamed_positions, .x_arg, .call) {
  .stop_must(
    "must not contain unnamed elements.",
    x_arg = .x_arg,
    additional_msg = c(
      x = format_inline(
        "Unnamed position{?s}: {as.character(unnamed_positions)}"
      )
    ),
    call = .call,
    subclass = "bad_unnamed",
    message_env = rlang::current_env()
  )
}

#' Abort because extra named elements are not allowed
#'
#' @param extra_names `(character)` Names of the extra elements.
#' @inheritParams stabilize_lst
#' @returns Does not return; always signals an error.
#' @keywords internal
.abort_extra_named <- function(extra_names, .x_arg, .call) {
  .stop_must(
    "must not contain extra named elements.",
    x_arg = .x_arg,
    additional_msg = c(
      x = format_inline("Extra element{?s}: {.val {extra_names}}")
    ),
    call = .call,
    subclass = "bad_named",
    message_env = rlang::current_env()
  )
}

#' Validate or reject extra named elements
#'
#' @inheritParams stabilize_lst
#' @inheritParams .shared-params-lst
#' @returns The updated list.
#' @keywords internal
.validate_extra_named_elements <- function(
  .x,
  nms,
  is_extra_named,
  named_spec,
  .x_arg,
  .call
) {
  if (!any(is_extra_named)) {
    return(.x)
  }
  named_spec <- .resolve_extra_control(named_spec, ".named", .call)
  if (isTRUE(named_spec)) {
    return(.x)
  }
  if (is.null(named_spec)) {
    .abort_extra_named(unique(nms[is_extra_named]), .x_arg, .call)
  }
  dup_extra_nms <- nms[is_extra_named][duplicated(nms[is_extra_named])]
  for (i in which(is_extra_named)) {
    element_arg <- .element_arg(
      .x_arg,
      nms[[i]],
      i,
      is_ambiguous = nms[[i]] %in% dup_extra_nms
    )
    .x[[i]] <- .call_specified_fn(
      named_spec,
      .x[[i]],
      .x_arg = element_arg,
      .call = .call
    )
  }
  .x
}

#' Check for duplicate names in a list
#'
#' @inheritParams stabilize_lst
#' @returns `NULL`, invisibly, if the check passes.
#' @keywords internal
.check_duplicate_names <- function(.x, .allow_duplicate_names, .x_arg, .call) {
  .allow_duplicate_names <- to_lgl_scalar(.allow_duplicate_names, call = .call)
  if (.allow_duplicate_names) {
    return(invisible(NULL))
  }
  nms <- rlang::names2(.x)
  named_nms <- nms[nms != ""]
  if (!anyDuplicated(named_nms)) {
    return(invisible(NULL))
  }
  dup_names <- unique(named_nms[duplicated(named_nms)])
  .stop_must(
    "must not contain duplicate names.",
    x_arg = .x_arg,
    additional_msg = c(
      x = format_inline("Duplicate name{?s}: {.val {dup_names}}")
    ),
    call = .call,
    subclass = "duplicate_names",
    message_env = rlang::current_env()
  )
}

#' Check that all elements of a spec list are named
#'
#' @inheritParams stabilize_lst
#' @returns `NULL`, invisibly, if all elements are named.
#' @keywords internal
.check_specs_named <- function(..., .call = caller_env()) {
  if (!...length()) {
    return(invisible(NULL))
  }

  specs <- list(...)
  nms <- names(specs) %||% character(length(specs))
  if (any(nms == "")) {
    .stbl_abort(
      c(
        "All elements passed via `...` must be named.",
        i = "Each name corresponds to a required element in the list."
      ),
      subclass = "unnamed_spec",
      call = .call
    )
  }
  invisible(NULL)
}
