#' Compile a warning class chain
#'
#' @inheritParams .compile_pkg_condition_classes
#'
#' @returns A character vector of classes.
#' @keywords internal
.compile_pkg_warning_classes <- function(package, ...) {
  .compile_pkg_condition_classes(
    package,
    "warning",
    ...
  )
}

#' Signal a warning with standards applied
#'
#' A wrapper around [cli::cli_warn()] to throw classed warnings, with an
#' opinionated framework of warning classes.
#'
#' @param message (`character`) The message for the new warning. Messages will
#'   be formatted with [cli::cli_bullets()].
#' @param subclass (`character`) Class(es) to assign to the warning. Will be
#'   prefixed by "\{package\}-warning-".
#' @param ... Additional parameters passed to [cli::cli_warn()] and on to
#'   [rlang::warn()].
#' @inheritParams .shared-params
#' @examples
#' pkg_warn("stbl", "This is a test warning", "test_subclass")
#' withCallingHandlers(
#'   pkg_warn("stbl", "This is a test warning", "test_subclass"),
#'   `stbl-warning` = function(w) {
#'     message("Caught a generic stbl warning.")
#'     invokeRestart("muffleWarning")
#'   }
#' )
#' withCallingHandlers(
#'   pkg_warn("stbl", "This is a test warning", "test_subclass"),
#'   `stbl-warning-test_subclass` = function(w) {
#'     message("Caught a specific subclass of stbl warning.")
#'     invokeRestart("muffleWarning")
#'   }
#' )
#'
#' @export
pkg_warn <- function(
  package,
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
) {
  cli::cli_warn(
    message,
    class = .compile_pkg_warning_classes(package, subclass),
    call = call,
    .envir = message_env,
    parent = parent,
    ...
  )
}

#' Test package warning classes
#'
#' When you use [pkg_warn()] to signal warnings, you can use this function to
#' test that those warnings are generated as expected.
#'
#' @param object An expression that is expected to throw a warning.
#' @inheritParams .compile_pkg_warning_classes
#'
#' @returns The classes of the warning invisibly on success or the warning on
#'   failure. Unlike most testthat expectations, this expectation cannot be
#'   usefully chained.
#' @examplesIf rlang::is_installed("testthat")
#' expect_pkg_warning_classes(
#'   pkg_warn("stbl", "This is a test warning", "test_subclass"),
#'   "stbl",
#'   "test_subclass"
#' )
#' try(
#'   expect_pkg_warning_classes(
#'     pkg_warn("stbl", "This is a test warning", "test_subclass"),
#'     "stbl",
#'     "different_subclass"
#'   )
#' )
#' @export
expect_pkg_warning_classes <- function(
  object,
  package,
  ...
) {
  rlang::check_installed("testthat", "to check warning class expectations")
  expected_classes <- c(
    .compile_pkg_warning_classes(package, ...),
    "rlang_warning",
    "warning",
    "condition"
  )
  rlang::try_fetch(
    object,
    warning = function(w) {
      testthat::expect_s3_class(w, expected_classes, exact = TRUE)
    }
  )
}

#' Snapshot-test a package warning
#'
#' A convenience wrapper around [testthat::expect_snapshot()] and
#' [expect_pkg_warning_classes()] that captures both the warning class hierarchy
#' and the user-facing message in a single snapshot.
#'
#' @param transform (`function` or `NULL`) Optional function to scrub volatile
#'   output (e.g. temp paths) before snapshot comparison. Passed through to
#'   [testthat::expect_snapshot()].
#' @param variant (`character(1)` or `NULL`) Optional snapshot variant name.
#'   Passed through to [testthat::expect_snapshot()].
#' @param env (`environment`) The environment in which `object` should be
#'   evaluated. The actual evaluation will occur in a child of this environment,
#'   with [expect_pkg_warning_classes()] available even if this package is not
#'   attached.
#' @inheritParams expect_pkg_warning_classes
#'
#' @returns The result of [testthat::expect_snapshot()], invisibly.
#'
#' @export
expect_pkg_warning_snapshot <- function(
  object,
  package,
  ...,
  transform = NULL,
  variant = NULL,
  env = caller_env()
) {
  # nocov start
  rlang::check_installed("testthat", "to snapshot-test package warnings")
  obj_expr <- rlang::enexpr(object)
  transform_expr <- rlang::enexpr(transform)
  warning_class_components <- rlang::list2(...)
  # Inject into a child of the caller's env that can find
  # expect_pkg_warning_classes, so this works even when the caller's package
  # doesn't attach stbl.
  inject_env <- new.env(parent = env)
  inject_env$expect_pkg_warning_classes <- expect_pkg_warning_classes
  rlang::inject(
    testthat::expect_snapshot(
      {
        (expect_pkg_warning_classes(
          !!obj_expr,
          !!package,
          !!!warning_class_components
        ))
      },
      transform = !!transform_expr,
      variant = !!variant
    ),
    env = inject_env
  )
  # nocov end
}
