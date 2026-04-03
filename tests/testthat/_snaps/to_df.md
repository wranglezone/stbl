# to_df() respects allow_null (#199)

    Code
      to_df(NULL, allow_null = FALSE)
    Condition
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      wrapped_to_df(NULL, allow_null = FALSE)
    Condition
      Error in `wrapped_to_df()`:
      ! `val` must not be <NULL>.

# to_df() errors for a list with incompatible column lengths (#199)

    Code
      to_df(list(a = 1:3, b = 1:2))
    Condition
      Error:
      ! Can't coerce `list(a = 1:3, b = 1:2)` <list> to <data.frame>.

---

    Code
      wrapped_to_df(list(a = 1:3, b = 1:2))
    Condition
      Error in `wrapped_to_df()`:
      ! Can't coerce `val` <list> to <data.frame>.

# to_df() errors for non-coercible types (#199)

    Code
      to_df("not a data frame")
    Condition
      Error:
      ! Can't coerce `"not a data frame"` <character> to <data.frame>.

---

    Code
      wrapped_to_df("not a data frame")
    Condition
      Error in `wrapped_to_df()`:
      ! Can't coerce `val` <character> to <data.frame>.

