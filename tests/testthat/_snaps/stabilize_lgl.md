# stabilize_lgl() checks NAs (#28)

    Code
      stabilize_lgl(given, allow_na = FALSE)
    Condition
      Error:
      ! `given` must not contain NA values.
      * NA locations: 2

---

    Code
      wrapped_stabilize_lgl(given, allow_na = FALSE)
    Condition
      Error in `wrapped_stabilize_lgl()`:
      ! `val` must not contain NA values.
      * NA locations: 2

# stabilize_lgl() checks min_size (#28)

    Code
      stabilize_lgl(given, min_size = 5)
    Condition
      Error:
      ! `given` must have size >= 5.
      x 4 is too small.

---

    Code
      wrapped_stabilize_lgl(given, min_size = 5)
    Condition
      Error in `wrapped_stabilize_lgl()`:
      ! `val` must have size >= 5.
      x 4 is too small.

# stabilize_lgl() checks max_size (#28)

    Code
      stabilize_lgl(given, max_size = 3)
    Condition
      Error:
      ! `given` must have size <= 3.
      x 4 is too big.

---

    Code
      wrapped_stabilize_lgl(given, max_size = 3)
    Condition
      Error in `wrapped_stabilize_lgl()`:
      ! `val` must have size <= 3.
      x 4 is too big.

# stabilize_lgl_scalar() errors on non-scalars (#28)

    Code
      stabilize_lgl_scalar(given)
    Condition
      Error:
      ! `given` must be a single <logical>.
      x `given` has 3 values.

---

    Code
      wrapped_stabilize_lgl_scalar(given)
    Condition
      Error in `wrapped_stabilize_lgl_scalar()`:
      ! `val` must be a single <logical>.
      x `val` has 3 values.

