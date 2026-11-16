#' Ensure a data frame meets expectations
#'
#' `stabilize_df()` validates the structure and contents of a data frame. It can
#' check that specific named columns are present and valid, that extra columns
#' conform to a shared rule, that required column names are present, and that
#' the row count is within specified bounds. `stabilise_df()`,
#' `stabilize_data_frame()`, and `stabilise_data_frame()` are synonyms of
#' `stabilize_df()`.
#'
#' @param ... Named stabilizer functions, such as `stabilize_*` functions
#'   ([stabilize_chr()], etc) or functions produced by `specify_*()` functions
#'   ([specify_chr()], etc). Each name corresponds to a column in `.x`, and the
#'   function is used to validate that column when present. Whether the column
#'   is required is controlled by `.required`.
#' @param .extra_cols Controls how columns of `.x` that are *not* explicitly
#'   listed in `...` are handled. One of:
#'   - `NULL` (default): any extra columns cause an error. Names in `.required`
#'   that have no spec in `...` are allowed, unchecked.
#'   - `FALSE`: any extra columns cause an error, and every name in `.required`
#'   must have a spec in `...`.
#'   - `TRUE`: extra columns are allowed, unchecked.
#'   - A single stabilizer function, such as a `stabilize_*` function
#'   ([stabilize_chr()], etc) or a function produced by a `specify_*()` function
#'   ([specify_chr()], etc), used to validate every extra column.
#' @param .col_names `r lifecycle::badge("deprecated")` Use `.required`
#'   instead.
#' @param .min_rows (`integer(1)`) The minimum number of rows allowed in `.x`.
#'   If `NULL` (default), the row count is not checked.
#' @param .max_rows (`integer(1)`) The maximum number of rows allowed in `.x`.
#'   If `NULL` (default), the row count is not checked.
#' @param .required `(character or list)` Names of columns that must be present
#'   in `.x`. Defaults to all names in `...`, so every named spec is required
#'   unless you opt it out. A supplied `.required` *replaces* that default, so
#'   `.required = list(card = "address")` makes every other spec optional; list
#'   the unconditional names explicitly. Specs for names that are not required
#'   are optional: if absent, no error is raised; if present, they're validated
#'   normally. Pass `NULL` or `character()` to make every named spec optional.
#'   Every name in `.required` is enforced, whether or not it has a spec in
#'   `...` (see `.extra_cols`). A `.x` with zero columns skips this check when
#'   `.allow_zero_length = TRUE` (the default). See `required` in
#'   [stabilize_names)()] for details on expressing conditional requirements.
#' @inheritParams .shared-params
#'
#' @returns The validated data frame, or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-bad_null>` for `NULL` values when `.allow_null = FALSE`.
#'   - `<stbl-error-coerce-data.frame>` when `.x` cannot be converted to a data
#'   frame.
#'   - `<stbl-error-jagged>` when list input has incompatible element lengths
#'   for conversion to a data frame.
#'   - `<stbl-error-too_few_rows>` when the data frame has fewer than
#'   `.min_rows` rows.
#'   - `<stbl-error-too_many_rows>` when the data frame has more than
#'   `.max_rows` rows.
#'   - `<stbl-error-missing_cols>` when required names in `.col_names` are
#'   absent.
#'   - `<stbl-error-bad_required>` when `.required` is invalid, or when
#'   `.extra_cols = FALSE` and a name in `.required` has no spec in `...`.
#'   - `<stbl-error-unnamed_spec>` when any element passed through `...` is
#'   unnamed.
#'   - `<stbl-error-missing_element>`, `<stbl-error-bad_named>`,
#'   `<stbl-error-bad_unnamed>`, or `<stbl-error-duplicate_names>` when
#'   list-like column checks delegated to [stabilize_lst()] fail.
#' @family data frame functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' # Basic validation: required columns with type specs
#' stabilize_df(
#'   data.frame(name = "Alice", age = 30L),
#'   name = specify_chr_scalar(),
#'   age = specify_int_scalar()
#' )
#'
#' # Validate extra columns with .extra_cols
#' stabilize_df(
#'   data.frame(name = "Alice", age = 30L, score = 99.5),
#'   name = specify_chr_scalar(),
#'   age = specify_int_scalar(),
#'   .extra_cols = assert_present
#' )
#'
#' # Allow extra columns unchecked with .extra_cols = TRUE
#' stabilize_df(
#'   data.frame(name = "Alice", age = 30L, score = 99.5),
#'   name = specify_chr_scalar(),
#'   .extra_cols = TRUE
#' )
#'
#' # Check required column names without validating contents
#' stabilize_df(
#'   mtcars,
#'   .required = c("mpg", "cyl"),
#'   .extra_cols = assert_present
#' )
#'
#' # Enforce row count constraints
#' try(
#'   stabilize_df(mtcars[0, ], .min_rows = 1, .extra_cols = assert_present)
#' )
#'
#' # NULL is allowed by default
#' stabilize_df(NULL)
#' try(stabilize_df(NULL, .allow_null = FALSE))
#'
#' # Convertible inputs such as named lists are accepted
#' stabilize_df(
#'   list(name = "Alice", age = 30L),
#'   name = specify_chr_scalar(),
#'   age = specify_int_scalar()
#' )
#'
#' # Non-convertible inputs are rejected
#' try(stabilize_df("not a data frame"))
#'
#' # Mark a column as optional via .required
#' stabilize_df(
#'   data.frame(name = "Alice"),
#'   name = specify_chr_scalar(),
#'   age = specify_int_scalar(),
#'   .required = "name"
#' )
#'
#' # Conditional requirements: when `credit_card` is present, `billing_address`
#' # is required.
#' try(
#'   stabilize_df(
#'     data.frame(name = "Alice", credit_card = 1234L),
#'     name = specify_chr_scalar(),
#'     credit_card = specify_int_scalar(),
#'     billing_address = specify_chr_scalar(),
#'     .required = list("name", credit_card = "billing_address")
#'   )
#' )
stabilize_df <- function(
  .x,
  ...,
  .extra_cols = NULL,
  .col_names = lifecycle::deprecated(), # LIFECYCLE-REMOVE(.col_names)
  .min_rows = NULL,
  .max_rows = NULL,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .required = ...names(),
  .x_arg = caller_arg(.x),
  .call = caller_env(),
  .x_class = object_type(.x)
) {
  force(.x_arg)
  force(.call)

  # LIFECYCLE-REMOVE(.col_names)
  if (lifecycle::is_present(.col_names)) {
    lifecycle::deprecate_warn(
      when = "0.7.0",
      what = "stabilize_df(.col_names)",
      with = "stabilize_df(.required)"
    )
  } else {
    .col_names <- NULL
  }

  required <- .normalize_required(.required, ".required", call = .call)
  .check_required_have_specs(
    required,
    spec_names = ...names(),
    named = .extra_cols,
    named_arg = ".extra_cols",
    call = .call
  )

  if (is.null(.x)) {
    return(.to_null(.x, allow_null = .allow_null, x_arg = .x_arg, call = .call))
  }

  .x <- rlang::inject(to_df(!!.x, x_arg = .x_arg, call = .call))

  .check_df_rows(
    .x,
    min_rows = .min_rows,
    max_rows = .max_rows,
    x_arg = .x_arg,
    call = .call
  )

  # LIFECYCLE-REMOVE(.col_names)
  .check_df_col_names(.x, col_names = .col_names, x_arg = .x_arg, call = .call)

  .check_specs_named(..., .call = .call)
  # Checked here (not only in stabilize_lst()) so that errors say "column".
  .allow_zero_length <- to_lgl_scalar(.allow_zero_length, call = .call)
  if (length(.x) || !.allow_zero_length) {
    .check_required_present(
      required,
      present = names(.x),
      noun = "column",
      x_arg = .x_arg,
      call = .call
    )
  }
  x_lst <- stabilize_lst(
    .x,
    ...,
    .named = .extra_cols,
    .allow_zero_length = .allow_zero_length,
    .required = .required,
    .x_arg = .x_arg,
    .call = .call,
    .x_class = .x_class
  )

  # Update columns in the data frame from the validated list, preserving the
  # data frame class and attributes such as row names.
  for (nm in names(x_lst)) {
    .x[[nm]] <- x_lst[[nm]]
  }

  return(.x)
}

