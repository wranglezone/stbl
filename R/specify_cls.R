#' Create a specified stabilizer function
#'
#' @param stabilizer (`character(1)`) Name of the stabilizer function to
#'   call.
#' @param factory_args `(list)` Arguments to include in the call to the
#'   stabilizer function.
#' @param scalar (`logical(1)`) Whether to call the scalar version of the
#'   stabilizer.
#' @param call `(environment)` The environment to use as the parent of the
#'   generated function. Defaults to the caller's environment.
#' @returns A function of class `"stbl_specified_fn"` that calls the specified
#'   stabilizer function with the provided arguments. The generated function
#'   will also accept `...` for additional arguments to pass to the stabilizer
#'   function. You can copy/paste the body of the resulting function if you want
#'   to provide additional context or functionality.
#' @keywords internal
.specify_cls <- function(
  stabilizer,
  factory_args = list(),
  scalar = FALSE,
  call = rlang::caller_env()
) {
  check_dupes <- .maybe_check_dupes(factory_args)
  stabilizer <- .construct_stabilizer_symbol(stabilizer, scalar = scalar)
  .construct_specification_fn(
    check_dupes = check_dupes,
    stabilizer = stabilizer,
    factory_args = factory_args,
    call = call
  )
}

#' Construct the check_dupes expression
#'
#' @param factory_args Arguments passed into the factory.
#' @returns An empty list, or a list containing an expression that checks for
#'   duplicate arguments.
#' @keywords internal
.maybe_check_dupes <- function(factory_args) {
  check_dupes <- list()
  if (length(factory_args)) {
    # Add a check in the constructed function to ensure that no arguments passed
    # in by the user are already present in the constructed function.
    factory_arg_names <- names(factory_args)
    check_dupes <- rlang::exprs({
      # nocov start
      duplicated_args <- intersect(...names(), !!factory_arg_names)
      if (length(duplicated_args)) {
        stbl::pkg_abort(
          "stbl",
          message = c(
            "Arguments passed via `...` cannot duplicate specification.",
            i = "Duplicated arguments: {.arg {duplicated_args}}"
          ),
          subclass = "duplicate_args"
        )
      }
    }) # nocov end
  }
  return(check_dupes)
}

#' Assemble the function name of the stabilizer
#'
#' @inheritParams .specify_cls
#' @returns The symbol of the stabilizer function to call.
#' @keywords internal
.construct_stabilizer_symbol <- function(stabilizer, scalar = FALSE) {
  as.symbol(
    paste(c("stabilize", stabilizer, if (scalar) "scalar"), collapse = "_")
  )
}

#' Construct a specified stabilizer function
#'
#' @param check_dupes `(list)` An empty list, or a list containing an expression
#'   that checks for duplicate arguments.
#' @param factory_args Arguments passed to [.specify_cls()] as `...`.
#' @param ... Not used. Included to avoid confusion in R CMD check.
#' @inheritParams .specify_cls
#' @inherit .specify_cls return
#' @keywords internal
.construct_specification_fn <- function(
  check_dupes,
  stabilizer,
  factory_args,
  ...,
  call = rlang::caller_env()
) {
  # Function created with the help of factory::build_factory(). See
  # https://cran.r-project.org/package=factory

  # Dummy variable(s) to avoid R CMD check undefined global variable notes.
  x <- "x"
  x_arg <- "x_arg"
  x_class <- "x_class"
  # Strip any covr counter wrappers that may have been injected into the body
  # expression by coverage instrumentation (covr wraps statements inside
  # rlang::expr() blocks at the source level, causing them to appear in the
  # printed function body and destabilise snapshots).
  fn_body <- .strip_covr_from_expr(rlang::expr({
    # nocov start
    !!!check_dupes
    stbl::`!!`(stabilizer)(
      x,
      !!!factory_args,
      ...,
      x_arg = x_arg,
      call = call,
      x_class = x_class
    )
  })) # nocov end
  structure(
    rlang::new_function(
      as.pairlist(alist(
        x = ,
        ... = ,
        x_arg = rlang::caller_arg(x),
        call = rlang::caller_env(),
        x_class = stbl::object_type(x)
      )),
      fn_body,
      env = call
    ),
    class = c("stbl_specified_fn", "function")
  )
}

#' Injection operator for defused arguments
#' @name injection-operator
#' @usage NULL
#' @export
#' @keywords internal
`!!` <- function(x) {
  # nocov start

  # Copied from {rlang} to make R CMD check happy.
  rlang::abort(
    "`!!` can only be used within a defused argument.",
    call = rlang::caller_env()
  )
  # nocov end
}

#' Capture the non-missing arguments of the calling function
#'
#' Used inside `specify_*()` functions to build the `factory_args` list passed
#' to [.specify_cls()], keeping only the arguments that the caller of the
#' `specify_*()` function actually supplied (as opposed to those left at
#' their default value).
#'
#' @returns A named list of the values of arguments that weren't left missing
#'   in the function that called `.capture_factory_args()`.
#' @keywords internal
.capture_factory_args <- function() {
  env <- parent.frame()
  fn <- sys.function(sys.parent())
  factory_args <- list()
  for (arg in names(formals(fn))) {
    if (!eval(call("missing", as.name(arg)), envir = env)) {
      factory_args[[arg]] <- get(arg, envir = env)
    }
  }
  factory_args
}
