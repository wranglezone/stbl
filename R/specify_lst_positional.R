#' Create a specified positional list stabilizer function
#'
#' `specify_lst_positional()` creates a function that will call
#' [stabilize_lst_positional()] with the provided arguments.
#' `specify_list_positional()` and `specify_tuple()` are synonyms.
#'
#' @inheritParams stabilize_lst_positional
#'
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_lst_positional()] with the provided arguments. The generated
#'   function will also accept `...` for additional positional specifications,
#'   which are appended after those given to `specify_lst_positional()`. You
#'   can copy/paste the body of the resulting function if you want to provide
#'   additional context or functionality.
#' @family list functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_point <- specify_tuple(
#'   stabilize_dbl_scalar,
#'   stabilize_dbl_scalar
#' )
#' stabilize_point(list(-122.4, 37.8))
#' try(stabilize_point(list(-122.4, "north")))
specify_lst_positional <- function(
  ...,
  .additional = NULL,
  .n_required = ...length(),
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .simplify = FALSE,
  .coerce_function = FALSE
) {
  element_specs <- list(...)
  n_required <- .n_required
  structure(
    function(
      .x,
      ...,
      .x_arg = caller_arg(.x),
      .call = caller_env(),
      .x_class = object_type(.x)
    ) {
      rlang::inject(
        stabilize_lst_positional(
          .x,
          !!!element_specs,
          !!!list(...),
          .additional = .additional,
          .n_required = n_required,
          .unique = .unique,
          .allow_null = .allow_null,
          .allow_zero_length = .allow_zero_length,
          .min_size = .min_size,
          .max_size = .max_size,
          .simplify = .simplify,
          .coerce_function = .coerce_function,
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
#' @rdname specify_lst_positional
specify_list_positional <- specify_lst_positional

#' @export
#' @rdname specify_lst_positional
specify_tuple <- specify_lst_positional
