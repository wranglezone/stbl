# to_list() respects allow_null

    Code
      to_list(given, allow_null = FALSE)
    Condition
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_list(given, allow_null = FALSE)
    Condition
      Error in `wrapped_to_list()`:
      ! `val` must not be <NULL>.

# to_list() errors by default for functions

    Code
      to_list(given)
    Condition
      Error:
      ! `given` must not be a <function>.

---

    Code
      wrapped_to_list(given)
    Condition
      Error in `wrapped_to_list()`:
      ! `val` must not be a <function>.

# to_list() errors informatively for primitives

    Code
      to_list(given, coerce_function = TRUE)
    Condition
      Error:
      ! Can't coerce `given` <primitive function> to <list>.

---

    Code
      wrapped_to_list(given, coerce_function = TRUE)
    Condition
      Error in `wrapped_to_list()`:
      ! Can't coerce `val` <primitive function> to <list>.

