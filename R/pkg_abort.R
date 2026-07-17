#' Signal an error with standards applied
#'
#' A wrapper around [cli::cli_abort()] to throw classed errors, with an
#' opinionated framework of error classes.
#'
#' @param message (`character`) The message for the new error. Messages will be
#'   formatted with [cli::cli_bullets()].
#' @param subclass (`character`) Class(es) to assign to the error. Will be
#'   prefixed by "\{package\}-error-".
#' @param ... Additional parameters passed to [cli::cli_abort()] and on to
#'   [rlang::abort()].
#' @inheritParams .shared-params
#' @inherit .shared-return-conditions return
#' @export
#'
#' @examples
#' try(pkg_abort("stbl", "This is a test error", "test_subclass"))
#' tryCatch(
#'   pkg_abort("stbl", "This is a test error", "test_subclass"),
#'   `stbl-error` = function(e) {
#'     "Caught a generic stbl error."
#'   }
#' )
#' tryCatch(
#'   pkg_abort("stbl", "This is a test error", "test_subclass"),
#'   `stbl-error-test_subclass` = function(e) {
#'     "Caught a specific subclass of stbl error."
#'   }
#' )
pkg_abort <- function(
  package,
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
) {
  cli::cli_abort(
    message,
    class = .compile_pkg_error_classes(package, subclass),
    call = call,
    .envir = message_env,
    parent = parent,
    ...
  )
}

#' Compile an error class chain
#'
#' @inheritParams .compile_pkg_condition_classes
#' @returns A character vector of classes.
#' @keywords internal
.compile_pkg_error_classes <- function(package, ...) {
  .compile_pkg_condition_classes(
    package,
    "error",
    ...
  )
}

#' Test package error classes
#'
#' When you use [pkg_abort()] to signal errors, you can use this function to
#' test that those errors are generated as expected.
#'
#' @param object An expression that is expected to throw an error.
#' @inheritParams .compile_pkg_error_classes
#'
#' @returns The classes of the error invisibly on success or the error on
#'   failure. Unlike most testthat expectations, this expectation cannot be
#'   usefully chained.
#' @export
#'
#' @examplesIf rlang::is_installed("testthat")
#' expect_pkg_error_classes(
#'   pkg_abort("stbl", "This is a test error", "test_subclass"),
#'   "stbl",
#'   "test_subclass"
#' )
#' try(
#'   expect_pkg_error_classes(
#'     pkg_abort("stbl", "This is a test error", "test_subclass"),
#'     "stbl",
#'     "different_subclass"
#'   )
#' )
expect_pkg_error_classes <- function(
  object,
  package,
  ...
) {
  rlang::check_installed("testthat", "to check error class expectations")
  expected_classes <- c(
    .compile_pkg_error_classes(package, ...),
    "rlang_error",
    "error",
    "condition"
  )
  rlang::try_fetch(
    object,
    error = function(e) {
      testthat::expect_s3_class(e, expected_classes, exact = TRUE)
    }
  )
}

#' Check if an expression is a covr counter call
#'
#' covr instruments code by wrapping expressions in
#' `if (TRUE) { covr:::count(key); original }` blocks. This checks whether
#' `expr` is the `covr:::count(key)` part.
#'
#' @param expr An R expression.
#' @returns `TRUE` if `expr` is a covr counter call, `FALSE` otherwise.
#' @keywords internal
.is_covr_count_call <- function(expr) {
  is.call(expr) &&
    identical(
      expr[[1L]],
      call(":::", as.symbol("covr"), as.symbol("count"))
    )
}

