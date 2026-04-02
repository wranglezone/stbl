# df ----

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
#'   name = specify_chr_scalar(allow_na = FALSE),
#'   age = specify_int_scalar(allow_na = FALSE),
#'   .extra_cols = stabilize_present
#' )
#' stabilize_person_df(data.frame(name = "Alice", age = 30L, score = 99.5))
#' try(stabilize_person_df(data.frame(name = "Alice")))
specify_df <- function(
  ...,
  .extra_cols = NULL,
  .col_names = NULL,
  .min_rows = NULL,
  .max_rows = NULL,
  .allow_null = TRUE
) {
  element_specs <- list(...)
  structure(
    function(
      .x,
      ...,
      x_arg = caller_arg(.x),
      call = caller_env(),
      x_class = object_type(.x)
    ) {
      rlang::inject(
        stabilize_df(
          .x,
          !!!element_specs,
          !!!list(...),
          .extra_cols = .extra_cols,
          .col_names = .col_names,
          .min_rows = .min_rows,
          .max_rows = .max_rows,
          .allow_null = .allow_null,
          .x_arg = x_arg,
          .call = call,
          .x_class = x_class
        )
      )
    },
    class = c("stbl_specified_fn", "function")
  )
}

#' @export
#' @rdname specify_df
specify_data_frame <- specify_df
