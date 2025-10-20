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
#' @param ... Not used. Included to avoid confusion in R CMD check.
#' @inheritParams specify_cls
#' @inherit specify_cls return
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

#' Injection operator for defused arguments
#' @name injection-operator
#' @usage NULL
#' @export
`!!` <- function(x) {
  # nocov start

  # Copied from {rlang} to make R CMD check happy.
  rlang::abort(
    "`!!` can only be used within a defused argument.",
    call = rlang::caller_env()
  )
  # nocov end
}

# chr ----

#' Create a specified character stabilizer function
#'
#' `specify_chr()` creates a function that will call [stabilize_chr()] with the
#' provided arguments. `specify_chr_scalar()` creates a function that will call
#' [stabilize_chr_scalar()] with the provided arguments.
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

# dbl ----

#' Create a specified double stabilizer function
#'
#' `specify_dbl()` creates a function that will call [stabilize_dbl()] with the
#' provided arguments. `specify_dbl_scalar()` creates a function that will call
#' [stabilize_dbl_scalar()] with the provided arguments.
#'
#' @inheritDotParams stabilize_dbl -x -x_arg -call -x_class
#' @inheritDotParams stabilize_dbl_scalar -x -x_arg -call -x_class
#'
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_dbl()] or [stabilize_dbl_scalar()] with the provided arguments.
#'   The generated function will also accept `...` for additional arguments to
#'   pass to `stabilize_dbl()` or `stabilize_dbl_scalar()`. You can copy/paste
#'   the body of the resulting function if you want to provide additional
#'   context or functionality.
#' @export
#' @examples
#' stabilize_3_to_5 <- specify_dbl(min_value = 3, max_value = 5)
#' stabilize_3_to_5(c(3.3, 4.4, 5))
#' try(stabilize_3_to_5(c(1:6)))
#' @rdname specify_dbl
specify_dbl <- function(...) {
  specify_cls("dbl", ...)
}

#' @export
#' @rdname specify_dbl
specify_dbl_scalar <- function(...) {
  specify_cls("dbl", ..., scalar = TRUE)
}

# fct ----

#' Create a specified factor stabilizer function
#'
#' `specify_fct()` creates a function that will call [stabilize_fct()] with the
#' provided arguments. `specify_fct_scalar()` creates a function that will call
#' [stabilize_fct_scalar()] with the provided arguments.
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

# int ----

#' Create a specified integer stabilizer function
#'
#' `specify_int()` creates a function that will call [stabilize_int()] with the
#' provided arguments. `specify_int_scalar()` creates a function that will call
#' [stabilize_int_scalar()] with the provided arguments.
#'
#' @inheritDotParams stabilize_int -x -x_arg -call -x_class
#' @inheritDotParams stabilize_int_scalar -x -x_arg -call -x_class
#'
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_int()] or [stabilize_int_scalar()] with the provided arguments.
#'   The generated function will also accept `...` for additional arguments to
#'   pass to `stabilize_int()` or `stabilize_int_scalar()`. You can copy/paste
#'   the body of the resulting function if you want to provide additional
#'   context or functionality.
#' @export
#' @examples
#' stabilize_3_to_5 <- specify_int(min_value = 3, max_value = 5)
#' stabilize_3_to_5(c(3:5))
#' try(stabilize_3_to_5(c(1:6)))
#' @rdname specify_int
specify_int <- function(...) {
  specify_cls("int", ...)
}

#' @export
#' @rdname specify_int
specify_int_scalar <- function(...) {
  specify_cls("int", ..., scalar = TRUE)
}

# lgl ----

#' Create a specified logical stabilizer function
#'
#' `specify_lgl()` creates a function that will call [stabilize_lgl()] with the
#' provided arguments. `specify_lgl_scalar()` creates a function that will call
#' [stabilize_lgl_scalar()] with the provided arguments.
#'
#' @inheritDotParams stabilize_lgl -x -x_arg -call -x_class
#' @inheritDotParams stabilize_lgl_scalar -x -x_arg -call -x_class
#'
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_lgl()] or [stabilize_lgl_scalar()] with the provided arguments.
#'   The generated function will also accept `...` for additional arguments to
#'   pass to `stabilize_lgl()` or `stabilize_lgl_scalar()`. You can copy/paste
#'   the body of the resulting function if you want to provide additional
#'   context or functionality.
#' @export
#' @examples
#' stabilize_few_lgl <- specify_lgl(max_size = 5)
#' stabilize_few_lgl(c(TRUE, "False", TRUE))
#' try(stabilize_few_lgl(rep(TRUE, 10)))
#' @rdname specify_lgl
specify_lgl <- function(...) {
  specify_cls("lgl", ...)
}

#' @export
#' @rdname specify_lgl
specify_lgl_scalar <- function(...) {
  specify_cls("lgl", ..., scalar = TRUE)
}
