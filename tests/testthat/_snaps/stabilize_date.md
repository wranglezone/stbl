# stabilize_date() works for NULL (#104)

    Code
      stabilize_date(NULL, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

# stabilize_date() respects allow_na (#104)

    Code
      stabilize_date(given, allow_na = FALSE)
    Condition <stbl-error-bad_na>
      Error:
      ! `given` must not contain NA values.
      * NA locations: 2

# stabilize_date() checks min_value (#104)

    Code
      stabilize_date(given, min_value = "2024-06-01")
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be >= 2024-06-01.
      i Some values are too low.
      x Location: 1
      x Value: 2024-01-01

---

    Code
      wrapped_stabilize_date(given, min_value = "2024-06-01")
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_date()`:
      ! `val` must be >= 2024-06-01.
      i Some values are too low.
      x Location: 1
      x Value: 2024-01-01

# stabilize_date() checks max_value (#104)

    Code
      stabilize_date(given, max_value = "2024-03-01")
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be <= 2024-03-01.
      i Some values are too high.
      x Location: 2
      x Value: 2024-06-15

---

    Code
      wrapped_stabilize_date(given, max_value = "2024-03-01")
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_date()`:
      ! `val` must be <= 2024-03-01.
      i Some values are too high.
      x Location: 2
      x Value: 2024-06-15

# stabilize_date() checks size (#104)

    Code
      stabilize_date(given, min_size = 3)
    Condition <stbl-error-size_too_small>
      Error:
      ! `given` must have size >= 3.
      x 2 is too small.

---

    Code
      stabilize_date(given, max_size = 1)
    Condition <stbl-error-size_too_large>
      Error:
      ! `given` must have size <= 1.
      x 2 is too big.

# stabilize_date() checks allowed_values (#104)

    Code
      stabilize_date(given, allowed_values = "2024-01-01")
    Condition <stbl-error-allowed_values>
      Error:
      ! `given` must be one of the allowed values.
      i Allowed value: "2024-01-01".
      x Unexpected location: 2
      x Unexpected value: "2024-06-15".

---

    Code
      wrapped_stabilize_date(given, allowed_values = "2024-01-01")
    Condition <stbl-error-allowed_values>
      Error in `wrapped_stabilize_date()`:
      ! `val` must be one of the allowed values.
      i Allowed value: "2024-01-01".
      x Unexpected location: 2
      x Unexpected value: "2024-06-15".

# stabilize_date() rejects ambiguous formats (#104)

    Code
      stabilize_date("11/13/2018")
    Condition <stbl-error-incompatible_values-date>
      Error:
      ! `"11/13/2018"` <character> must be coercible to <date>
      x Can't convert some values due to invalid or ambiguous date format.
      * Locations: 1
      * Values: "11/13/2018"

# stabilize_date_scalar() respects allow_null (#104)

    Code
      stabilize_date_scalar(NULL)
    Condition <stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      wrapped_stabilize_date_scalar(NULL)
    Condition <stbl-error-bad_null>
      Error in `wrapped_stabilize_date_scalar()`:
      ! `val` must not be <NULL>.

# stabilize_date_scalar() errors on non-scalars (#104)

    Code
      stabilize_date_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <Date>.
      x `given` has 2 values.

---

    Code
      wrapped_stabilize_date_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_stabilize_date_scalar()`:
      ! `val` must be a single <Date>.
      x `val` has 2 values.

# stabilize_date_scalar() checks allowed_values (#104)

    Code
      stabilize_date_scalar("2024-07-01", allowed_values = "2024-01-01")
    Condition <stbl-error-allowed_values>
      Error:
      ! `"2024-07-01"` must be one of the allowed values.
      i Allowed value: "2024-01-01".
      x Unexpected location: 1
      x Unexpected value: "2024-07-01".

