# to_int() respects allow_null (#2)

    Code
      to_int(given, allow_null = FALSE)
    Condition
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_int(given, allow_null = FALSE)
    Condition
      Error in `wrapped_to_int()`:
      ! `val` must not be <NULL>.

# to_int() respects coerce_character (#14)

    Code
      to_int(given, coerce_character = FALSE)
    Condition
      Error:
      ! Can't coerce `given` <character> to <integer>.

---

    Code
      wrapped_to_int(given, coerce_character = FALSE)
    Condition
      Error in `wrapped_to_int()`:
      ! Can't coerce `val` <character> to <integer>.

# to_int() errors informatively for bad chrs (#2)

    Code
      to_int(given)
    Condition
      Error:
      ! `given` <character> must be coercible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4

---

    Code
      wrapped_to_int(given)
    Condition
      Error in `wrapped_to_int()`:
      ! `val` <character> must be coercible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4

---

    Code
      to_int(given)
    Condition
      Error:
      ! `given` <character> must be coercible to <integer>
      x Can't convert some values due to incompatible values.
      * Locations: 4

---

    Code
      wrapped_to_int(given)
    Condition
      Error in `wrapped_to_int()`:
      ! `val` <character> must be coercible to <integer>
      x Can't convert some values due to incompatible values.
      * Locations: 4

# to_int() errors informatively for bad complexes (#2)

    Code
      to_int(given)
    Condition
      Error:
      ! `given` <complex> must be coercible to <integer>
      x Can't convert some values due to non-zero complex components.
      * Locations: 4

---

    Code
      wrapped_to_int(given)
    Condition
      Error in `wrapped_to_int()`:
      ! `val` <complex> must be coercible to <integer>
      x Can't convert some values due to non-zero complex components.
      * Locations: 4

# to_int() respects coerce_factor (#14)

    Code
      to_int(given, coerce_factor = FALSE)
    Condition
      Error:
      ! Can't coerce `given` <factor> to <integer>.

---

    Code
      wrapped_to_int(given, coerce_factor = FALSE)
    Condition
      Error in `wrapped_to_int()`:
      ! Can't coerce `val` <factor> to <integer>.

# to_int() errors informatively for bad factors (#4)

    Code
      to_int(given)
    Condition
      Error:
      ! `given` <factor> must be coercible to <integer>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 25, and 26

---

    Code
      wrapped_to_int(given)
    Condition
      Error in `wrapped_to_int()`:
      ! `val` <factor> must be coercible to <integer>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 25, and 26

# to_int_scalar() provides informative error messages (#12)

    Code
      to_int_scalar(given)
    Condition
      Error:
      ! `given` must be a single <integer>.
      x `given` has 10 values.

---

    Code
      wrapped_to_int_scalar(given)
    Condition
      Error in `wrapped_to_int_scalar()`:
      ! `val` must be a single <integer>.
      x `val` has 10 values.

