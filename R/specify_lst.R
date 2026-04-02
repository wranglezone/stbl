# lst ----

#' Create a specified list stabilizer function
#'
#' `specify_lst()` creates a function that will call [stabilize_lst()] with the
#' provided arguments. `specify_list()` is a synonym of `specify_lst()`.
#'
#' @inheritParams stabilize_lst
#'
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_lst()] with the provided arguments. The generated function will
#'   also accept `...` for additional named element specifications to pass to
#'   [stabilize_lst()]. You can copy/paste the body of the resulting function if
#'   you want to provide additional context or functionality.
#' @family list functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_config <- specify_lst(
#'   name = specify_chr_scalar(),
#'   .min_size = 1
#' )
#' stabilize_config(list(name = "myapp"))
#' try(stabilize_config(list()))
specify_lst <- function(
  ...,
  .named = NULL,
  .unnamed = NULL,
  .allow_null = TRUE,
  .min_size = NULL,
  .max_size = NULL
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
        stabilize_lst(
          .x,
          !!!element_specs,
          !!!list(...),
          .named = .named,
          .unnamed = .unnamed,
          .allow_null = .allow_null,
          .min_size = .min_size,
          .max_size = .max_size,
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
#' @rdname specify_lst
specify_list <- specify_lst

# present ----

#' Create a specified "present" validator function
#'
#' `specify_present()` creates a function that validates that an element is
#' present (i.e., not `NULL`). Any non-`NULL` value passes. This is useful
#' when you need to require a named list element without imposing any type
#' constraints on its value.
#'
#' @returns A function of class `"stbl_specified_fn"` that errors if the value
#'   is `NULL` and returns it unchanged otherwise.
#' @family specification functions
#' @export
#'
#' @examples
#' check_present <- specify_present()
#' check_present("any value")
#' check_present(list(1, 2, 3))
#' try(check_present(NULL))
specify_present <- function() {
  structure(
    function(
      x,
      x_arg = caller_arg(x),
      call = caller_env(),
      x_class = object_type(x)
    ) {
      if (is.null(x)) {
        .stop_null(x_arg = x_arg, call = call)
      }
      x
    },
    class = c("stbl_specified_fn", "function")
  )
}
