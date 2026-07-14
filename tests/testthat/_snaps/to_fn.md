# to_fn() respects allow_null for NULL input (#250)

    Code
      to_fn(NULL, allow_null = FALSE)
    Condition
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      wrapped_to_fn(NULL, allow_null = FALSE)
    Condition
      Error in `wrapped_to_fn()`:
      ! `val` must not be <NULL>.

# to_fn() errors informatively for unknown character names (#250)

    Code
      to_fn("not_a_real_function_xyz")
    Condition
      Error in `get()`:
      ! object 'not_a_real_function_xyz' of mode 'function' was not found

---

    Code
      wrapped_to_fn("not_a_real_function_xyz")
    Condition
      Error in `get()`:
      ! object 'not_a_real_function_xyz' of mode 'function' was not found

# to_fn() errors for length > 1 character input (#250)

    Code
      to_fn(c("mean", "sum"))
    Condition
      Error:
      ! `c("mean", "sum")` must be a single function name.
      x `c("mean", "sum")` has 2 values.

---

    Code
      wrapped_to_fn(c("mean", "sum"))
    Condition
      Error in `wrapped_to_fn()`:
      ! `val` must be a single function name.
      x `val` has 2 values.

# to_fn() respects allow_null for length-0 character input (#250)

    Code
      to_fn(character(), allow_null = FALSE)
    Condition
      Error:
      ! `character()` must not be <NULL>.

# to_fn() errors informatively for bad namespaced names (#250)

    Code
      to_fn("nonexistent_pkg::mean")
    Condition
      Error in `loadNamespace()`:
      ! there is no package called 'nonexistent_pkg'

# to_fn() errors informatively for non-coercible types (#250)

    Code
      to_fn(1L)
    Condition
      Error:
      ! Can't convert `1L`, an integer vector, to a function.

