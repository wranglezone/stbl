#' Create a specified function coercer
#'
#' `specify_fn()` creates a function that will call [to_fn()] with the provided
#' arguments pre-filled. `specify_function()` is a synonym of `specify_fn()`.
#'
#' @param allow_null `(length-1 logical)` Is `NULL` an acceptable return value?
#'   See [to_fn()] for details.
#' @param definition_env `(environment)` The environment in which to look up
#'   function names. See [to_fn()] for details.
#' @returns A function of class `"stbl_specified_fn"` that calls [to_fn()] with
#'   the provided arguments. The generated function also accepts `...` for
#'   additional arguments to pass to [to_fn()]. You can copy/paste the body of
#'   the resulting function if you want to provide additional context or
#'   functionality.
#' @family function functions
#' @family specification functions
#' @export
#'
#' @examples
#' to_pkg_fn <- specify_fn(definition_env = asNamespace("stats"))
#' to_pkg_fn("median")
#' try(to_pkg_fn(NULL))
specify_fn <- function(
  allow_null = TRUE,
  definition_env = rlang::global_env()
) {
  factory_args <- list()
  for (arg in names(formals())) {
    if (!rlang::inject(base::missing(!!arg))) {
      factory_args[[arg]] <- get(arg)
    }
  }
  .specify_to_fn(factory_args)
}

#' @export
#' @rdname specify_fn
specify_function <- specify_fn

#' Build a pre-configured to_fn() wrapper
#'
#' @param factory_args `(list)` Arguments to pre-fill in the call to [to_fn()].
#' @param ... Not used. Included to avoid confusion in R CMD check.
#' @param call `(environment)` The environment to use as the parent of the
#'   generated function. Defaults to the caller's environment.
#' @returns A function of class `"stbl_specified_fn"` that calls [to_fn()] with
#'   the provided arguments.
#' @keywords internal
.specify_to_fn <- function(factory_args, ..., call = rlang::caller_env()) {
  check_dupes <- .maybe_check_dupes(factory_args)

  # Dummy variables to avoid R CMD check undefined global variable notes.
  x <- "x"
  x_arg <- "x_arg"
  x_class <- "x_class"
  structure(
    rlang::new_function(
      as.pairlist(alist(
        x = ,
        ... = ,
        x_arg = rlang::caller_arg(x),
        call = rlang::caller_env(),
        x_class = stbl::object_type(x)
      )),
      rlang::expr({
        !!!check_dupes
        stbl::to_fn(
          x,
          !!!factory_args,
          ...,
          x_arg = x_arg,
          call = call,
          x_class = x_class
        )
      }),
      env = call
    ),
    class = c("stbl_specified_fn", "function")
  )
}
