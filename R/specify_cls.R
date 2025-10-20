#' Create a specified stabilizer function
#'
#' @param stabilizer `(length-1 character)` Name of the stabilizer function to
#'   call.
#' @param ... Arguments to include in the call to the stabilizer function.
#' @param scalar `(length-1 logical)` Whether to call the scalar version of the
#'   stabilizer.
#' @param call `(environment)` The environment to use as the parent of the
#'   generated function. Defaults to the caller's environment.
#' @returns A function of class `"stbl_specified_fn"` that calls the specified
#'   stabilizer function with the provided arguments. The generated function
#'   will also accept `...` for additional arguments to pass to the stabilizer
#'   function. You can copy/paste the body of the resulting function if you want
#'   to provide additional context or functionality.
#' @keywords internal
specify_cls <- function(
  stabilizer,
  ...,
  scalar = FALSE,
  call = rlang::caller_env()
) {
  factory_args <- rlang::list2(...)
  check_dupes <- .maybe_check_dupes(factory_args)
  stabilizer <- .construct_stabilizer_symbol(stabilizer, scalar = scalar)
  .construct_specification_fn(
    check_dupes = check_dupes,
    stabilizer = stabilizer,
    factory_args = factory_args,
    call = call
  )
}

#' Construction the check_dupes expression
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
    })
  }
  return(check_dupes)
}

#' Assemble the function name of the stabilizer
#'
#' @inheritParams specify_cls
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
#' @param factory_args Arguments passed to [specify_cls()] as `...`.
#' @inheritParams specify_cls
#' @inherit specify_cls return
#' @keywords internal
.construct_specification_fn <- function(
  check_dupes,
  stabilizer,
  factory_args,
  call = rlang::caller_env()
) {
  # Function created with the help of factory::build_factory(). See
  # https://cran.r-project.org/package=factory

  # Dummy variable(s) to avoid R CMD check undefined global variable notes.
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
        stbl::`!!`(stabilizer)(
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

# chr ----

#' Create a specified character stabilizer function
#'
#' `specify_chr()` creates a function that will call [stabilize_chr()] with the
#' provided arguments. `specify_chr_scalar()` creates a function that will call
#' [stabilize_chr_scalar()] with the provided argumetns.
#'
#' @inheritDotParams stabilize_chr -x -x_arg -call -x_class
#' @inheritDotParams stabilize_chr_scalar -x -x_arg -call -x_class
#'
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_chr()] or [stabilize_chr_scalar()] with the provided arguments.
#'   The generated function will also accept `...` for additional arguments to
#'   pass to `stabilize_chr()` or `stabilize_chr_scalar()`. You can copy/paste
#'   the body of the resulting function if you want to provide additional
#'   context or functionality.
#' @export
#' @examples
#' stabilize_email <- specify_chr(regex = "^[^@]+@[^@]+\\.[^@]+$")
#' stabilize_email("stbl@example.com")
#' try(stabilize_email("not-an-email-address"))
#' @rdname specify_chr
specify_chr <- function(...) {
  specify_cls("chr", ...)
}

#' @export
#' @rdname specify_chr
specify_chr_scalar <- function(...) {
  specify_cls("chr", ..., scalar = TRUE)
}

# fct ----

#' Create a specified factor stabilizer function
#'
#' `specify_fct()` creates a function that will call [stabilize_fct()] with the
#' provided arguments. `specify_fct_scalar()` creates a function that will call
#' [stabilize_fct_scalar()] with the provided argumetns.
#'
#' @inheritDotParams stabilize_fct -x -x_arg -call -x_class
#' @inheritDotParams stabilize_fct_scalar -x -x_arg -call -x_class
#'
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_fct()] or [stabilize_fct_scalar()] with the provided arguments.
#'   The generated function will also accept `...` for additional arguments to
#'   pass to `stabilize_fct()` or `stabilize_fct_scalar()`. You can copy/paste
#'   the body of the resulting function if you want to provide additional
#'   context or functionality.
#' @export
#' @examples
#' stabilize_lowercase_letter <- specify_fct(levels = letters)
#' stabilize_lowercase_letter(c("s", "t", "b", "l"))
#' try(stabilize_lowercase_letter("A"))
#' @rdname specify_fct
specify_fct <- function(...) {
  specify_cls("fct", ...)
}

#' @export
#' @rdname specify_fct
specify_fct_scalar <- function(...) {
  specify_cls("fct", ..., scalar = TRUE)
}
