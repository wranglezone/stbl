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
#' @inherit .shared-return-conditions return
#' @export
#'
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

#' Compile a warning class chain
#'
#' @inheritParams .compile_pkg_condition_classes
#' @returns A character vector of classes.
#' @keywords internal
.compile_pkg_warning_classes <- function(package, ...) {
  .compile_pkg_condition_classes(
    package,
    "warning",
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
#' @returns The warning condition invisibly. Assignments made inside `object`
#'   (e.g. `result <- fn_that_warns()`) are visible to the caller after this
#'   function returns. Unlike most testthat expectations, this expectation
#'   cannot be usefully chained.
#' @export
#'
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
  captured <- .capture_first_pkg_condition(
    rlang::enexpr(object),
    condition_name = "warning",
    muffle_restart = "muffleWarning",
    env = parent.frame()
  )
  if (!is.null(captured)) {
    testthat::expect_s3_class(captured, expected_classes, exact = TRUE)
  }
  invisible(captured)
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
#'   evaluated. Assignments made inside `object` are visible to the caller after
#'   this function returns. [expect_pkg_warning_classes()] is temporarily
#'   injected into `env` if it is not already findable, so this works even when
#'   this package is not attached.
#' @inheritParams expect_pkg_warning_classes
#'
#' @returns The result of [testthat::expect_snapshot()], invisibly.
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
  .expect_pkg_condition_snapshot(
    obj_expr = .strip_covr_from_expr(rlang::enexpr(object)),
    package = package,
    class_components = rlang::list2(...),
    expect_fn_name = "expect_pkg_warning_classes",
    expect_fn = expect_pkg_warning_classes,
    check_installed_msg = "to snapshot-test package warnings",
    transform = transform,
    variant = variant,
    env = env
  )
  # nocov end
}
