#' Ensure a data frame argument meets expectations
#'
#' `stabilize_df()` validates the structure and contents of a data frame. It can
#' check that specific named columns are present and valid, that extra columns
#' conform to a shared rule, that required column names are present, and that
#' the row count is within specified bounds. `stabilise_df()`,
#' `stabilize_data_frame()`, and `stabilise_data_frame()` are synonyms of
#' `stabilize_df()`.
#'
#' @param ... Named [`specify_*()`][specify_chr] functions for required named
#'   columns of `.x`. Each name corresponds to a required column in `.x`, and
#'   the function is used to validate that column.
#' @param .extra_cols A single `specify_*()` function ([specify_chr()], etc) to
#'   validate all columns of `.x` that are *not* explicitly listed in `...`. If
#'   `NULL` (default), any extra columns will cause an error.
#' @param .col_names `(character)` A character vector of column names that must
#'   be present in `.x`. Any columns listed here that are absent from `.x` will
#'   cause an error. Unlike `...`, this does not validate the column contents.
#' @param .min_rows `(length-1 integer)` The minimum number of rows allowed in
#'   `.x`. If `NULL` (default), the row count is not checked.
#' @param .max_rows `(length-1 integer)` The maximum number of rows allowed in
#'   `.x`. If `NULL` (default), the row count is not checked.
#' @inheritParams .shared-params
#'
#' @returns The validated data frame.
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
#' # Allow extra columns with .extra_cols
#' stabilize_df(
#'   data.frame(name = "Alice", age = 30L, score = 99.5),
#'   name = specify_chr_scalar(),
#'   age = specify_int_scalar(),
#'   .extra_cols = stabilize_present
#' )
#'
#' # Check required column names without validating contents
#' stabilize_df(mtcars, .col_names = c("mpg", "cyl"), .extra_cols = stabilize_present)
#'
#' # Enforce row count constraints
#' try(stabilize_df(mtcars[0, ], .min_rows = 1, .extra_cols = stabilize_present))
#'
#' # NULL is allowed by default
#' stabilize_df(NULL)
#' try(stabilize_df(NULL, .allow_null = FALSE))
#'
#' # Coercible inputs such as named lists are accepted
#' stabilize_df(
#'   list(name = "Alice", age = 30L),
#'   name = specify_chr_scalar(),
#'   age = specify_int_scalar()
#' )
#'
#' # Non-coercible inputs are rejected
#' try(stabilize_df("not a data frame"))
stabilize_df <- function(
  .x,
  ...,
  .extra_cols = NULL,
  .col_names = NULL,
  .min_rows = NULL,
  .max_rows = NULL,
  .allow_null = TRUE,
  .x_arg = caller_arg(.x),
  .call = caller_env(),
  .x_class = object_type(.x)
) {
  force(.x_arg)
  force(.call)

  if (is.null(.x)) {
    return(.to_null(.x, allow_null = .allow_null, x_arg = .x_arg, call = .call))
  }

  .x <- to_df(.x, x_arg = .x_arg, call = .call)

  .check_df_rows(
    .x,
    min_rows = .min_rows,
    max_rows = .max_rows,
    x_arg = .x_arg,
    call = .call
  )

  .check_df_col_names(.x, col_names = .col_names, x_arg = .x_arg, call = .call)

  .check_specs_named(..., .call = .call)
  x_lst <- stabilize_lst(
    .x,
    ...,
    .named = .extra_cols,
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
#' @param min_rows `(length-1 integer)` Minimum number of rows allowed, or
#'   `NULL` to skip this check.
#' @param max_rows `(length-1 integer)` Maximum number of rows allowed, or
#'   `NULL` to skip this check.
#' @inheritParams .shared-params
#'
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

#' Check that required column names are present in a data frame
#'
#' @param .x `(data.frame)` The data frame being validated.
#' @param col_names `(character)` Column names that must be present in `.x`, or
#'   `NULL` to skip this check.
#' @inheritParams .shared-params
#'
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
