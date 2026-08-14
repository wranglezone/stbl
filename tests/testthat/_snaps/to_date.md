# to_date() respects allow_null (#104)

    Code
      to_date(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_date(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_date()`:
      ! `val` must not be <NULL>.

# to_date() rejects ambiguous date formats (#104)

    Code
      to_date("11/13/2018")
    Condition <stbl-error-incompatible_values-date>
      Error:
      ! `"11/13/2018"` <character> must be coercible to <date>
      x Can't convert some values due to invalid or ambiguous date format.
      * Locations: 1

---

    Code
      wrapped_to_date("11/13/2018")
    Condition <stbl-error-incompatible_values-date>
      Error in `wrapped_to_date()`:
      ! `val` <character> must be coercible to <date>
      x Can't convert some values due to invalid or ambiguous date format.
      * Locations: 1

# to_date() rejects unparseable date strings (#104)

    Code
      to_date(given)
    Condition <stbl-error-incompatible_values-date>
      Error:
      ! `given` <character> must be coercible to <date>
      x Can't convert some values due to invalid or ambiguous date format.
      * Locations: 2

# to_date() rejects impossible dates (#104)

    Code
      to_date("2024-02-30")
    Condition <stbl-error-incompatible_values-date>
      Error:
      ! `"2024-02-30"` <character> must be coercible to <date>
      x Can't convert some values due to invalid or ambiguous date format.
      * Locations: 1

# to_date() errors informatively for bad factors (#104)

    Code
      to_date(given)
    Condition <stbl-error-incompatible_values-date>
      Error:
      ! `given` <factor> must be coercible to <date>
      x Can't convert some values due to invalid or ambiguous date format.
      * Locations: 2

# to_date_scalar() provides informative error messages (#104)

    Code
      to_date_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <Date>.
      x `given` has 2 values.

---

    Code
      wrapped_to_date_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_to_date_scalar()`:
      ! `val` must be a single <Date>.
      x `val` has 2 values.

# to_date_scalar() respects allow_null (#104)

    Code
      to_date_scalar(given)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_date_scalar(given)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_date_scalar()`:
      ! `val` must not be <NULL>.

# to_date_scalar() respects allow_zero_length (#104)

    Code
      to_date_scalar(given)
    Condition <stbl-error-bad_empty>
      Error:
      ! `given` must be a single <Date (non-empty)>.
      x `given` has no values.

