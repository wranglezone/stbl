#' Resolve a time zone
#'
#' Finds the time zone an object is displayed in, falling back to `default` if
#' the object doesn't name one (it lacks a `"tzone"` attribute, or that
#' attribute is `NA`, empty, or `""`).
#'
#' @param x An object, usually a [base::POSIXct] or [base::POSIXlt] vector,
#'   whose `"tzone"` attribute should be used. The default, `NULL`, has no time
#'   zone, so `resolve_tz()` returns `default`.
#' @param default (`character(1)`) The time zone to use if `x` doesn't name one.
#'   Defaults to your local time zone, as reported by [Sys.timezone()]. As in
#'   [to_dttm()], `""` is replaced by the name of your local time zone.
#' @inheritParams .shared-params
#'
#' @returns The name of a time zone from [OlsonNames()] as a character string,
#'   or an error condition with classes `<stbl-error-bad_tz>`, `<stbl-error>`,
#'   `<stbl-condition>`, `<rlang_error>`, `<error>`, `<condition>` when the time
#'   zone cannot be determined or is not a value from [OlsonNames()].
#' @family datetime functions
#' @export
#'
#' @examples
#' resolve_tz()
#' resolve_tz(as.POSIXct("2024-01-01 12:00:00", tz = "America/Chicago"))
#' resolve_tz(Sys.time(), default = "UTC")
#'
#' # Keep the time zone of the input, using your local time zone if it has none.
#' x <- as.POSIXct("2024-01-01 12:00:00", tz = "Asia/Tokyo")
#' to_dttm(x, tz = resolve_tz(x))
#' try(resolve_tz(default = "this is not a timezone"))
resolve_tz <- function(
  x = NULL,
  default = Sys.timezone(),
  call = caller_env()
) {
  tzone <- attr(x, "tzone", exact = TRUE)[1]
  if (is.null(tzone) || is.na(tzone) || !nzchar(tzone)) {
    return(.check_tz(default, x_arg = "default", call = call))
  }
  .check_tz(tzone, call = call)
}

#' Check that a time zone is valid
#'
#' @param tz (`character(1)`) The time zone to validate.
#' @inheritParams .shared-params
#' @returns `tz`, converted to a scalar character, if it is valid and in
#'   [OlsonNames()]. The name of the local time zone if `tz` is `""`.
#' @keywords internal
.check_tz <- function(tz, x_arg = "tz", call = caller_env()) {
  tz <- to_chr_scalar(tz, x_arg = x_arg, call = call)
  is_local <- identical(tz, "")
  if (is_local) {
    tz <- Sys.timezone()
  }
  if (!is.na(tz) && tz %in% OlsonNames()) {
    return(tz)
  }
  .stop_bad_tz(tz, is_local, x_arg, call)
}

#' Abort because a time zone isn't valid
#'
#' @param tz (`character(1)`) The invalid time zone, possibly `NA`.
#' @param is_local (`logical(1)`) Was `tz` found by looking up the local time
#'   zone?
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @keywords internal
.stop_bad_tz <- function(tz, is_local, x_arg, call) {
  if (is_local) {
    msgs <- .bad_tz_msgs_local(tz)
  } else {
    msgs <- list(
      msg = "must be \"\" or a value from {.fun OlsonNames}.",
      additional_msg = c(x = "{.val {tz}} is not a recognized time zone.")
    )
  }
  .stop_must(
    msgs$msg,
    x_arg = x_arg,
    additional_msg = msgs$additional_msg,
    call = call,
    subclass = "bad_tz",
    message_env = rlang::current_env()
  )
}

#' Build error messages for an unresolvable local time zone
#'
#' The messages are cli templates, interpolated in the environment of
#' `.stop_bad_tz()` (so they may refer to `tz` and `x_arg`).
#'
#' @inheritParams .stop_bad_tz
#' @returns A list with elements `msg` and `additional_msg`.
#' @keywords internal
.bad_tz_msgs_local <- function(tz) {
  unrecognized <- if (is.na(tz)) "" else " ({.val {tz}} is not recognized)"
  list(
    msg = "must be a recognized time zone.",
    additional_msg = c(
      x = paste0("Can't determine the local time zone", unrecognized, "."),
      i = "Supply a value from {.fun OlsonNames} as {.arg {x_arg}}."
    )
  )
}
