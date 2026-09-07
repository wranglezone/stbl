# any_of ----

#' Create a specified any-of stabilizer function
#'
#' `specify_any_of()` creates a function that will call [stabilize_any_of()]
#' with the provided specs. `specify_any_of()`'s function tries each spec in
#' order and returns the result of the first one that succeeds.
#'
#' @param ... Unnamed stabilizer / `to_*` / `specify_*()` specs, forwarded to
#'   [stabilize_any_of()].
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_any_of()] with the provided specs. The generated function will
#'   also accept `...` for additional unnamed specs to pass to
#'   [stabilize_any_of()]. You can copy/paste the body of the resulting
#'   function if you want to provide additional context or functionality.
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_int_or_chr <- specify_any_of(specify_int(), specify_chr())
#' stabilize_int_or_chr(1L)
#' stabilize_int_or_chr("a")
#' try(stabilize_int_or_chr(TRUE))
specify_any_of <- function(...) {
  element_specs <- list(...)
  structure(
    function(
      x,
      ...,
      x_arg = caller_arg(x),
      call = caller_env(),
      x_class = object_type(x)
    ) {
      rlang::inject(
        stabilize_any_of(
          x,
          !!!element_specs,
          ...,
          x_arg = x_arg,
          call = call,
          x_class = x_class
        )
      )
    },
    class = c("stbl_specified_fn", "function")
  )
}
