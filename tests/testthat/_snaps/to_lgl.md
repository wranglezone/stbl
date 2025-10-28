# to_lgl() respects allow_null (#21)

    Code
      to_lgl(given, allow_null = FALSE)
    Condition
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_lgl(given, allow_null = FALSE)
    Condition
      Error in `wrapped_to_lgl()`:
      ! `val` must not be <NULL>.

# to_lgl() errors for bad characters (#21)

    Code
      to_lgl(letters)
    Condition
      Error:
      ! `letters` <character> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ..., 25, and 26

---

    Code
      wrapped_to_lgl(letters)
    Condition
      Error in `wrapped_to_lgl()`:
      ! `val` <character> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ..., 25, and 26

# to_lgl errors for bad factors (#21)

    Code
      to_lgl(given)
    Condition
      Error:
      ! `given` <factor> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ..., 25, and 26

---

    Code
      wrapped_to_lgl(given)
    Condition
      Error in `wrapped_to_lgl()`:
      ! `val` <factor> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ..., 25, and 26

# to_lgl() errors for other types (#21)

    Code
      to_lgl(given)
    Condition
      Error:
      ! Can't coerce `given` <list> to <logical>.

---

    Code
      wrapped_to_lgl(given)
    Condition
      Error in `wrapped_to_lgl()`:
      ! Can't coerce `val` <list> to <logical>.

---

    Code
      to_lgl(given)
    Condition
      Error:
      ! Can't coerce `given` <function> to <logical>.

---

    Code
      wrapped_to_lgl(given)
    Condition
      Error in `wrapped_to_lgl()`:
      ! Can't coerce `val` <function> to <logical>.

# to_lgl_scalar() errors for non-scalars (#32)

    Code
      to_lgl_scalar(given)
    Condition
      Error:
      ! `given` must be a single <logical>.
      x `given` has 3 values.

---

    Code
      wrapped_to_lgl_scalar(given)
    Condition
      Error in `wrapped_to_lgl_scalar()`:
      ! `val` must be a single <logical>.
      x `val` has 3 values.

# to_lgl_scalar() errors for bad characters (#32)

    Code
      to_lgl_scalar(given)
    Condition
      Error:
      ! `given` <character> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1

---

    Code
      wrapped_to_lgl_scalar(given)
    Condition
      Error in `wrapped_to_lgl_scalar()`:
      ! `val` <character> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1

# to_lgl_scalar() respects allow_null (#32)

    Code
      to_lgl_scalar(given, allow_null = FALSE)
    Condition
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_lgl_scalar(given, allow_null = FALSE)
    Condition
      Error in `wrapped_to_lgl_scalar()`:
      ! `val` must not be <NULL>.

