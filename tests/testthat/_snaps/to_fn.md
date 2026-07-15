# to_fn() respects allow_null for NULL input (#250)

    Code
      (expect_pkg_error_classes(to_fn(NULL, allow_null = FALSE), "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_fn(NULL, allow_null = FALSE), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_to_fn()`:
      ! `val` must not be <NULL>.

# to_fn() fails cleanly for weird ':' use in character names (#250)

    Code
      (expect_pkg_error_classes(to_fn("base:mean"), "stbl", "invalid_function_name"))
    Output
      <error/stbl-error-invalid_function_name>
      Error:
      ! `"base:mean"` must be a valid function name.

---

    Code
      (expect_pkg_error_classes(to_fn("base::mean::thing"), "stbl",
      "invalid_function_name"))
    Output
      <error/stbl-error-invalid_function_name>
      Error:
      ! `"base::mean::thing"` must be a valid function name.

---

    Code
      (expect_pkg_error_classes(to_fn("base::mean:thing"), "stbl",
      "invalid_function_name"))
    Output
      <error/stbl-error-invalid_function_name>
      Error:
      ! `"base::mean:thing"` must be a valid function name.

---

    Code
      (expect_pkg_error_classes(to_fn("base:mean:thing"), "stbl",
      "invalid_function_name"))
    Output
      <error/stbl-error-invalid_function_name>
      Error:
      ! `"base:mean:thing"` must be a valid function name.

---

    Code
      (expect_pkg_error_classes(to_fn("base:mean::thing"), "stbl",
      "invalid_function_name"))
    Output
      <error/stbl-error-invalid_function_name>
      Error:
      ! `"base:mean::thing"` must be a valid function name.

# to_fn() errors informatively for unknown character names (#250)

    Code
      (expect_pkg_error_classes(to_fn("not_a_real_function_xyz"), "stbl",
      "unknown_function"))
    Output
      <error/stbl-error-unknown_function>
      Error:
      ! `"not_a_real_function_xyz"` must be the name of a known function.
      x Can't find function `not_a_real_function_xyz()`.

---

    Code
      (expect_pkg_error_classes(wrapped_to_fn("not_a_real_function_xyz"), "stbl",
      "unknown_function"))
    Output
      <error/stbl-error-unknown_function>
      Error in `wrapped_to_fn()`:
      ! `val` must be the name of a known function.
      x Can't find function `not_a_real_function_xyz()`.

# to_fn() errors for length > 1 character input (#250)

    Code
      (expect_pkg_error_classes(to_fn(c("mean", "sum")), "stbl", "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error:
      ! `c("mean", "sum")` must be a single function name.
      x `c("mean", "sum")` has 2 values.

---

    Code
      (expect_pkg_error_classes(wrapped_to_fn(c("mean", "sum")), "stbl", "non_scalar")
      )
    Output
      <error/stbl-error-non_scalar>
      Error in `wrapped_to_fn()`:
      ! `val` must be a single function name.
      x `val` has 2 values.

# to_fn() respects allow_null for length-0 character input (#250)

    Code
      (expect_pkg_error_classes(to_fn(character(), allow_null = FALSE), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `character()` must not be <NULL>.

# to_fn() errors informatively for bad namespaced names (#250)

    Code
      (expect_pkg_error_classes(to_fn("nonexistent_pkg::mean"), "stbl",
      "unknown_function"))
    Output
      <error/stbl-error-unknown_function>
      Error:
      ! `"nonexistent_pkg::mean"` must be the name of a known function.
      x Can't find function `nonexistent_pkg::mean()`.

# to_fn() errors informatively for non-coercible types (#250)

    Code
      (expect_pkg_error_classes(to_fn(1L), "stbl", "coerce", "function"))
    Output
      <error/stbl-error-coerce-function>
      Error:
      ! Can't coerce `1L` <integer> to <function>.

