#' Create a specified all-of stabilizer function
#'
#' `specify_all_of()` creates a function that will call [stabilize_all_of()]
#' with the provided specs. `specify_all_of()`'s function requires that `x`
#' satisfy every provided spec, and that all specs agree on the coerced
#' result.
#'
#' @param ... Unnamed stabilizer functions, forwarded to
#'   [stabilize_all_of()].
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_all_of()] with the provided specs. The generated function will
#'   also accept `...` for additional unnamed specs to pass to
#'   [stabilize_all_of()]. You can copy/paste the body of the resulting
#'   function if you want to provide additional context or functionality.
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_a_then_b <- specify_all_of(
#'   specify_chr(regex = "^a"),
#'   specify_chr(regex = "b$")
#' )
#' stabilize_a_then_b("ab")
#' try(stabilize_a_then_b("ba"))
specify_all_of <- function(...) {
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
        stabilize_all_of(
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
