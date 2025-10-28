# stabilize_arg() complains about weird args (#11)

    Code
      stabilize_arg(1L, new_arg = "red")
    Condition
      Error:
      ! `...` must be empty.
      x Problematic argument:
      * new_arg = "red"

---

    Code
      wrapped_stabilize_arg(1L, new_arg = "red")
    Condition
      Error in `wrapped_stabilize_arg()`:
      ! `...` must be empty.
      x Problematic argument:
      * new_arg = "red"

# stabilize_arg() rejects NULLs when asked (#11)

    Code
      stabilize_arg(given, allow_null = FALSE)
    Condition
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_stabilize_arg(given, allow_null = FALSE)
    Condition
      Error in `wrapped_stabilize_arg()`:
      ! `val` must not be <NULL>.

# stabilize_arg() checks NAs (#11)

    Code
      stabilize_arg(given, allow_na = FALSE)
    Condition
      Error:
      ! `given` must not contain NA values.
      * NA locations: 4 and 7

---

    Code
      wrapped_stabilize_arg(given, allow_na = FALSE)
    Condition
      Error in `wrapped_stabilize_arg()`:
      ! `val` must not contain NA values.
      * NA locations: 4 and 7

# stabilize_arg() checks size args (#11)

    Code
      stabilize_arg(given, min_size = 2, max_size = 1)
    Condition
      Error:
      ! `min_size` can't be larger than `max_size`.
      * `min_size` = 2
      * `max_size` = 1

---

    Code
      wrapped_stabilize_arg(given, min_size = 2, max_size = 1)
    Condition
      Error in `wrapped_stabilize_arg()`:
      ! `min_size` can't be larger than `max_size`.
      * `min_size` = 2
      * `max_size` = 1

# stabilize_arg() checks min_size (#11)

    Code
      stabilize_arg(given, min_size = 11)
    Condition
      Error:
      ! `given` must have size >= 11.
      x 3 is too small.

---

    Code
      wrapped_stabilize_arg(given, min_size = 11)
    Condition
      Error in `wrapped_stabilize_arg()`:
      ! `val` must have size >= 11.
      x 3 is too small.

# stabilize_arg() checks max_size (#11)

    Code
      stabilize_arg(given, max_size = 2)
    Condition
      Error:
      ! `given` must have size <= 2.
      x 3 is too big.

---

    Code
      wrapped_stabilize_arg(given, max_size = 2)
    Condition
      Error in `wrapped_stabilize_arg()`:
      ! `val` must have size <= 2.
      x 3 is too big.

# stabilize_arg_scalar() errors for non-scalars (#12)

    Code
      stabilize_arg_scalar(given)
    Condition
      Error:
      ! `given` must be a single <integer>.
      x `given` has 10 values.

---

    Code
      wrapped_stabilize_arg_scalar(given)
    Condition
      Error in `wrapped_stabilize_arg_scalar()`:
      ! `val` must be a single <integer>.
      x `val` has 10 values.

# stabilize_arg_scalar() respects allow_null (#12)

    Code
      stabilize_arg_scalar(given, allow_null = FALSE)
    Condition
      Error:
      ! `given` must be a single <non-NULL>.
      x `given` has no values.

---

    Code
      wrapped_stabilize_arg_scalar(given, allow_null = FALSE)
    Condition
      Error in `wrapped_stabilize_arg_scalar()`:
      ! `val` must be a single <non-NULL>.
      x `val` has no values.

# stabilize_arg_scalar() errors on weird internal arg values (#12)

    Code
      stabilize_arg_scalar(given, allow_null = c(TRUE, FALSE))
    Condition
      Error:
      ! `allow_null` must be a single <logical>.
      x `allow_null` has 2 values.

