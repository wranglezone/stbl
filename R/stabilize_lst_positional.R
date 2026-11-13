#' Ensure a list meets positional (tuple) expectations
#'
#' `stabilize_lst_positional()` validates a list as a tuple: the *i*th spec in
#' `...` is applied to the *i*th element of `.x`. Elements after the last spec
#' are controlled by `.additional`. This mirrors JSON Schema's `prefixItems`
#' (with `.additional` playing the role of `items`). Failures at every position
#' are collected and reported together. `stabilise_lst_positional()`,
#' `stabilize_list_positional()`, `stabilise_list_positional()`,
#' `stabilize_tuple()`, and `stabilise_tuple()` are synonyms.
#'
#' @param ... Unnamed stabilizer functions, such as `stabilize_*` functions
#'   ([stabilize_chr()], etc), `to_*` functions, or functions produced by
#'   `specify_*()` functions ([specify_chr()], etc). The *i*th function
#'   validates the *i*th element of `.x`. At least one function is required.
#' @param .additional Controls how elements of `.x` after the last spec in
#'   `...` are handled. One of:
#'   - `NULL` or `FALSE` (default): any extra elements cause an error.
#'   - `TRUE`: extra elements are allowed, unchecked.
#'   - A single stabilizer function, used to validate every extra element.
#' @param .n_required `(integer(1))` The number of leading positions that must
#'   be present in `.x`. Defaults to all of them. Must be between 0 and the
#'   number of specs. A zero-length `.x` (such as `list()`) skips this check
#'   when `.allow_zero_length = TRUE`. This is independent of `.min_size` and
#'   `.max_size`, which check the total length.
#' @inheritParams .shared-params
#'
#' @returns The validated list (or an atomic vector when `.simplify = TRUE` and
#'   simplification is possible), or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-bad_null>` for `NULL` values when `.allow_null = FALSE`.
#'   - `<stbl-error-coerce-list>` when `.x` cannot be converted to a list.
#'   - `<stbl-error-bad_function>` for functions when `.coerce_function =
#'   FALSE` (the default).
#'   - `<stbl-error-size_too_small>` when the list is shorter than `.min_size`.
#'   - `<stbl-error-size_too_large>` when the list is longer than `.max_size`.
#'   - `<stbl-error-empty_specs>` when no specs are provided.
#'   - `<stbl-error-named_spec>` when any spec passed through `...` is named.
#'   - `<stbl-error-bad_n_required>` when `.n_required` is out of range.
#'   - `<stbl-error-bad_named>` when `.x` has named elements.
#'   - `<stbl-error-missing_element>` when `.x` has fewer than `.n_required`
#'   elements.
#'   - `<stbl-error-bad_additional>` when extra elements are present but
#'   `.additional` is `NULL` or `FALSE`.
#'   - `<stbl-error-cant_stabilize_positional>` when any element fails its
#'   spec; the condition's `locations` element gives the positions that failed.
#'   - `<stbl-error-duplicate_elements>` when `.unique = TRUE` and duplicate
#'   elements are present.
#' @family list functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' # [lon, lat]
#' stabilize_lst_positional(
#'   list(-122.4, 37.8),
#'   stabilize_dbl_scalar,
#'   stabilize_dbl_scalar
#' )
#'
#' # An address tuple: [number, street, street type, direction]
#' stabilize_lst_positional(
#'   list(1600, "Pennsylvania", "Avenue", "NW"),
#'   specify_dbl_scalar(),
#'   specify_chr_scalar(),
#'   specify_chr_scalar(allowed_values = c("Street", "Avenue", "Boulevard")),
#'   specify_chr_scalar(allowed_values = c("NW", "NE", "SW", "SE"))
#' )
#'
#' # Trailing positions can be optional
#' stabilize_lst_positional(
#'   list(1600, "Pennsylvania"),
#'   specify_dbl_scalar(),
#'   specify_chr_scalar(),
#'   specify_chr_scalar(),
#'   .n_required = 2
#' )
#'
#' # Allow and validate extra elements
#' stabilize_lst_positional(
#'   list("a", 1L, 2L, 3L),
#'   stabilize_chr_scalar,
#'   .additional = stabilize_int_scalar
#' )
#'
#' # Simplify to an atomic vector when possible
#' stabilize_lst_positional(
#'   list(1.5, 2L),
#'   stabilize_dbl_scalar,
#'   stabilize_int_scalar,
#'   .simplify = TRUE
#' )
#'
#' # Every failing position is reported
#' try(
#'   stabilize_lst_positional(
#'     list("a", "b", "c"),
#'     stabilize_chr_scalar,
#'     stabilize_int_scalar,
#'     stabilize_lgl_scalar
#'   )
#' )
stabilize_lst_positional <- function(
  .x,
  ...,
  .additional = NULL,
  .n_required = ...length(),
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .simplify = FALSE,
  .coerce_function = FALSE,
  .x_arg = caller_arg(.x),
  .call = caller_env(),
  .x_class = object_type(.x)
) {
  force(.x_arg)
  force(.call)
  specs <- list(...)
  .check_specs_not_empty(specs, .call = .call)
  .check_specs_unnamed(specs, .call = .call)
  .simplify <- to_lgl_scalar(.simplify, x_arg = ".simplify", call = .call)
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
  .allow_zero_length <- to_lgl_scalar(.allow_zero_length, call = .call)
  if (!length(.x) && .allow_zero_length) {
    return(.x)
  }
  .n_required <- .check_n_required(.n_required, length(specs), call = .call)
  .check_positional_shape(
    .x,
    n_specs = length(specs),
    n_required = .n_required,
    additional = .additional,
    x_arg = .x_arg,
    call = .call
  )
  .x <- .validate_positional_elements(
    .x,
    specs = specs,
    additional = .additional,
    x_arg = .x_arg,
    x_class = .x_class,
    call = .call
  )
  # Run after validation so converted values are compared.
  .check_unique(.x, unique = .unique, x_arg = .x_arg, call = .call)

  .simplify_each(.x, simplify = .simplify)
}

