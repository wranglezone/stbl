#' @rdname stabilize_any_of
#' @export
#'
#' @examples
#' # to_any_of() uses prototypes instead of functions
#' to_any_of(1L, integer(), character())
#' to_any_of("a", integer(), character())
#' to_any_of("1", integer(), character())
#' try(to_any_of(list(), integer(), character()))
to_any_of <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  force(x_arg)
  force(call)

  protos <- list(...)
  .check_specs_not_empty(protos, .call = call)

  errors <- list()
  for (proto in protos) {
    result <- rlang::try_fetch(
      to(x, proto, x_arg = x_arg, call = call, x_class = x_class),
      error = function(cnd) cnd
    )
    if (!inherits(result, "error")) {
      return(result)
    }
    errors <- c(errors, list(result))
  }

  .stop_cant_stabilize_any_of(errors = errors, x_arg = x_arg, call = call)
}
