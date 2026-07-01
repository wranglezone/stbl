# to_lst() respects allow_null (#157)

    Code
      to_lst(given, allow_null = FALSE)
    Condition
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_lst(given, allow_null = FALSE)
    Condition
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
      to_lst(given)
    Condition
      Error:
      ! `given` must not be a <function>.

---

    Code
      wrapped_to_lst(given)
    Condition
      Error in `wrapped_to_lst()`:
      ! `val` must not be a <function>.

# to_lst() errors informatively for primitives (#157)

    Code
      to_lst(given, coerce_function = TRUE)
    Condition
      Error:
      ! Can't coerce `given` <primitive function> to <list>.

---

    Code
      wrapped_to_lst(given, coerce_function = TRUE)
    Condition
      Error in `wrapped_to_lst()`:
      ! Can't coerce `val` <primitive function> to <list>.