#' @export
#' @rdname stabilize_lst_positional
stabilise_lst_positional <- stabilize_lst_positional

#' @export
#' @rdname stabilize_lst_positional
stabilize_list_positional <- stabilize_lst_positional

#' @export
#' @rdname stabilize_lst_positional
stabilise_list_positional <- stabilize_lst_positional

#' @export
#' @rdname stabilize_lst_positional
stabilize_tuple <- stabilize_lst_positional

#' @export
#' @rdname stabilize_lst_positional
stabilise_tuple <- stabilize_lst_positional

# helpers ----

#' Check that `.n_required` is a valid count of required positions
#'
#' @param n_specs `(integer(1))` The number of specs.
#' @inheritParams stabilize_lst_positional
#' @param call `(environment)` The environment for errors.
#' @returns `.n_required` as an integer.
#' @keywords internal
.check_n_required <- function(.n_required, n_specs, call) {
  .n_required <- to_int_scalar(
    .n_required,
    x_arg = ".n_required",
    allow_na = FALSE,
    call = call
  )
  n_given <- .n_required
  if (.n_required < 0L || .n_required > n_specs) {
    .stbl_abort(
      c(
        "{.arg .n_required} must be between 0 and the number of specs.",
        x = "{.arg .n_required} is {.val {n_given}}.",
        i = "There {?is/are} {n_specs} spec{?s}."
      ),
      subclass = "bad_n_required",
      call = call,
      message_env = rlang::current_env()
    )
  }
  .n_required
}

#' Check names, required positions, and extra elements of a tuple
#'
#' @inheritParams stabilize_lst_positional
#' @inheritParams .check_n_required
#' @param n_required `(integer(1))` The validated `.n_required`.
#' @param additional The `.additional` argument.
#' @param x_arg `(character(1))` The name of `.x`, for error messages.
#' @returns `NULL`, invisibly, if the checks pass.
#' @keywords internal
.check_positional_shape <- function(
  .x,
  n_specs,
  n_required,
  additional,
  x_arg,
  call
) {
  if (any(rlang::have_name(.x))) {
    named_positions <- which(rlang::have_name(.x))
    .stop_must(
      "must not contain named elements.",
      x_arg = x_arg,
      additional_msg = c(
        x = format_inline(
          "Named position{?s}: {as.character(named_positions)}"
        )
      ),
      call = call,
      subclass = "bad_named",
      message_env = rlang::current_env()
    )
  }
  if (length(.x) < n_required) {
    n_actual <- length(.x)
    .stop_must(
      "must contain at least {n_required} element{?s}.",
      x_arg = x_arg,
      additional_msg = c(x = "{.arg {x_arg}} has {n_actual}."),
      call = call,
      subclass = "missing_element",
      message_env = rlang::current_env()
    )
  }
  if (length(.x) <= n_specs) {
    return(invisible(NULL))
  }
  additional <- .resolve_extra_control(additional, ".additional", call)
  if (is.null(additional)) {
    extra_positions <- seq.int(n_specs + 1L, length(.x))
    .stop_must(
      "must not contain more than {n_specs} element{?s}.",
      x_arg = x_arg,
      additional_msg = c(
        x = format_inline(
          "Extra position{?s}: {as.character(extra_positions)}"
        )
      ),
      call = call,
      subclass = "bad_additional",
      message_env = rlang::current_env()
    )
  }
  invisible(NULL)
}

#' Apply each positional spec, collecting every failure
#'
#' @inheritParams .check_positional_shape
#' @param specs `(list)` The positional specs.
#' @param x_class `(character)` The class of `.x`, for error messages.
#' @returns The updated list.
#' @keywords internal
.validate_positional_elements <- function(
  .x,
  specs,
  additional,
  x_arg,
  x_class,
  call
) {
  additional <- .resolve_extra_control(additional, ".additional", call)
  n_specs <- length(specs)
  errors <- list()
  locations <- integer()
  for (i in seq_along(.x)) {
    spec <- if (i <= n_specs) specs[[i]] else additional
    if (!is.function(spec)) {
      next
    }
    result <- rlang::try_fetch(
      .call_specified_fn(
        spec,
        .x[[i]],
        .x_arg = paste0(x_arg, "[[", i, "]]"),
        .call = call
      ),
      error = function(cnd) cnd
    )
    if (inherits(result, "error")) {
      errors[[length(errors) + 1L]] <- result
      locations <- c(locations, i)
    } else {
      # Assigning NULL would delete the element.
      .x[i] <- list(result)
    }
  }
  if (length(locations)) {
    .stop_cant_stabilize_positional(
      errors = errors,
      locations = locations,
      x_arg = x_arg,
      x_class = x_class,
      call = call
    )
  }
  .x
}

#' Signal a combined error when any position fails its spec
#'
#' @inheritParams .stop_cant_stabilize_each
#' @returns Does not return; throws an error.
#' @keywords internal
.stop_cant_stabilize_positional <- function(
  errors,
  locations,
  x_arg,
  x_class,
  call
) {
  msgs <- vapply(errors, .extract_stabilizer_msg, character(1L))
  additional_msg <- stats::setNames(
    paste0("Position ", locations, ": ", msgs),
    rep("x", length(msgs))
  )
  .stop_must(
    msg = "{.cls {x_class}} must satisfy the spec at every position.",
    x_arg = x_arg,
    additional_msg = additional_msg,
    call = call,
    subclass = "cant_stabilize_positional",
    message_env = rlang::current_env(),
    locations = locations
  )
}
