# stabilize_dur() works for NULL (#295)

    Code
      stabilize_dur(NULL, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

# stabilize_dur() respects allow_na (#295)

    Code
      stabilize_dur(given, allow_na = FALSE)
    Condition <stbl-error-bad_na>
      Error:
      ! `given` must not contain NA values.
      * NA locations: 2

# stabilize_dur() checks min_value (#295)

    Code
      stabilize_dur(given, min_value = "P2D")
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be >= 2d 0H 0M 0S.
      i Some values are too low.
      x Location: 1
      x Value: 1d 0H 0M 0S

---

    Code
      wrapped_stabilize_dur(given, min_value = "P2D")
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_dur()`:
      ! `val` must be >= 2d 0H 0M 0S.
      i Some values are too low.
      x Location: 1
      x Value: 1d 0H 0M 0S

# stabilize_dur() checks max_value (#295)

    Code
      stabilize_dur(given, max_value = "P2D")
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be <= 2d 0H 0M 0S.
      i Some values are too high.
      x Location: 2
      x Value: 3d 0H 0M 0S

---

    Code
      wrapped_stabilize_dur(given, max_value = "P2D")
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_dur()`:
      ! `val` must be <= 2d 0H 0M 0S.
      i Some values are too high.
      x Location: 2
      x Value: 3d 0H 0M 0S

# stabilize_dur() checks size (#295)

    Code
      stabilize_dur(given, min_size = 3)
    Condition <stbl-error-size_too_small>
      Error:
      ! `given` must have size >= 3.
      x 2 is too small.

---

    Code
      stabilize_dur(given, max_size = 1)
    Condition <stbl-error-size_too_large>
      Error:
      ! `given` must have size <= 1.
      x 2 is too big.

# stabilize_dur() checks allowed_values (#295)

    Code
      stabilize_dur(given, allowed_values = "P1D")
    Condition <stbl-error-allowed_values>
      Error:
      ! `given` must be one of the allowed values.
      i Allowed value: "1d 0H 0M 0S".
      x Unexpected location: 2
      x Unexpected value: "2d 0H 0M 0S".

---

    Code
      wrapped_stabilize_dur(given, allowed_values = "P1D")
    Condition <stbl-error-allowed_values>
      Error in `wrapped_stabilize_dur()`:
      ! `val` must be one of the allowed values.
      i Allowed value: "1d 0H 0M 0S".
      x Unexpected location: 2
      x Unexpected value: "2d 0H 0M 0S".

# stabilize_dur() rejects a bare P (#295)

    Code
      stabilize_dur("P")
    Condition <stbl-error-incompatible_values-duration>
      Error:
      ! `"P"` <character> must be coercible to <duration>
      x Can't convert some values due to invalid or ambiguous duration format.
      * Locations: 1
      * Values: "P"

# stabilize_dur_scalar() respects allow_null (#295)

    Code
      stabilize_dur_scalar(NULL)
    Condition <stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      wrapped_stabilize_dur_scalar(NULL)
    Condition <stbl-error-bad_null>
      Error in `wrapped_stabilize_dur_scalar()`:
      ! `val` must not be <NULL>.

# stabilize_dur_scalar() errors on non-scalars (#295)

    Code
      stabilize_dur_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <Period>.
      x `given` has 2 values.

---

    Code
      wrapped_stabilize_dur_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_stabilize_dur_scalar()`:
      ! `val` must be a single <Period>.
      x `val` has 2 values.

# stabilize_dur_scalar() checks allowed_values (#295)

    Code
      stabilize_dur_scalar("P3D", allowed_values = "P1D")
    Condition <stbl-error-allowed_values>
      Error:
      ! `"P3D"` must be one of the allowed values.
      i Allowed value: "1d 0H 0M 0S".
      x Unexpected location: 1
      x Unexpected value: "3d 0H 0M 0S".

