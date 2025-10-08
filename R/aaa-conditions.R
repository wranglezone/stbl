#' @importFrom rlang caller_arg
#' @export
rlang::caller_arg

#' @importFrom rlang caller_env
#' @export
rlang::caller_env

#' Signal an error with standards applied
#'
#' A wrapper around [cli::cli_abort()] to throw classed errors.
#'
#' @param message (`character`) The message for the new error. Messages will be
#'   formatted with [cli::cli_bullets()].
#' @param subclass (`character`) Class(es) to assign to the error. Will be
#'   prefixed by "stbl-error-".
#' @param ... Additional parameters passed to [cli::cli_abort()] and on to
#'   [rlang::abort()].
#' @inheritParams .shared-params
#'
#' @keywords internal
.stbl_abort <- function(
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
) {
  pkg_abort(
    "stbl",
    message = message,
    subclass = subclass,
    call = call,
    message_env = message_env,
    parent = parent,
    ...
  )
}

#' Abort with a standardized "can't coerce" message
#'
#' @param from_class `(length-1 character)` The class of the object that failed
#'   coercion.
#' @param to_class `(length-1 character)` The target class for the coercion.
#' @param additional_msg `(length-1 character)` Optional, additional
#'   cli-formatted messages.
#' @inheritParams .stbl_abort
#' @inheritParams .shared-params
#'
#' @returns This function is called for its side effect of throwing an error and
#'   does not return a value.
#' @keywords internal
.stop_cant_coerce <- function(
  from_class,
  to_class,
  x_arg,
  call,
  additional_msg = NULL,
  message_env = call,
  parent = NULL,
  ...
) {
  main_msg <- .glue2(
    "Can't coerce {.arg [x_arg]} {.cls [from_class]} to {.cls [to_class]}."
  )
  .stbl_abort(
    message = c(main_msg, additional_msg),
    subclass = c("coerce", to_class),
    call = call,
    message_env = message_env,
    parent = parent,
    ...
  )
}

#' Abort with a standardized "must" message
#'
#' @param msg `(character)` The core error message describing the requirement.
#' @param additional_msg `(character)` Optional, additional cli-formatted
#'   messages.
#' @inheritParams .stbl_abort
#' @inheritParams .shared-params
#'
#' @returns This function is called for its side effect of throwing an error and
#'   does not return a value.
#' @keywords internal
.stop_must <- function(
  msg,
  x_arg,
  call,
  additional_msg = NULL,
  subclass = "must",
  message_env = call,
  parent = NULL,
  ...
) {
  main_msg <- .define_main_msg(x_arg, msg)
  .stbl_abort(
    message = c(main_msg, additional_msg),
    subclass = subclass,
    call = call,
    message_env = message_env,
    parent = parent,
    ...
  )
}

#' Define the main error message for a "must" error
#'
#' @param msg `(character)` The core error message describing the requirement.
#' @inheritParams .shared-params
#'
#' @returns A character string.
#' @keywords internal
.define_main_msg <- function(x_arg, msg) {
  .glue2("{.arg [x_arg]} [msg]")
}

#' Abort because an argument must not be NULL
#'
#' @inheritParams .stbl_abort
#' @inheritParams .shared-params
#'
#' @returns This function is called for its side effect of throwing an error and
#'   does not return a value.
#' @keywords internal
.stop_null <- function(x_arg, call, parent = NULL, ...) {
  .stop_must(
    "must not be {.cls NULL}.",
    x_arg = x_arg,
    call = call,
    subclass = "bad_null",
    parent = parent,
    ...
  )
}

#' Abort with an "incompatible type" message
#'
#' @param to The target object for the coercion.
#' @param failures `(logical)` A logical vector indicating which elements
#'   failed.
#' @param due_to `(length-1 character)` A string describing the reason for the
#'   failure.
#' @inheritParams .stbl_abort
#' @inheritParams .shared-params
#'
#' @returns This function is called for its side effect of throwing an error and
#'   does not return a value.
#' @keywords internal
.stop_incompatible <- function(
  x_class,
  to,
  failures,
  due_to,
  x_arg,
  call,
  parent = NULL,
  ...
) {
  to_class <- object_type(to)
  locations <- which(failures)
  .stop_must(
    msg = "{.cls {x_class}} must be coercible to {.cls {to_class}}",
    x_arg = x_arg,
    additional_msg = c(
      x = "Can't convert some values due to {due_to}.",
      "*" = "Locations: {locations}"
    ),
    call = call,
    subclass = "incompatible_type",
    message_env = rlang::current_env(),
    parent = parent,
    ...
  )
}
