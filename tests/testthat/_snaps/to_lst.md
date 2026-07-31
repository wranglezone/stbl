# to_lst() respects allow_null (#157)

    Code
      (expect_pkg_error_classes(to_lst(given, allow_null = FALSE), "stbl", "bad_null")
      )
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_lst(given, allow_null = FALSE), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_to_lst()`:
      ! `val` must not be <NULL>.

# to_lst() rejects unused dots for methods that ignore them (#200)

    Code
      to_lst(list(a = 1L), new_arg = "red")
    Condition
      Error:
      ! `...` must be empty.
      x Problematic argument:
      * new_arg = "red"

---

    Code
      wrapped_to_lst(list(a = 1L), new_arg = "red")
    Condition
      Error in `wrapped_to_lst()`:
      ! `...` must be empty.
      x Problematic argument:
      * new_arg = "red"

# to_lst() errors by default for functions (#157)

    Code
      (expect_pkg_error_classes(to_lst(given), "stbl", "bad_function"))
    Output
      <error/stbl-error-bad_function>
      Error:
      ! `given` must not be a <function>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_lst(given), "stbl", "bad_function"))
    Output
      <error/stbl-error-bad_function>
      Error in `wrapped_to_lst()`:
      ! `val` must not be a <function>.

# to_lst() errors informatively for primitives (#157)

    Code
      (expect_pkg_error_classes(to_lst(given, coerce_function = TRUE), "stbl",
      "coerce", "list"))
    Output
      <error/stbl-error-coerce-list>
      Error:
      ! Can't coerce `given` <primitive function> to <list>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_lst(given, coerce_function = TRUE), "stbl",
      "coerce", "list"))
    Output
      <error/stbl-error-coerce-list>
      Error in `wrapped_to_lst()`:
      ! Can't coerce `val` <primitive function> to <list>.

