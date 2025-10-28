# stabilize_fct() throws errors for bad levels (#62)

    Code
      stabilize_fct(letters[1:5], levels = c("a", "c"), to_na = "b")
    Condition
      Error:
      ! All values of `letters[1:5]` must be present in `levels` or `to_na`.
      i Disallowed values: d and e
      i Allowed values: a and c
      i Values that will be converted to `NA`: b

---

    Code
      wrapped_stabilize_fct(letters[1:5], levels = c("a", "c"), to_na = "b")
    Condition
      Error in `wrapped_stabilize_fct()`:
      ! All values of `val` must be present in `levels` or `to_na`.
      i Disallowed values: d and e
      i Allowed values: a and c
      i Values that will be converted to `NA`: b

# stabilize_fct_scalar() errors for non-scalars (#62)

    Code
      stabilize_fct_scalar(given)
    Condition
      Error:
      ! `given` must be a single <factor>.
      x `given` has 26 values.

---

    Code
      wrapped_stabilize_fct_scalar(given)
    Condition
      Error in `wrapped_stabilize_fct_scalar()`:
      ! `val` must be a single <factor>.
      x `val` has 26 values.

