#' Ensure a list argument meets expectations
#'
#' `stabilize_lst()` validates the structure and contents of a list. It can
#' check that specific named elements are present and valid, that extra named
#' elements conform to a shared rule, and that unnamed elements conform to a
#' shared rule. `stabilise_lst()`, `stabilize_list()`, and `stabilise_list()`
#' are synonyms of `stabilize_lst()`.
#'
#' @param ... Named [`specify_*()`][specify_chr] functions for required named
#'   elements of `.x`. Each name corresponds to a required element in `.x`, and
#'   the function is used to validate that element.
#' @param .named A single [`specify_*()`][specify_chr] function to validate all
#'   named elements of `.x` that are *not* explicitly listed in `...`. If `NULL`
#'   (default), any extra named elements will cause an error.
#' @param .unnamed A single [`specify_*()`][specify_chr] function to validate
#'   all unnamed elements of `.x`. If `NULL` (default), any unnamed elements
#'   will cause an error.
#' @param .allow_duplicate_names `(length-1 logical)` Should `.x` be allowed to
#'   have duplicate names? If `FALSE` (default), an error is thrown when any
#'   named element of `.x` shares a name with another.
#' @param .x_arg `(length-1 character)` An argument name for `.x`. The automatic
#'   value will work in most cases, or pass it through from higher-level
#'   functions to make error messages clearer in unexported functions.
#' @param .x_class `(length-1 character)` The class name of `.x` to use in error
#'   messages. Use this if you remove a special class from `.x` before checking
#'   its coercion, but want the error message to match the original class.
#' @inheritParams .shared-params
#'
#' @returns The validated list.
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
#' # Allow any non-NULL element with stabilize_present
#' stabilize_lst(list(data = mtcars), data = stabilize_present)
#'
#' # Allow extra named elements via .named
#' stabilize_lst(
#'   list(a = 1L, b = 2L, c = 3L),
#'   .named = specify_int_scalar()
#' )
#'
#' # Allow unnamed elements via .unnamed
#' stabilize_lst(list(1L, 2L, 3L), .unnamed = specify_int_scalar())
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
stabilize_lst <- function(
  .x,
  ...,
  .named = NULL,
  .unnamed = NULL,
  .allow_duplicate_names = FALSE,
  .allow_null = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .x_arg = caller_arg(.x),
  .call = caller_env(),
  .x_class = object_type(.x)
) {
  force(.x_arg)
  force(.call)
  if (is.null(.x)) {
    return(.to_null(.x, allow_null = .allow_null, x_arg = .x_arg, call = .call))
  }
  .x <- to_lst(.x, x_arg = .x_arg, call = .call)
  .check_size(
    .x,
    min_size = .min_size,
    max_size = .max_size,
    x_arg = .x_arg,
    call = .call
  )

  .check_specs_named(..., call = .call)
  .x <- .validate_named_elements(
    .x,
    ...,
    .named = .named,
    .allow_duplicate_names = .allow_duplicate_names,
    x_arg = .x_arg,
    call = .call
  )
  .x <- .validate_unnamed_elements(
    .x,
    .unnamed = .unnamed,
    x_arg = .x_arg,
    call = .call
  )

  return(.x)
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

#' Validate all named elements (required and extra)
#'
#' Computes element name metadata and delegates to
#' `.validate_required_elements()` and `.validate_extra_named_elements()`.
#'
#' @param .x `(list)` The list being validated.
#' @param ... Named spec functions for required elements (forwarded from
#'   `stabilize_lst()`).
#' @inheritParams stabilize_lst
#' @inheritParams .shared-params
#'
#' @returns The updated list.
#' @keywords internal
.validate_named_elements <- function(
  .x,
  ...,
  .named,
  .allow_duplicate_names,
  x_arg,
  call
) {
  if (!any(rlang::have_name(.x))) {
    return(.x)
  }
  .check_duplicate_names(.x, .allow_duplicate_names, x_arg = x_arg, call = call)
  element_specs <- list(...)
  nms <- rlang::names2(.x)
  is_extra_named <- rlang::have_name(.x) & !(nms %in% names(element_specs))
  .x <- .validate_required_elements(
    .x,
    element_specs,
    nms,
    x_arg = x_arg,
    call = call
  )
  .x <- .validate_extra_named_elements(
    .x,
    nms,
    is_extra_named,
    named_spec = .named,
    x_arg = x_arg,
    call = call
  )
  .x
}

#' Validate required named elements against their spec functions
#'
#' For each name in `element_specs`, checks that the element exists in `.x` and
#' then applies its spec function in place.
#'
#' @param .x `(list)` The list being validated.
#' @param element_specs `(list)` Named list of spec functions from `...`.
#' @param nms `(character)` Result of `rlang::names2(.x)`.
#' @inheritParams .shared-params
#'
#' @returns The updated list.
#' @keywords internal
.validate_required_elements <- function(.x, element_specs, nms, x_arg, call) {
  for (nm in names(element_specs)) {
    positions <- which(nms == nm)
    if (!length(positions)) {
      .stop_must(
        "must contain element {.val {nm}}.",
        x_arg = x_arg,
        call = call,
        subclass = "missing_element",
        message_env = rlang::current_env()
      )
    }
    for (i in positions) {
      # Use name-based path when unambiguous; fall back to position for
      # duplicates
      nm_arg <- if (length(positions) == 1L) deparse(nm) else i
      element_arg <- paste0(x_arg, "[[", nm_arg, "]]")
      .x[[i]] <- element_specs[[nm]](.x[[i]], x_arg = element_arg, call = call)
    }
  }
  .x
}

#' Validate or reject unnamed elements
#'
#' If unnamed elements exist and `unnamed_spec` is `NULL`, throws an error
#' reporting their positions. Otherwise applies `unnamed_spec` to each.
#'
#' @param .x `(list)` The list being validated.
#' @inheritParams stabilize_lst
#' @inheritParams .shared-params
#'
#' @returns The updated list.
#' @keywords internal
.validate_unnamed_elements <- function(.x, .unnamed, x_arg, call) {
  is_unnamed <- !rlang::have_name(.x)
  if (!any(is_unnamed)) {
    return(.x)
  }
  if (is.null(.unnamed)) {
    unnamed_positions <- which(is_unnamed)
    .stop_must(
      "must not contain unnamed elements.",
      x_arg = x_arg,
      additional_msg = c(
        x = format_inline(
          "Unnamed position{?s}: {as.character(unnamed_positions)}"
        )
      ),
      call = call,
      subclass = "bad_unnamed",
      message_env = rlang::current_env()
    )
  }
  for (i in which(is_unnamed)) {
    element_arg <- paste0(x_arg, "[[", i, "]]")
    .x[[i]] <- .unnamed(.x[[i]], x_arg = element_arg, call = call)
  }
  .x
}

#' Validate or reject extra named elements
#'
#' Extra named elements are those not listed in `...` (i.e. `is_extra_named` is
#' `TRUE`). If `named_spec` is `NULL`, throws an error reporting their names.
#' Otherwise applies `named_spec` to each.
#'
#' @param .x `(list)` The list being validated.
#' @param nms `(character)` Result of `rlang::names2(.x)`.
#' @param is_extra_named `(logical)` Element-wise indicator of extra named
#'   positions.
#' @param named_spec A spec function, or `NULL` to disallow extra named
#'   elements.
#' @inheritParams .shared-params
#'
#' @returns The updated list.
#' @keywords internal
.validate_extra_named_elements <- function(
  .x,
  nms,
  is_extra_named,
  named_spec,
  x_arg,
  call
) {
  if (!any(is_extra_named)) {
    return(.x)
  }
  if (is.null(named_spec)) {
    extra_names <- unique(nms[is_extra_named])
    .stop_must(
      "must not contain extra named elements.",
      x_arg = x_arg,
      additional_msg = c(
        x = format_inline("Extra element{?s}: {.val {extra_names}}")
      ),
      call = call,
      subclass = "bad_named",
      message_env = rlang::current_env()
    )
  }
  dup_extra_nms <- nms[is_extra_named][duplicated(nms[is_extra_named])]
  for (i in which(is_extra_named)) {
    nm <- nms[[i]]
    # Use name-based path when unambiguous; fall back to position for duplicates
    nm_arg <- if (!nm %in% dup_extra_nms) deparse(nm) else i
    element_arg <- paste0(x_arg, "[[", nm_arg, "]]")
    .x[[i]] <- named_spec(.x[[i]], x_arg = element_arg, call = call)
  }
  .x
}

#' Check for duplicate names in a list
#'
#' If `.allow_duplicate_names` is `FALSE`, throws an error when any named
#' element of `.x` shares a name with another named element.
#'
#' @param .x `(list)` The list being validated.
#' @inheritParams stabilize_lst
#' @inheritParams .shared-params
#'
#' @returns `NULL`, invisibly, if the check passes.
#' @keywords internal
.check_duplicate_names <- function(.x, .allow_duplicate_names, x_arg, call) {
  .allow_duplicate_names <- to_lgl_scalar(.allow_duplicate_names, call = call)
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
    x_arg = x_arg,
    additional_msg = c(
      x = format_inline("Duplicate name{?s}: {.val {dup_names}}")
    ),
    call = call,
    subclass = "duplicate_names",
    message_env = rlang::current_env()
  )
}

#' Check that all elements of a spec list are named
#'
#' @param ... Spec functions forwarded from `stabilize_lst()`.
#' @inheritParams .shared-params
#'
#' @returns `NULL`, invisibly, if all elements are named.
#' @keywords internal
.check_specs_named <- function(..., call = caller_env()) {
  specs <- list(...)
  if (!length(specs)) {
    return(invisible(NULL))
  }
  nms <- names(specs) %||% character(length(specs))
  if (any(nms == "")) {
    pkg_abort(
      "stbl",
      message = c(
        "All elements passed via `...` must be named.",
        i = "Each name corresponds to a required element in the list."
      ),
      subclass = "unnamed_spec",
      call = call
    )
  }
  invisible(NULL)
}
