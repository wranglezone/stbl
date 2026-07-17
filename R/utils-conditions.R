#' Capture the first condition thrown by an expression
#'
#' @param obj_expr An unevaluated expression (from [rlang::enexpr()]).
#' @param condition_name (`character(1)`) The condition class to catch (e.g.
#'   `"warning"` or `"message"`).
#' @param muffle_restart (`character(1)`) The restart to invoke after capturing
#'   (e.g. `"muffleWarning"` or `"muffleMessage"`).
#' @param env (`environment`) The environment in which to evaluate `obj_expr`.
#'   Assignments in `obj_expr` land here.
#' @returns The first matching condition invisibly, or `NULL` if none signalled.
#' @keywords internal
.capture_first_pkg_condition <- function(
  obj_expr,
  condition_name,
  muffle_restart,
  env
) {
  captured <- NULL
  handler <- function(cond) {
    if (is.null(captured)) {
      captured <<- cond
      invokeRestart(muffle_restart)
    }
  }
  handlers <- rlang::list2(!!condition_name := handler)
  # Build withCallingHandlers(obj_expr, <condition_name> = handler) and eval in
  # env so that (a) handlers are active during evaluation, and (b) assignments
  # inside obj_expr land in env rather than an intermediate frame.
  eval(
    rlang::call2("withCallingHandlers", obj_expr, !!!handlers),
    envir = env
  )
  invisible(captured)
}

#' Snapshot-test a package condition
#'
#' @param obj_expr An unevaluated expression (from [rlang::enexpr()]).
#' @param class_components (`list`) Passed as `...` to `expect_fn`.
#' @param expect_fn_name (`character(1)`) Name of the class-checking expectation
#'   to look up or inject into `env`.
#' @param expect_fn (`function`) The function to inject if not already findable.
#' @param check_installed_msg (`character(1)`) The `"to ..."` string passed to
#'   [rlang::check_installed()].
#' @inheritParams expect_pkg_warning_snapshot
#' @returns The result of [testthat::expect_snapshot()], invisibly.
#' @keywords internal
.expect_pkg_condition_snapshot <- function(
  obj_expr,
  package,
  class_components,
  expect_fn_name,
  expect_fn,
  check_installed_msg,
  transform,
  variant,
  env
) {
  # nocov start
  rlang::check_installed("testthat", check_installed_msg)
  if (!exists(expect_fn_name, envir = env, inherits = TRUE)) {
    env[[expect_fn_name]] <- expect_fn
    on.exit(rm(list = expect_fn_name, envir = env), add = TRUE)
  }
  snap_call <- rlang::call2(
    "expect_snapshot",
    rlang::call2(
      "(",
      rlang::call2(
        expect_fn_name,
        obj_expr,
        package,
        !!!class_components
      )
    ),
    transform = transform,
    variant = variant,
    .ns = "testthat"
  )
  eval(snap_call, envir = env)
  # nocov end
}

#' Compile a condition class chain
#'
#' @param ... `(character)` Components of the class name, from least-specific to
#'   most.
#' @inheritParams .shared-params
#' @returns A character vector.
#' @keywords internal
.compile_pkg_condition_classes <- function(package, ...) {
  dots <- unlist(list(...))
  accumulated <- vector("character", length = length(dots))
  for (i in seq_along(dots)) {
    accumulated[[i]] <- .compile_dash(package, .collapse_dash(dots[seq_len(i)]))
  }
  c(rev(accumulated), .compile_dash(package, "condition"))
}

#' Paste together with - separator
#'
#' @param ... Things to paste.
#' @returns A length-1 character vector.
#' @keywords internal
.compile_dash <- function(...) {
  paste(..., sep = "-")
}

#' Paste together collapsing with -
#'
#' @param ... Things to paste.
#' @returns A length-1 character vector.
#' @keywords internal
.collapse_dash <- function(...) {
  paste(..., collapse = "-")
}
