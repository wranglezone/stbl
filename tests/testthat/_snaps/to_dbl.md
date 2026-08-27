# to_dbl() respects allow_null (#23)

    Code
      to_dbl(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_dbl(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_dbl()`:
      ! `val` must not be <NULL>.

# to_dbl() respects coerce_character (#23)

    Code
      to_dbl(given, coerce_character = FALSE)
    Condition <stbl-error-coerce-double>
      Error:
      ! Can't coerce `given` <character> to <double>.

---

    Code
      wrapped_to_dbl(given, coerce_character = FALSE)
    Condition <stbl-error-coerce-double>
      Error in `wrapped_to_dbl()`:
      ! Can't coerce `val` <character> to <double>.

# to_dbl() errors informatively for bad chrs (#23, #310)

    Code
      to_dbl(given)
    Condition <stbl-error-incompatible_values-double>
      Error:
      ! `given` <character> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 2
      * Values: "a"

---

    Code
      wrapped_to_dbl(given)
    Condition <stbl-error-incompatible_values-double>
      Error in `wrapped_to_dbl()`:
      ! `val` <character> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 2
      * Values: "a"

# to_dbl() errors informatively for bad complexes (#23, #310)

    Code
      to_dbl(given)
    Condition <stbl-error-incompatible_values-double>
      Error:
      ! `given` <complex> must be coercible to <double>
      x Can't convert some values due to non-zero complex components.
      * Locations: 1
      * Values: "1.1+1i"

---

    Code
      wrapped_to_dbl(given)
    Condition <stbl-error-incompatible_values-double>
      Error in `wrapped_to_dbl()`:
      ! `val` <complex> must be coercible to <double>
      x Can't convert some values due to non-zero complex components.
      * Locations: 1
      * Values: "1.1+1i"

# to_dbl() respects coerce_factor (#23)

    Code
      to_dbl(given, coerce_factor = FALSE)
    Condition <stbl-error-coerce-double>
      Error:
      ! Can't coerce `given` <factor> to <double>.

---

    Code
      wrapped_to_dbl(given, coerce_factor = FALSE)
    Condition <stbl-error-coerce-double>
      Error in `wrapped_to_dbl()`:
      ! Can't coerce `val` <factor> to <double>.

# to_dbl() errors informatively for bad factors (#23, #310)

    Code
      to_dbl(given)
    Condition <stbl-error-incompatible_values-double>
      Error:
      ! `given` <factor> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 25, and 26
      * Values: "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", ..., "y", and "z"

---

    Code
      wrapped_to_dbl(given)
    Condition <stbl-error-incompatible_values-double>
      Error in `wrapped_to_dbl()`:
      ! `val` <factor> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 25, and 26
      * Values: "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", ..., "y", and "z"

# to_dbl() works for lists (#128, #273, #310)

    Code
      to_dbl(list(1.1, 1:5))
    Condition <stbl-error-incompatible_values-double>
      Error:
      ! `list(1.1, 1:5)` <list> must be coercible to <double>
      x Can't convert some values due to incompatible element types.
      * Locations: 2
      * Values: "1:5"

# to_dbl_scalar() provides informative error messages (#23)

    Code
      to_dbl_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <numeric>.
      x `given` has 2 values.

---

    Code
      wrapped_to_dbl_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_to_dbl_scalar()`:
      ! `val` must be a single <numeric>.
      x `val` has 2 values.

# to_dbl_scalar() respects allow_null (#23, #189)

    Code
      to_dbl_scalar(given)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_dbl_scalar(given)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_dbl_scalar()`:
      ! `val` must not be <NULL>.

# to_dbl_scalar respects allow_zero_length (#23, #43, #45, #189)

    Code
      to_dbl_scalar(given)
    Condition <stbl-error-bad_empty>
      Error:
      ! `given` must be a single <numeric (non-empty)>.
      x `given` has no values.

