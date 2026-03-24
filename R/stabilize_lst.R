#' Ensure a list argument meets expectations
#'
#' @description `stabilize_lst()` validates the structure and contents of a
#'   list. It can check that specific named elements are present and valid, that
#'   unnamed elements conform to a shared rule, and that extra named elements
#'   conform to a shared rule. `stabilise_lst()`, `stabilize_list()`, and
#'   `stabilise_list()` are synonyms of `stabilize_lst()`.
#'
#' @param x The list to validate.
#' @param ... Named [`specify_*()`][specify_chr] functions for required named
#'   elements of `x`. Each name corresponds to a required element in `x`, and
#'   the function is used to validate that element.
#' @param .named A single [`specify_*()`][specify_chr] function to validate all
#'   named elements of `x` that are *not* explicitly listed in `...`. If `NULL`
#'   (default), any extra named elements will cause an error.
#' @param .unnamed A single [`specify_*()`][specify_chr] function to validate
#'   all unnamed elements of `x`. If `NULL` (default), any unnamed elements
#'   will cause an error.
#' @param .allow_null `(length-1 logical)` Is `NULL` an acceptable value?
#'   Defaults to `TRUE`.
#' @param .min_size `(length-1 integer)` The minimum size of the list. Tested
#'   using [vctrs::vec_size()].
#' @param .max_size `(length-1 integer)` The maximum size of the list. Tested
#'   using [vctrs::vec_size()].
#' @param .x_arg `(length-1 character)` An argument name for `x`. The automatic
#'   value will work in most cases, or pass it through from higher-level
#'   functions to make error messages clearer in unexported functions.
#' @param .call `(environment)` The execution environment to mention as the
#'   source of error messages.
#' @param .x_class `(length-1 character)` The class name of `x` to use in error
#'   messages. Use this if you remove a special class from `x` before checking
#'   its coercion, but want the error message to match the original class.
#' @param .element_specs `(named list)` For internal use by [specify_lst()].
#'   A named list of element specification functions that is merged with the
#'   specifications provided via `...`.
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
#' # Allow any non-NULL element with specify_present()
#' stabilize_lst(list(data = mtcars), data = specify_present())
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
stabilize_lst <- function(
  x,
  ...,
  .named = NULL,
  .unnamed = NULL,
  .allow_null = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .x_arg = caller_arg(x),
  .call = caller_env(),
  .x_class = object_type(x),
  .element_specs = NULL
) {
  force(.x_arg)
  force(.call)

  if (is.null(x)) {
    return(.to_null(x, allow_null = .allow_null, x_arg = .x_arg, call = .call))
  }

  x <- to_lst(x, x_arg = .x_arg, call = .call)

  .check_size(
    x,
    min_size = .min_size,
    max_size = .max_size,
    x_arg = .x_arg,
    call = .call
  )

  element_specs <- c(.element_specs, list(...))
  .check_specs_named(element_specs, call = .call)

  required_names <- names(element_specs)
  nms <- names(x) %||% character(length(x))
  is_unnamed <- nms == ""
  is_extra_named <- !is_unnamed & !(nms %in% required_names)

  for (nm in required_names) {
    if (!nm %in% nms) {
      .stop_must(
        "must contain element {.val {nm}}.",
        x_arg = .x_arg,
        call = .call,
        subclass = "missing_element",
        message_env = rlang::current_env()
      )
    }
    element_arg <- paste0(.x_arg, "$", nm)
    x[[nm]] <- element_specs[[nm]](x[[nm]], x_arg = element_arg, call = .call)
  }

  if (any(is_unnamed)) {
    if (is.null(.unnamed)) {
      unnamed_positions <- which(is_unnamed)
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
    } else {
      for (i in which(is_unnamed)) {
        element_arg <- paste0(.x_arg, "[[", i, "]]")
        x[[i]] <- .unnamed(x[[i]], x_arg = element_arg, call = .call)
      }
    }
  }

  if (any(is_extra_named)) {
    if (is.null(.named)) {
      extra_names <- nms[is_extra_named]
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
    } else {
      for (nm in nms[is_extra_named]) {
        element_arg <- paste0(.x_arg, "$", nm)
        x[[nm]] <- .named(x[[nm]], x_arg = element_arg, call = .call)
      }
    }
  }

  return(x)
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

#' Check that all elements of a spec list are named
#'
#' @param specs `(list)` A named list of specification functions from `...`.
#' @inheritParams .shared-params
#'
#' @returns `NULL`, invisibly, if all elements are named.
#' @keywords internal
.check_specs_named <- function(specs, call = caller_env()) {
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
