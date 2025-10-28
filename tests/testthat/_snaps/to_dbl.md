# to_dbl() respects allow_null (#23)

    Code
      to_dbl(given, allow_null = FALSE)
    Condition
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_dbl(given, allow_null = FALSE)
    Condition
      Error in `wrapped_to_dbl()`:
      ! `val` must not be <NULL>.

# to_dbl() respects coerce_character (#23)

    Code
      to_dbl(given, coerce_character = FALSE)
    Condition
      Error:
      ! Can't coerce `given` <character> to <double>.

---

    Code
      wrapped_to_dbl(given, coerce_character = FALSE)
    Condition
      Error in `wrapped_to_dbl()`:
      ! Can't coerce `val` <character> to <double>.

# to_dbl() errors informatively for bad chrs (#23)

    Code
      to_dbl(given)
    Condition
      Error:
      ! `given` <character> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 2

---

    Code
      wrapped_to_dbl(given)
    Condition
      Error in `wrapped_to_dbl()`:
      ! `val` <character> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 2

# to_dbl() errors informatively for bad complexes (#23)

    Code
      to_dbl(given)
    Condition
      Error:
      ! `given` <complex> must be coercible to <double>
      x Can't convert some values due to non-zero complex components.
      * Locations: 1

---

    Code
      wrapped_to_dbl(given)
    Condition
      Error in `wrapped_to_dbl()`:
      ! `val` <complex> must be coercible to <double>
      x Can't convert some values due to non-zero complex components.
      * Locations: 1

# to_dbl() respects coerce_factor (#23)

    Code
      to_dbl(given, coerce_factor = FALSE)
    Condition
      Error:
      ! Can't coerce `given` <factor> to <double>.

---

    Code
      wrapped_to_dbl(given, coerce_factor = FALSE)
    Condition
      Error in `wrapped_to_dbl()`:
      ! Can't coerce `val` <factor> to <double>.

# to_dbl() errors informatively for bad factors (#23)

    Code
      to_dbl(given)
    Condition
      Error:
      ! `given` <factor> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 25, and 26

---

    Code
      wrapped_to_dbl(given)
    Condition
      Error in `wrapped_to_dbl()`:
      ! `val` <factor> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 25, and 26

# to_dbl_scalar() provides informative error messages (#23)

    Code
      to_dbl_scalar(given)
    Condition
      Error:
      ! `given` must be a single <numeric>.
      x `given` has 2 values.

---

    Code
      wrapped_to_dbl_scalar(given)
    Condition
      Error in `wrapped_to_dbl_scalar()`:
      ! `val` must be a single <numeric>.
      x `val` has 2 values.

