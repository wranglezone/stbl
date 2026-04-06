#' Compile a message class chain
#'
#' @inheritParams .compile_pkg_condition_classes
#'
#' @returns A character vector of classes.
#' @keywords internal
.compile_pkg_message_classes <- function(package, ...) {
  .compile_pkg_condition_classes(
    package,
    "message",
    ...
  )
}

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
#'
#' @export
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

#' Test package message classes
#'
#' When you use [pkg_inform()] to signal messages, you can use this function to
#' test that those messages are generated as expected.
#'
#' @param object An expression that is expected to throw a message.
#' @inheritParams .compile_pkg_message_classes
#'
#' @returns The classes of the message invisibly on success or the message on
#'   failure. Unlike most testthat expectations, this expectation cannot be
#'   usefully chained.
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
#' @export
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
  rlang::try_fetch(
    object,
    message = function(m) {
      testthat::expect_s3_class(m, expected_classes, exact = TRUE)
    }
  )
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
#'   evaluated. The actual evaluation will occur in a child of this environment,
#'   with [expect_pkg_message_classes()] available even if this package is not
#'   attached.
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
  rlang::check_installed("testthat", "to snapshot-test package messages")
  obj_expr <- rlang::enexpr(object)
  transform_expr <- rlang::enexpr(transform)
  message_class_components <- rlang::list2(...)
  # Inject into a child of the caller's env that can find
  # expect_pkg_message_classes, so this works even when the caller's package
  # doesn't attach stbl.
  inject_env <- new.env(parent = env)
  inject_env$expect_pkg_message_classes <- expect_pkg_message_classes
  rlang::inject(
    testthat::expect_snapshot(
      {
        (expect_pkg_message_classes(
          !!obj_expr,
          !!package,
          !!!message_class_components
        ))
      },
      transform = !!transform_expr,
      variant = !!variant
    ),
    env = inject_env
  )
  # nocov end
}
