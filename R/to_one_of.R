#' @rdname stabilize_one_of
#' @export
#'
#' @examples
#' # to_one_of() uses prototypes instead of functions
#' to_one_of("a", integer(), character())
#'
#' # "FALSE" coerces to logical, but not to integer
#' to_one_of("FALSE", logical(), integer())
#'
#' # Errors as ambiguous: "1" coerces to both integer and double
#' try(to_one_of("1", integer(), double()))
to_one_of <- function(
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

  labels <- vapply(protos, object_type, character(1L))

  .try_exactly_one(
    protos,
    run_one = function(proto) {
      to(x, proto, x_arg = x_arg, call = call, x_class = x_class)
    },
    labels = labels,
    x_arg = x_arg,
    call = call
  )
}
