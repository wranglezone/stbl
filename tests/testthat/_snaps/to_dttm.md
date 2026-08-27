# to_dttm() respects allow_null (#105)

    Code
      to_dttm(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_dttm(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_dttm()`:
      ! `val` must not be <NULL>.

# to_dttm() rejects date-times without an offset (#105)

    Code
      to_dttm("2024-01-01 12:00:00")
    Condition <stbl-error-incompatible_values-datetime>
      Error:
      ! `"2024-01-01 12:00:00"` <character> must be coercible to <datetime>
      x Can't convert some values due to invalid or ambiguous date-time format.
      * Locations: 1
      * Values: "2024-01-01 12:00:00"

---

    Code
      wrapped_to_dttm("2024-01-01 12:00:00")
    Condition <stbl-error-incompatible_values-datetime>
      Error in `wrapped_to_dttm()`:
      ! `val` <character> must be coercible to <datetime>
      x Can't convert some values due to invalid or ambiguous date-time format.
      * Locations: 1
      * Values: "2024-01-01 12:00:00"

# to_dttm() rejects unparseable date-time strings (#105)

    Code
      to_dttm(given)
    Condition <stbl-error-incompatible_values-datetime>
      Error:
      ! `given` <character> must be coercible to <datetime>
      x Can't convert some values due to invalid or ambiguous date-time format.
      * Locations: 2
      * Values: "not-a-datetime"

# to_dttm() rejects impossible date-times (#105)

    Code
      to_dttm("2024-02-30T12:00:00Z")
    Condition <stbl-error-incompatible_values-datetime>
      Error:
      ! `"2024-02-30T12:00:00Z"` <character> must be coercible to <datetime>
      x Can't convert some values due to invalid or ambiguous date-time format.
      * Locations: 1
      * Values: "2024-02-30T12:00:00Z"

---

    Code
      to_dttm("2024-01-01T25:00:00Z")
    Condition <stbl-error-incompatible_values-datetime>
      Error:
      ! `"2024-01-01T25:00:00Z"` <character> must be coercible to <datetime>
      x Can't convert some values due to invalid or ambiguous date-time format.
      * Locations: 1
      * Values: "2024-01-01T25:00:00Z"

# to_dttm() rejects an unrecognized tz (#105)

    Code
      to_dttm("2024-01-01T12:00:00Z", tz = "Bogus/Zone")
    Condition <stbl-error-bad_tz>
      Error:
      ! `tz` must be "" or a value from `OlsonNames()`.
      x "Bogus/Zone" is not a recognized time zone.

# to_dttm() errors informatively for bad factors (#105)

    Code
      to_dttm(given)
    Condition <stbl-error-incompatible_values-datetime>
      Error:
      ! `given` <factor> must be coercible to <datetime>
      x Can't convert some values due to invalid or ambiguous date-time format.
      * Locations: 2
      * Values: "nope"

# to_dttm_scalar() provides informative error messages (#105)

    Code
      to_dttm_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <POSIXct/POSIXt>.
      x `given` has 2 values.

---

    Code
      wrapped_to_dttm_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_to_dttm_scalar()`:
      ! `val` must be a single <POSIXct/POSIXt>.
      x `val` has 2 values.

# to_dttm_scalar() respects allow_null (#105)

    Code
      to_dttm_scalar(given)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_dttm_scalar(given)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_dttm_scalar()`:
      ! `val` must not be <NULL>.

# to_dttm_scalar() respects allow_zero_length (#105)

    Code
      to_dttm_scalar(given)
    Condition <stbl-error-bad_empty>
      Error:
      ! `given` must be a single <POSIXct (non-empty)/POSIXt (non-empty)>.
      x `given` has no values.

