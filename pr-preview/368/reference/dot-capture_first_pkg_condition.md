# Capture the first condition thrown by an expression

Capture the first condition thrown by an expression

## Usage

``` r
.capture_first_pkg_condition(obj_expr, condition_name, muffle_restart, env)
```

## Arguments

- obj_expr:

  An unevaluated expression (from
  [`rlang::enexpr()`](https://rlang.r-lib.org/reference/defusing-advanced.html)).

- condition_name:

  (`character(1)`) The condition class to catch (e.g. `"warning"` or
  `"message"`).

- muffle_restart:

  (`character(1)`) The restart to invoke after capturing (e.g.
  `"muffleWarning"` or `"muffleMessage"`).

- env:

  (`environment`) The environment in which to evaluate `obj_expr`.
  Assignments in `obj_expr` land here.

## Value

The first matching condition invisibly, or `NULL` if none signalled.