#' @export
#' @rdname stabilize_df
stabilise_df <- stabilize_df

#' @export
#' @rdname stabilize_df
stabilize_data_frame <- stabilize_df

#' @export
#' @rdname stabilize_df
stabilise_data_frame <- stabilize_df

#' Check that a data frame has an acceptable number of rows
#'
#' @param .x `(data.frame)` The data frame being validated.
#' @param min_rows (`integer(1)`) Minimum number of rows allowed, or `NULL` to
#'   skip this check.
#' @param max_rows (`integer(1)`) Maximum number of rows allowed, or `NULL` to
#'   skip this check.
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if the check passes.
#' @keywords internal
.check_df_rows <- function(.x, min_rows, max_rows, x_arg, call) {
  if (is.null(min_rows) && is.null(max_rows)) {
    return(invisible(NULL))
  }

  min_rows <- to_int_scalar(min_rows, allow_null = TRUE, call = call)
  max_rows <- to_int_scalar(max_rows, allow_null = TRUE, call = call)
  .check_x_no_more_than_y(min_rows, max_rows, call = call)

  n <- nrow(.x)
  min_ok <- is.null(min_rows) || n >= min_rows
  max_ok <- is.null(max_rows) || n <= max_rows

  if (min_ok && max_ok) {
    return(invisible(NULL))
  }

  if (max_ok) {
    .stop_must(
      msg = "must have at least {min_rows} row{?s}.",
      x_arg = x_arg,
      additional_msg = c(x = "{n} is too few."),
      call = call,
      subclass = "too_few_rows",
      message_env = rlang::current_env()
    )
  }

  .stop_must(
    msg = "must have at most {max_rows} row{?s}.",
    x_arg = x_arg,
    additional_msg = c(x = "{n} is too many."),
    call = call,
    subclass = "too_many_rows",
    message_env = rlang::current_env()
  )
}

# LIFECYCLE-REMOVE(.col_names)
#' Check that required column names are present in a data frame
#'
#' @param .x `(data.frame)` The data frame being validated.
#' @param col_names `(character)` Column names that must be present in `.x`, or
#'   `NULL` to skip this check.
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if the check passes.
#' @keywords internal
.check_df_col_names <- function(.x, col_names, x_arg, call) {
  if (is.null(col_names)) {
    return(invisible(NULL))
  }

  col_names <- to_chr(col_names, call = call)
  missing_cols <- setdiff(col_names, names(.x))

  if (length(missing_cols)) {
    .stop_must(
      "must contain column{?s} {.val {missing_cols}}.",
      x_arg = x_arg,
      call = call,
      subclass = "missing_cols",
      message_env = rlang::current_env()
    )
  }

  invisible(NULL)
}
