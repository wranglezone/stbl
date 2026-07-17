#' Signal a message with standards applied
#'
#' A wrapper around [cli::cli_inform()] to throw classed messages, with an
#' opinionated framework of message classes.
#'
#' @param message (`character`) The message for the new message condition.
#'   Messages will be formatted with [cli::cli_bullets()].
#' @param subclass (`character`) Class(es) to assign to the message. Will be
#'   prefixed by "\{package\}-message-".
#' @param ... Additional parameters passed to [cli::cli_inform()] and on to
#'   [rlang::inform()].
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @export
#'
#' @examples
#' pkg_inform("stbl", "This is a test message", "test_subclass")
#' withCallingHandlers(
#'   pkg_inform("stbl", "This is a test message", "test_subclass"),
#'   `stbl-message` = function(m) {
#'     message("Caught a generic stbl message.")
#'     invokeRestart("muffleMessage")
#'   }
#' )
#' withCallingHandlers(
#'   pkg_inform("stbl", "This is a test message", "test_subclass"),
#'   `stbl-message-test_subclass` = function(m) {
#'     message("Caught a specific subclass of stbl message.")
#'     invokeRestart("muffleMessage")
#'   }
#' )
pkg_inform <- function(
  package,
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
) {
  cli::cli_inform(
    message,
    class = .compile_pkg_message_classes(package, subclass),
    call = call,
    .envir = message_env,
    parent = parent,
    ...
  )
}

#' Compile a message class chain
#'
#' @inheritParams .compile_pkg_condition_classes
#' @returns A character vector of classes.
#' @keywords internal
.compile_pkg_message_classes <- function(package, ...) {
  .compile_pkg_condition_classes(
    package,
    "message",
    ...
  )
}

#' Test package message classes
#'
#' When you use [pkg_inform()] to signal messages, you can use this function to
#' test that those messages are generated as expected.
#'
#' @param object An expression that is expected to throw a message.
#' @inheritParams .compile_pkg_message_classes
#'
#' @returns The message condition invisibly. Assignments made inside `object`
#'   (e.g. `result <- fn_that_informs()`) are visible to the caller after this
#'   function returns. Unlike most testthat expectations, this expectation
#'   cannot be usefully chained.
#' @export
#'
#' @examplesIf rlang::is_installed("testthat")
#' expect_pkg_message_classes(
#'   pkg_inform("stbl", "This is a test message", "test_subclass"),
#'   "stbl",
#'   "test_subclass"
#' )
#' try(
#'   expect_pkg_message_classes(
#'     pkg_inform("stbl", "This is a test message", "test_subclass"),
#'     "stbl",
#'     "different_subclass"
#'   )
#' )
expect_pkg_message_classes <- function(
  object,
  package,
  ...
) {
  rlang::check_installed("testthat", "to check message class expectations")
  expected_classes <- c(
    .compile_pkg_message_classes(package, ...),
    "rlang_message",
    "message",
    "condition"
  )
  captured <- .capture_first_pkg_condition(
    rlang::enexpr(object),
    condition_name = "message",
    muffle_restart = "muffleMessage",
    env = parent.frame()
  )
  if (!is.null(captured)) {
    testthat::expect_s3_class(captured, expected_classes, exact = TRUE)
  }
  invisible(captured)
}

#' Snapshot-test a package message
#'
#' A convenience wrapper around [testthat::expect_snapshot()] and
#' [expect_pkg_message_classes()] that captures both the message class hierarchy
#' and the user-facing message in a single snapshot.
#'
#' @param transform (`function` or `NULL`) Optional function to scrub volatile
#'   output (e.g. temp paths) before snapshot comparison. Passed through to
#'   [testthat::expect_snapshot()].
#' @param variant (`character(1)` or `NULL`) Optional snapshot variant name.
#'   Passed through to [testthat::expect_snapshot()].
#' @param env (`environment`) The environment in which `object` should be
#'   evaluated. Assignments made inside `object` are visible to the caller after
#'   this function returns. [expect_pkg_message_classes()] is temporarily
#'   injected into `env` if it is not already findable, so this works even when
#'   this package is not attached.
#' @inheritParams expect_pkg_message_classes
#'
#' @returns The result of [testthat::expect_snapshot()], invisibly.
#'
#' @export
expect_pkg_message_snapshot <- function(
  object,
  package,
  ...,
  transform = NULL,
  variant = NULL,
  env = caller_env()
) {
  # nocov start
  .expect_pkg_condition_snapshot(
    obj_expr = .strip_covr_from_expr(rlang::enexpr(object)),
    package = package,
    class_components = rlang::list2(...),
    expect_fn_name = "expect_pkg_message_classes",
    expect_fn = expect_pkg_message_classes,
    check_installed_msg = "to snapshot-test package messages",
    transform = transform,
    variant = variant,
    env = env
  )
  # nocov end
}
