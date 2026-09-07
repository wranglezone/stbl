# one_of ----

#' Create a specified one-of stabilizer function
#'
#' `specify_one_of()` creates a function that will call [stabilize_one_of()]
#' with the provided specs. `specify_one_of()`'s function requires that
#' exactly one of the provided specs succeeds.
#'
#' @param ... Unnamed stabilizer / `to_*` / `specify_*()` specs, forwarded to
#'   [stabilize_one_of()].
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_one_of()] with the provided specs. The generated function will
#'   also accept `...` for additional unnamed specs to pass to
#'   [stabilize_one_of()]. You can copy/paste the body of the resulting
#'   function if you want to provide additional context or functionality.
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_int_xor_chr <- specify_one_of(specify_int(), specify_chr())
#' stabilize_int_xor_chr("a")
#' try(stabilize_int_xor_chr("1"))
specify_one_of <- function(...) {
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
        stabilize_one_of(
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
