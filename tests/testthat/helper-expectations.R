# `rlang::enexpr()` is used instead of `rlang::enquo()` because `inject()`
# splices a quosure as `^(expr)`, which breaks `expect_snapshot()`'s internal
# `parse(deparse(x))` round-trip. `enexpr()` captures only the bare expression,
# so the snapshot's Code section shows the full inner call transparently.
#
# The `call` parameter (defaulting to `caller_env()`) is forwarded to `inject()`
# as `env =` so that `expect_snapshot()` is evaluated in the test's environment.
# Without this, local variables in the expression (e.g. `tmp`) would be out of
# scope.
#
# The `transform` parameter is forwarded to `expect_snapshot()` to allow callers
# to scrub volatile values (e.g. temp paths) before snapshot comparison.
expect_pkg_error_snapshot <- function(
  object,
  error_class_component,
  package = "stbl",
  transform = NULL,
  call = caller_env()
) {
  obj_expr <- rlang::enexpr(object)
  transform_expr <- rlang::enexpr(transform)
  rlang::inject(
    expect_snapshot(
      {
        (expect_pkg_error_classes(
          !!obj_expr,
          !!package,
          !!error_class_component
        ))
      },
      transform = !!transform_expr
    ),
    env = call
  )
}

# Used to scrub temp paths from snapshots.
.transform_path <- function(path) {
  function(x) {
    stringr::str_replace_all(
      x,
      stringr::fixed(as.character(path)),
      "PATH"
    )
  }
}
