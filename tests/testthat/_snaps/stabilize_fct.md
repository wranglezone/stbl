# stabilize_fct() throws errors for bad levels (#62)

    Code
      stabilize_fct(letters[1:5], levels = c("a", "c"), to_na = "b")
    Condition
      Error:
      ! Each value of `letters[1:5]` must be in the expected levels.
      i Allowed levels: "a" and "c".
      i Values that are converted to `NA`: "b".
      x Unexpected values: "d" and "e".

---

    Code
      wrapped_stabilize_fct(letters[1:5], levels = c("a", "c"), to_na = "b")
    Condition
      Error in `wrapped_stabilize_fct()`:
      ! Each value of `val` must be in the expected levels.
      i Allowed levels: "a" and "c".
      i Values that are converted to `NA`: "b".
      x Unexpected values: "d" and "e".

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

