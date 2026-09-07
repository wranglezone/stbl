#' Create a specified each stabilizer function
#'
#' `specify_each()` creates a function that will call [stabilize_each()] with
#' the provided `spec`, letting an element-wise spec be reused and nested
#' inside other `specify_*()`/`stabilize_*()` calls.
#'
#' @inheritParams .shared-params
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_each()] with the provided `spec`. The generated function will
#'   also accept `simplify` and `...` to pass to [stabilize_each()]. You can
#'   copy/paste the body of the resulting function if you want to provide
#'   additional context or functionality.
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_ints <- specify_each(stabilize_int)
#' stabilize_ints(list("1", "2", "3"))
#' try(stabilize_ints(list("1", "a")))
specify_each <- function(spec) {
  structure(
    function(
      x,
      ...,
      simplify = TRUE,
      x_arg = caller_arg(x),
      call = caller_env(),
      x_class = object_type(x)
    ) {
      stabilize_each(
        x,
        spec,
        ...,
        simplify = simplify,
        x_arg = x_arg,
        call = call,
        x_class = x_class
      )
    },
    class = c("stbl_specified_fn", "function")
  )
}
