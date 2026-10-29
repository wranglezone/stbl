# to_int() respects allow_null (#2)

    Code
      to_int(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_int(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_int()`:
      ! `val` must not be <NULL>.

# to_int() errors for dbls that would lose precision (#2, #217, #310, #377)

    Code
      to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `given` <double> must be convertible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4
      * Values: "1.1"

---

    Code
      wrapped_to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error in `wrapped_to_int()`:
      ! `val` <double> must be convertible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4
      * Values: "1.1"

---

    Code
      to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `given` <double> must be convertible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4
      * Values: "Inf"

---

    Code
      wrapped_to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error in `wrapped_to_int()`:
      ! `val` <double> must be convertible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4
      * Values: "Inf"

# to_int() respects coerce_character (#14, #377)

    Code
      to_int(given, coerce_character = FALSE)
    Condition <stbl-error-coerce-integer>
      Error:
      ! Can't convert `given` <character> to <integer>.

---

    Code
      wrapped_to_int(given, coerce_character = FALSE)
    Condition <stbl-error-coerce-integer>
      Error in `wrapped_to_int()`:
      ! Can't convert `val` <character> to <integer>.

# to_int() errors informatively for bad chrs (#2, #310, #335, #377)

    Code
      to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `given` <character> must be convertible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4
      * Values: "1.1"

---

    Code
      wrapped_to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error in `wrapped_to_int()`:
      ! `val` <character> must be convertible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4
      * Values: "1.1"

---

    Code
      to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `given` <character> must be convertible to <integer>
      x Can't convert some values due to non-numeric strings.
      * Locations: 4
      * Values: "a"

---

    Code
      wrapped_to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error in `wrapped_to_int()`:
      ! `val` <character> must be convertible to <integer>
      x Can't convert some values due to non-numeric strings.
      * Locations: 4
      * Values: "a"

# to_int() errors informatively for bad complexes (#2, #310, #377)

    Code
      to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `given` <complex> must be convertible to <integer>
      x Can't convert some values due to non-zero complex components.
      * Locations: 4
      * Values: "1+1i"

---

    Code
      wrapped_to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error in `wrapped_to_int()`:
      ! `val` <complex> must be convertible to <integer>
      x Can't convert some values due to non-zero complex components.
      * Locations: 4
      * Values: "1+1i"

# to_int() errors for complexes that would lose precision (#noissue, #310, #377)

    Code
      to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `given` <complex> must be convertible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4
      * Values: "1.5+0i"

---

    Code
      wrapped_to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error in `wrapped_to_int()`:
      ! `val` <complex> must be convertible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4
      * Values: "1.5+0i"

---

    Code
      to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `given` <complex> must be convertible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4
      * Values: "Inf+0i"

---

    Code
      wrapped_to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error in `wrapped_to_int()`:
      ! `val` <complex> must be convertible to <integer>
      x Can't convert some values due to loss of precision.
      * Locations: 4
      * Values: "Inf+0i"

# to_int() respects coerce_factor (#14, #377)

    Code
      to_int(given, coerce_factor = FALSE)
    Condition <stbl-error-coerce-integer>
      Error:
      ! Can't convert `given` <factor> to <integer>.

---

    Code
      wrapped_to_int(given, coerce_factor = FALSE)
    Condition <stbl-error-coerce-integer>
      Error in `wrapped_to_int()`:
      ! Can't convert `val` <factor> to <integer>.

# to_int() errors informatively for bad factors (#4, #310, #335, #377)

    Code
      to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `given` <factor> must be convertible to <integer>
      x Can't convert some values due to non-numeric strings.
      * Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 25, and 26
      * Values: "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", ..., "y", and "z"

---

    Code
      wrapped_to_int(given)
    Condition <stbl-error-incompatible_values-integer>
      Error in `wrapped_to_int()`:
      ! `val` <factor> must be convertible to <integer>
      x Can't convert some values due to non-numeric strings.
      * Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 25, and 26
      * Values: "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", ..., "y", and "z"

# to_int() works for lists (#2, #273, #310, #377)

    Code
      to_int(list(1L, 1:5))
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `list(1L, 1:5)` <list> must be convertible to <integer>
      x Can't convert some values due to incompatible element types.
      * Locations: 2
      * Values: "1:5"

# to_int_scalar() provides informative error messages (#12)

    Code
      to_int_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <integer>.
      x `given` has 10 values.

---

    Code
      wrapped_to_int_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_to_int_scalar()`:
      ! `val` must be a single <integer>.
      x `val` has 10 values.

# to_int_scalar() respects allow_null (#12, #189)

    Code
      to_int_scalar(given)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_int_scalar(given)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_int_scalar()`:
      ! `val` must not be <NULL>.

# to_int_scalar respects allow_zero_length (#12, #43, #45, #189)

    Code
      to_int_scalar(given)
    Condition <stbl-error-bad_empty>
      Error:
      ! `given` must be a single <integer (non-empty)>.
      x `given` has no values.

# to_*() functions name both sides when to_arg is supplied (#371, #377)

    Code
      to_int("a", x_arg = "x", to_arg = "y")
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! Can't convert `x` <character> to match `y` <integer>.
      x Can't convert some values due to non-numeric strings.
      * Locations: 1
      * Values: "a"

# to_*() messages are unchanged when to_arg is NULL (#371, #377)

    Code
      to_int("a", x_arg = "x")
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `x` <character> must be convertible to <integer>
      x Can't convert some values due to non-numeric strings.
      * Locations: 1
      * Values: "a"

