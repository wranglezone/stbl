# to_df() respects allow_null (#201)

    Code
      to_df(NULL, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      wrapped_to_df(NULL, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_df()`:
      ! `val` must not be <NULL>.

# to_df() rejects unused dots for methods that ignore them (#200)

    Code
      to_df(mtcars, new_arg = "red")
    Condition
      Error:
      ! `...` must be empty.
      x Problematic argument:
      * new_arg = "red"

---

    Code
      wrapped_to_df(mtcars, new_arg = "red")
    Condition
      Error in `wrapped_to_df()`:
      ! `...` must be empty.
      x Problematic argument:
      * new_arg = "red"

# to_df() errors for a list with incompatible column lengths (#201)

    Code
      to_df(list(a = 1:3, b = 1:2))
    Condition <stbl-error-jagged>
      Error:
      ! Can't coerce `list(a = 1:3, b = 1:2)` <list> to <data.frame>.
      i All list elements must have length 3 or 1.
      x Short elements: b = 2.

---

    Code
      wrapped_to_df(list(a = 1:3, b = 1:2))
    Condition <stbl-error-jagged>
      Error in `wrapped_to_df()`:
      ! Can't coerce `val` <list> to <data.frame>.
      i All list elements must have length 3 or 1.
      x Short elements: b = 2.

# to_df() errors for an unnamed list (#203)

    Code
      to_df(list(1, 2))
    Condition <stbl-error-bad_named>
      Error:
      ! `list(1, 2)` must have all elements named.

# to_df() errors for non-coercible types (#201)

    Code
      to_df("not a data frame")
    Condition <stbl-error-coerce-data.frame>
      Error:
      ! Can't coerce `"not a data frame"` <character> to <data.frame>.

# to_df.default() errors for non-coercible types (#201)

    Code
      to_df(as.Date("2024-01-01"))
    Condition <stbl-error-coerce-data.frame>
      Error:
      ! Can't coerce `as.Date("2024-01-01")` <Date> to <data.frame>.

