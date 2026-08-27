# stabilize_time() works for NULL (#294)

    Code
      stabilize_time(NULL, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

# stabilize_time() respects allow_na (#294)

    Code
      stabilize_time(given, allow_na = FALSE)
    Condition <stbl-error-bad_na>
      Error:
      ! `given` must not contain NA values.
      * NA locations: 2

# stabilize_time() checks min_value (#294)

    Code
      stabilize_time(given, min_value = "12:00:00Z")
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be >= 12:00:00.
      i Some values are too low.
      x Location: 1
      x Value: 06:00:00

---

    Code
      wrapped_stabilize_time(given, min_value = "12:00:00Z")
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_time()`:
      ! `val` must be >= 12:00:00.
      i Some values are too low.
      x Location: 1
      x Value: 06:00:00

# stabilize_time() checks max_value (#294)

    Code
      stabilize_time(given, max_value = "10:00:00Z")
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be <= 10:00:00.
      i Some values are too high.
      x Location: 2
      x Value: 14:00:00

---

    Code
      wrapped_stabilize_time(given, max_value = "10:00:00Z")
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_time()`:
      ! `val` must be <= 10:00:00.
      i Some values are too high.
      x Location: 2
      x Value: 14:00:00

# stabilize_time() checks size (#294)

    Code
      stabilize_time(given, min_size = 3)
    Condition <stbl-error-size_too_small>
      Error:
      ! `given` must have size >= 3.
      x 2 is too small.

---

    Code
      stabilize_time(given, max_size = 1)
    Condition <stbl-error-size_too_large>
      Error:
      ! `given` must have size <= 1.
      x 2 is too big.

# stabilize_time() checks allowed_values (#294)

    Code
      stabilize_time(given, allowed_values = "06:00:00Z")
    Condition <stbl-error-allowed_values>
      Error:
      ! `given` must be one of the allowed values.
      i Allowed value: "06:00:00".
      x Unexpected location: 2
      x Unexpected value: "14:00:00".

---

    Code
      wrapped_stabilize_time(given, allowed_values = "06:00:00Z")
    Condition <stbl-error-allowed_values>
      Error in `wrapped_stabilize_time()`:
      ! `val` must be one of the allowed values.
      i Allowed value: "06:00:00".
      x Unexpected location: 2
      x Unexpected value: "14:00:00".

# stabilize_time() rejects times without an offset (#294)

    Code
      stabilize_time("13:20:00")
    Condition <stbl-error-incompatible_values-time>
      Error:
      ! `"13:20:00"` <character> must be coercible to <time>
      x Can't convert some values due to invalid or ambiguous time format.
      * Locations: 1
      * Values: "13:20:00"

# stabilize_time_scalar() respects allow_null (#294)

    Code
      stabilize_time_scalar(NULL)
    Condition <stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      wrapped_stabilize_time_scalar(NULL)
    Condition <stbl-error-bad_null>
      Error in `wrapped_stabilize_time_scalar()`:
      ! `val` must not be <NULL>.

# stabilize_time_scalar() errors on non-scalars (#294)

    Code
      stabilize_time_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <hms/difftime>.
      x `given` has 2 values.

---

    Code
      wrapped_stabilize_time_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_stabilize_time_scalar()`:
      ! `val` must be a single <hms/difftime>.
      x `val` has 2 values.

# stabilize_time_scalar() checks allowed_values (#294)

    Code
      stabilize_time_scalar("06:00:00Z", allowed_values = "13:20:00Z")
    Condition <stbl-error-allowed_values>
      Error:
      ! `"06:00:00Z"` must be one of the allowed values.
      i Allowed value: "13:20:00".
      x Unexpected location: 1
      x Unexpected value: "06:00:00".

