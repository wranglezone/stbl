# stabilize_dttm() works for NULL (#105)

    Code
      stabilize_dttm(NULL, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

# stabilize_dttm() respects allow_na (#105)

    Code
      stabilize_dttm(given, allow_na = FALSE)
    Condition <stbl-error-bad_na>
      Error:
      ! `given` must not contain NA values.
      * NA locations: 2

# stabilize_dttm() checks min_value (#105)

    Code
      stabilize_dttm(given, min_value = "2024-06-01T00:00:00Z")
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be >= 2024-06-01 UTC.
      i Some values are too low.
      x Location: 1
      x Value: 2024-01-01 UTC

---

    Code
      wrapped_stabilize_dttm(given, min_value = "2024-06-01T00:00:00Z")
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_dttm()`:
      ! `val` must be >= 2024-06-01 UTC.
      i Some values are too low.
      x Location: 1
      x Value: 2024-01-01 UTC

# stabilize_dttm() checks max_value (#105)

    Code
      stabilize_dttm(given, max_value = "2024-03-01T00:00:00Z")
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be <= 2024-03-01 UTC.
      i Some values are too high.
      x Location: 2
      x Value: 2024-06-15 UTC

---

    Code
      wrapped_stabilize_dttm(given, max_value = "2024-03-01T00:00:00Z")
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_dttm()`:
      ! `val` must be <= 2024-03-01 UTC.
      i Some values are too high.
      x Location: 2
      x Value: 2024-06-15 UTC

# stabilize_dttm() checks size (#105)

    Code
      stabilize_dttm(given, min_size = 3)
    Condition <stbl-error-size_too_small>
      Error:
      ! `given` must have size >= 3.
      x 2 is too small.

---

    Code
      stabilize_dttm(given, max_size = 1)
    Condition <stbl-error-size_too_large>
      Error:
      ! `given` must have size <= 1.
      x 2 is too big.

# stabilize_dttm() checks allowed_values (#105)

    Code
      stabilize_dttm(given, allowed_values = "2024-01-01T00:00:00Z")
    Condition <stbl-error-allowed_values>
      Error:
      ! `given` must be one of the allowed values.
      i Allowed value: "2024-01-01".
      x Unexpected location: 2
      x Unexpected value: "2024-06-15".

---

    Code
      wrapped_stabilize_dttm(given, allowed_values = "2024-01-01T00:00:00Z")
    Condition <stbl-error-allowed_values>
      Error in `wrapped_stabilize_dttm()`:
      ! `val` must be one of the allowed values.
      i Allowed value: "2024-01-01".
      x Unexpected location: 2
      x Unexpected value: "2024-06-15".

# stabilize_dttm() rejects date-times without an offset (#105)

    Code
      stabilize_dttm("2024-01-01 12:00:00")
    Condition <stbl-error-incompatible_values-datetime>
      Error:
      ! `"2024-01-01 12:00:00"` <character> must be coercible to <datetime>
      x Can't convert some values due to invalid or ambiguous date-time format.
      * Locations: 1

# stabilize_dttm() rejects an unrecognized tz (#105)

    Code
      stabilize_dttm("2024-01-01T12:00:00Z", tz = "Bogus/Zone")
    Condition <stbl-error-bad_tz>
      Error:
      ! `tz` must be "" or a value from `OlsonNames()`.
      x "Bogus/Zone" is not a recognized time zone.

# stabilize_dttm_scalar() respects allow_null (#105)

    Code
      stabilize_dttm_scalar(NULL)
    Condition <stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      wrapped_stabilize_dttm_scalar(NULL)
    Condition <stbl-error-bad_null>
      Error in `wrapped_stabilize_dttm_scalar()`:
      ! `val` must not be <NULL>.

# stabilize_dttm_scalar() errors on non-scalars (#105)

    Code
      stabilize_dttm_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <POSIXct/POSIXt>.
      x `given` has 2 values.

---

    Code
      wrapped_stabilize_dttm_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_stabilize_dttm_scalar()`:
      ! `val` must be a single <POSIXct/POSIXt>.
      x `val` has 2 values.

# stabilize_dttm_scalar() checks allowed_values (#105)

    Code
      stabilize_dttm_scalar("2024-07-01T00:00:00Z", allowed_values = "2024-01-01T00:00:00Z")
    Condition <stbl-error-allowed_values>
      Error:
      ! `"2024-07-01T00:00:00Z"` must be one of the allowed values.
      i Allowed value: "2024-01-01".
      x Unexpected location: 1
      x Unexpected value: "2024-07-01".

