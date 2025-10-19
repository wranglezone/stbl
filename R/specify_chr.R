#' Create a specified character stabilizer function
#'
#' Create a function that will call [stabilize_chr()] with the provided
#' arguments.
#'
#' @inheritDotParams stabilize_chr -x -x_arg -call -x_class
#'
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_chr()] with the provided arguments. The generated function will
#'   also accept `...` for additional arguments to pass to `stabilize_chr()`.
#'   You can copy/paste the body of the resulting function if you want to
#'   provide additional context or functionality.
#' @export
#' @examples
#' stabilize_email <- specify_chr(regex = "^[^@]+@[^@]+\\.[^@]+$")
#' stabilize_email("stbl@example.com")
#' try(stabilize_email("not-an-email-address"))
specify_chr <- function(...) {
  # Function created using factory::build_factory(). See
  # https://cran.r-project.org/package=factory

  # Dummy variable(s) to avoid R CMD check undefined global variable notes.
  x <- "x"
  x_arg <- "x_arg"
  call <- "call"
  x_class <- "x_class"
  factory_args <- rlang::list2(...)
  factory_arg_names <- names(factory_args)
  preproc <- list()
  if (length(factory_args)) {
    preproc <- rlang::exprs({
      duplicated_args <- intersect(...names(), !!factory_arg_names)
      if (length(duplicated_args)) {
        .stbl_abort(
          c(
            "Arguments passed via `...` cannot duplicate specification.",
            i = "Duplicated arguments: {.arg {duplicated_args}}"
          ),
          subclass = "duplicate_args"
        )
      }
    })
  }

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
        !!!preproc
        stbl::stabilize_chr(
          x,
          !!!factory_args,
          ...,
          x_arg = x_arg,
          call = call,
          x_class = x_class
        )
      }),
      rlang::caller_env()
    ),
    class = c("stbl_specified_fn", "function")
  )
}
