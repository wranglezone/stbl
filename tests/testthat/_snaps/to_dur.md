# to_dur() respects allow_null (#295)

    Code
      to_dur(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_dur(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_dur()`:
      ! `val` must not be <NULL>.

# to_dur() rejects a bare P or PT (#295)

    Code
      to_dur("P")
    Condition <stbl-error-incompatible_values-duration>
      Error:
      ! `"P"` <character> must be coercible to <duration>
      x Can't convert some values due to invalid or ambiguous duration format.
      * Locations: 1

---

    Code
      to_dur("PT")
    Condition <stbl-error-incompatible_values-duration>
      Error:
      ! `"PT"` <character> must be coercible to <duration>
      x Can't convert some values due to invalid or ambiguous duration format.
      * Locations: 1

# to_dur() rejects mixing the week form with other units (#295)

    Code
      to_dur("P1W2D")
    Condition <stbl-error-incompatible_values-duration>
      Error:
      ! `"P1W2D"` <character> must be coercible to <duration>
      x Can't convert some values due to invalid or ambiguous duration format.
      * Locations: 1

# to_dur() rejects fractional components (#295)

    Code
      to_dur("P1.5D")
    Condition <stbl-error-incompatible_values-duration>
      Error:
      ! `"P1.5D"` <character> must be coercible to <duration>
      x Can't convert some values due to invalid or ambiguous duration format.
      * Locations: 1

# to_dur() rejects a negative sign (#295)

    Code
      to_dur("-P1D")
    Condition <stbl-error-incompatible_values-duration>
      Error:
      ! `"-P1D"` <character> must be coercible to <duration>
      x Can't convert some values due to invalid or ambiguous duration format.
      * Locations: 1

# to_dur() rejects out-of-order components (#295)

    Code
      to_dur("P1D1Y")
    Condition <stbl-error-incompatible_values-duration>
      Error:
      ! `"P1D1Y"` <character> must be coercible to <duration>
      x Can't convert some values due to invalid or ambiguous duration format.
      * Locations: 1

# to_dur() rejects lowercase durations (#295)

    Code
      to_dur("p1y2m")
    Condition <stbl-error-incompatible_values-duration>
      Error:
      ! `"p1y2m"` <character> must be coercible to <duration>
      x Can't convert some values due to invalid or ambiguous duration format.
      * Locations: 1

# to_dur() rejects unparseable duration strings (#295)

    Code
      to_dur(given)
    Condition <stbl-error-incompatible_values-duration>
      Error:
      ! `given` <character> must be coercible to <duration>
      x Can't convert some values due to invalid or ambiguous duration format.
      * Locations: 2

---

    Code
      wrapped_to_dur(given)
    Condition <stbl-error-incompatible_values-duration>
      Error in `wrapped_to_dur()`:
      ! `val` <character> must be coercible to <duration>
      x Can't convert some values due to invalid or ambiguous duration format.
      * Locations: 2

# to_dur() errors informatively for bad factors (#295)

    Code
      to_dur(given)
    Condition <stbl-error-incompatible_values-duration>
      Error:
      ! `given` <factor> must be coercible to <duration>
      x Can't convert some values due to invalid or ambiguous duration format.
      * Locations: 2

# to_dur_scalar() provides informative error messages (#295)

    Code
      to_dur_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <Period>.
      x `given` has 2 values.

---

    Code
      wrapped_to_dur_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_to_dur_scalar()`:
      ! `val` must be a single <Period>.
      x `val` has 2 values.

# to_dur_scalar() respects allow_null (#295)

    Code
      to_dur_scalar(given)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_dur_scalar(given)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_dur_scalar()`:
      ! `val` must not be <NULL>.

# to_dur_scalar() respects allow_zero_length (#295)

    Code
      to_dur_scalar(given)
    Condition <stbl-error-bad_empty>
      Error:
      ! `given` must be a single <Period (non-empty)>.
      x `given` has no values.

