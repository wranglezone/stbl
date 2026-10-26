#' @importFrom rlang caller_arg
#' @export
rlang::caller_arg

#' @importFrom rlang caller_env
#' @export
rlang::caller_env

#' Signal an error with standards applied
#'
#' @param message (`character`) The message for the new error. Messages will be
#'   formatted with [cli::cli_bullets()].
#' @param subclass (`character`) Class(es) to assign to the error. Will be
#'   prefixed by "stbl-error-".
#' @param ... Additional parameters passed to [cli::cli_abort()] and on to
#'   [rlang::abort()].
#' @inheritParams .shared-params
#' @inherit pkg_abort return
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

#' Signal a warning with standards applied
#'
#' @param message (`character`) The message for the new warning. Messages will
#'   be formatted with [cli::cli_bullets()].
#' @param subclass (`character`) Class(es) to assign to the warning. Will be
#'   prefixed by "stbl-warning-".
#' @param ... Additional parameters passed to [cli::cli_warn()] and on to
#'   [rlang::warn()].
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @keywords internal
.stbl_warn <- function(
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
) {
  pkg_warn(
    "stbl",
    message = message,
    subclass = subclass,
    call = call,
    message_env = message_env,
    parent = parent,
    ...
  )
}

#' Signal a message with standards applied
#'
#' @param message (`character`) The message for the new message condition.
#'   Messages will be formatted with [cli::cli_bullets()].
#' @param subclass (`character`) Class(es) to assign to the message. Will be
#'   prefixed by "stbl-message-".
#' @param ... Additional parameters passed to [cli::cli_inform()] and on to
#'   [rlang::inform()].
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @keywords internal
.stbl_inform <- function(
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
) {
  pkg_inform(
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
#' @param from_class (`character(1)`) The class of the object that failed
#'   coercion.
#' @param to_class (`character(1)`) The target class for the coercion.
#' @param additional_msg (`character(1)`) Optional, additional
#'   cli-formatted messages.
#' @inheritParams .stbl_abort
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @keywords internal
.stop_cant_coerce <- function(
  from_class,
  to_class,
  x_arg,
  call,
  additional_msg = NULL,
  message_env = call,
  parent = NULL,
  to_arg = NULL,
  ...
) {
  to_arg <- .check_to_arg(to_arg, call)
  main_msg <- if (is.null(to_arg)) {
    .glue2(
      "Can't coerce {.arg [x_arg]} {.cls [from_class]} to {.cls [to_class]}."
    )
  } else {
    .cant_coerce_msg(from_class, to_class, x_arg, to_arg)
  }
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
#' @inherit .shared-return-conditions return
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
#' @returns A character string.
#' @keywords internal
.define_main_msg <- function(x_arg, msg) {
  .glue2("{.arg [x_arg]} [msg]")
}

#' Abort because an object must not be NULL
#'
#' @inheritParams .stbl_abort
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
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
#' @inheritParams .stbl_abort
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @keywords internal
.stop_incompatible <- function(
  x,
  x_class,
  to,
  failures,
  due_to,
  x_arg,
  call,
  to_arg = NULL,
  parent = NULL,
  ...
) {
  to_class <- object_type(to)
  locations <- which(failures)
  values <- x[locations]
  value_chrs <- as.character(values)
  to_arg <- .check_to_arg(to_arg, call)
  main_msg <- if (is.null(to_arg)) {
    .define_main_msg(
      x_arg,
      "{.cls {x_class}} must be coercible to {.cls {to_class}}"
    )
  } else {
    .cant_coerce_msg(x_class, to_class, x_arg, to_arg)
  }
  .stbl_abort(
    message = c(
      main_msg,
      x = "Can't convert some values due to {due_to}.",
      "*" = "Locations: {locations}",
      "*" = "Values: {.val {value_chrs}}"
    ),
    subclass = c("incompatible_values", to_class),
    call = call,
    message_env = rlang::current_env(),
    parent = parent,
    locations = locations,
    values = values,
    ...
  )
}

#' Define the main message for a coercion failure that names both sides
#'
#' @param from_class (`character(1)`) The class of the object being coerced.
#' @param to_class (`character(1)`) The class being coerced to.
#' @param to_arg (`character(1)`) The name of the coercion target, already
#'   checked with `.check_to_arg()`.
#' @inheritParams .shared-params
#' @returns A character string.
#' @keywords internal
.cant_coerce_msg <- function(from_class, to_class, x_arg, to_arg) {
  .glue2(
    "Can't coerce {.arg [x_arg]} {.cls [from_class]} to match {.arg [to_arg]} {.cls [to_class]}."
  )
}

#' Check that `to_arg` is `NULL` or a single string
#'
#' @inheritParams .shared-params
#' @returns `to_arg`, unchanged, or an error if it is not `NULL` or a string.
#' @keywords internal
.check_to_arg <- function(to_arg, call = caller_env()) {
  if (is.null(to_arg)) {
    return(NULL)
  }
  to_chr_scalar(to_arg, call = call, x_arg = "to_arg")
}