#' Strip covr counter wrappers from an expression
#'
#' covr instruments code for coverage by wrapping expressions in
#' `if (TRUE) { covr:::count(key); original }` blocks. This function
#' recursively removes those wrappers so that snapshotted code remains stable
#' across normal and coverage runs.
#'
#' @param expr An R expression (e.g. as returned by [rlang::enexpr()]).
#' @returns The expression with all covr counter blocks removed.
#' @keywords internal
.strip_covr_from_expr <- function(expr) {
  if (is.null(expr) || !is.call(expr)) {
    return(expr)
  }
  # Detect covr wrapper: if (TRUE) { covr:::count(key); ... }
  if (
    identical(expr[[1L]], as.name("if")) &&
      length(expr) == 3L &&
      isTRUE(expr[[2L]])
  ) {
    inner <- expr[[3L]]
    if (
      is.call(inner) &&
        identical(inner[[1L]], as.name("{")) &&
        .is_covr_count_call(inner[[2L]])
    ) {
      if (length(inner) == 3L) {
        # Normal case: { counter; original } -> unwrap to original
        return(.strip_covr_from_expr(inner[[3L]]))
      }
      if (length(inner) == 2L) {
        # Degenerate case: { counter } only, produced when covr instruments a
        # splice site (e.g. `!!!list()`) that expands to nothing. Signal the
        # parent `{` block to drop this statement entirely.
        return(NULL)
      }
    }
  }
  # For `{` blocks, filter out any NULL results (statements dropped above).
  if (identical(expr[[1L]], as.name("{"))) {
    stmts <- Filter(
      Negate(is.null),
      lapply(as.list(expr[-1L]), .strip_covr_from_expr)
    )
    return(as.call(c(list(as.name("{")), stmts)))
  }
  as.call(lapply(as.list(expr), .strip_covr_from_expr))
}

#' Snapshot-test a package error
#'
#' A convenience wrapper around [testthat::expect_snapshot()] and
#' [expect_pkg_error_classes()] that captures both the error class hierarchy and
#' the user-facing message in a single snapshot.
#'
#' @param transform (`function` or `NULL`) Optional function to scrub volatile
#'   output (e.g. temp paths) before snapshot comparison. Passed through to
#'   [testthat::expect_snapshot()].
#' @param variant (`character(1)` or `NULL`) Optional snapshot variant name.
#'   Passed through to [testthat::expect_snapshot()].
#' @param env (`environment`) The environment in which `object` should be
#'   evaluated. Assignments made inside `object` are visible to the caller after
#'   this function returns. [expect_pkg_error_classes()] is temporarily injected
#'   into `env` if it is not already findable, so this works even when this
#'   package is not attached.
#' @inheritParams expect_pkg_error_classes
#'
#' @returns The result of [testthat::expect_snapshot()], invisibly.
#' @export
expect_pkg_error_snapshot <- function(
  object,
  package,
  ...,
  transform = NULL,
  variant = NULL,
  env = caller_env()
) {
  # nocov start
  rlang::check_installed("testthat", "to snapshot-test package errors")
  obj_expr <- .strip_covr_from_expr(rlang::enexpr(object))
  error_class_components <- rlang::list2(...)
  # Inject expect_pkg_error_classes into env if not already findable, so this
  # works even when the caller's package doesn't attach stbl. Evaluating
  # directly in env (rather than a child) ensures assignments inside object are
  # visible to the caller after this function returns.
  if (!exists("expect_pkg_error_classes", envir = env, inherits = TRUE)) {
    env$expect_pkg_error_classes <- expect_pkg_error_classes
    on.exit(rm("expect_pkg_error_classes", envir = env), add = TRUE)
  }
  # Build the call to expect_snapshot() at runtime with rlang::call2() so it
  # carries no source-reference attributes. covr attaches counter calls to
  # source references; a runtime-built expression has none, so the snapshot
  # Code section stays stable across normal and coverage runs.
  snap_call <- rlang::call2(
    "expect_snapshot",
    rlang::call2(
      "(",
      rlang::call2(
        "expect_pkg_error_classes",
        obj_expr,
        package,
        !!!error_class_components
      )
    ),
    transform = transform,
    variant = variant,
    .ns = "testthat"
  )
  eval(snap_call, envir = env)
  # nocov end
}
