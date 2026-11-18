#' Create a specified data frame stabilizer function
#'
#' `specify_df()` creates a function that will call [stabilize_df()] with the
#' provided arguments. `specify_data_frame()` is a synonym of `specify_df()`.
#'
#' @inheritParams stabilize_df
#'
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_df()] with the provided arguments. The generated function will
#'   also accept `...` for additional named column specifications to pass to
#'   [stabilize_df()]. You can copy/paste the body of the resulting function if
#'   you want to provide additional context or functionality.
#' @family data frame functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_person_df <- specify_df(
#'   name = specify_chr(allow_na = FALSE),
#'   age = specify_int(allow_na = FALSE),
#'   .extra_cols = assert_present
#' )
#' stabilize_person_df(data.frame(name = "Alice", age = 30L, score = 99.5))
#' try(stabilize_person_df(data.frame(name = "Alice")))
#'
#' # Mark a column as optional via .required
#' stabilize_person_df2 <- specify_df(
#'   name = specify_chr(allow_na = FALSE),
#'   age = specify_int(allow_na = FALSE),
#'   .required = "name"
#' )
#' stabilize_person_df2(data.frame(name = "Alice"))
#'
#' # Require a column only when another is present
#' stabilize_person_df3 <- specify_df(
#'   name = specify_chr(allow_na = FALSE),
#'   card = stabilize_int,
#'   address = stabilize_chr,
#'   .required = list("name", card = "address")
#' )
#' try(stabilize_person_df3(data.frame(name = "Alice", card = 1L)))
specify_df <- function(
  ...,
  .patterns = NULL,
  .extra_cols = NULL,
  .col_names = lifecycle::deprecated(), # LIFECYCLE-REMOVE(.col_names)
  .min_rows = NULL,
  .max_rows = NULL,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .required = ...names()
) {
  element_specs <- list(...)
  # LIFECYCLE-REMOVE(.col_names)
  has_col_names <- lifecycle::is_present(.col_names)
  if (has_col_names) {
    lifecycle::deprecate_warn(
      when = "0.7.0",
      what = "specify_df(.col_names)",
      with = "specify_df(.required)"
    )
  } else {
    .col_names <- NULL
  }
  structure(
    function(
      .x,
      ...,
      .x_arg = caller_arg(.x),
      .call = caller_env(),
      .x_class = object_type(.x)
    ) {
      # LIFECYCLE-REMOVE(.col_names)
      if (has_col_names) {
        # specify_df() already warned.
        rlang::local_options(lifecycle_verbosity = "quiet")
      }
      rlang::inject(
        stabilize_df(
          .x,
          !!!element_specs,
          !!!list(...),
          .patterns = .patterns,
          .extra_cols = .extra_cols,
          .col_names = if (has_col_names) {
            .col_names
          } else {
            lifecycle::deprecated()
          },
          .min_rows = .min_rows,
          .max_rows = .max_rows,
          .allow_null = .allow_null,
          .allow_zero_length = .allow_zero_length,
          .required = .required,
          .x_arg = .x_arg,
          .call = .call,
          .x_class = .x_class
        )
      )
    },
    class = c("stbl_specified_fn", "function")
  )
}

#' @export
#' @rdname specify_df
specify_data_frame <- specify_df
