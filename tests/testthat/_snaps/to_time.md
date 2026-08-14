# to_time() respects allow_null (#294)

    Code
      to_time(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_time(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_time()`:
      ! `val` must not be <NULL>.

# to_time() rejects times without an offset (#294)

    Code
      to_time("13:20:00")
    Condition <stbl-error-incompatible_values-time>
      Error:
      ! `"13:20:00"` <character> must be coercible to <time>
      x Can't convert some values due to invalid or ambiguous time format.
      * Locations: 1

---

    Code
      wrapped_to_time("13:20:00")
    Condition <stbl-error-incompatible_values-time>
      Error in `wrapped_to_time()`:
      ! `val` <character> must be coercible to <time>
      x Can't convert some values due to invalid or ambiguous time format.
      * Locations: 1

# to_time() rejects unparseable time strings (#294)

    Code
      to_time(given)
    Condition <stbl-error-incompatible_values-time>
      Error:
      ! `given` <character> must be coercible to <time>
      x Can't convert some values due to invalid or ambiguous time format.
      * Locations: 2

# to_time() rejects impossible times (#294)

    Code
      to_time("25:00:00Z")
    Condition <stbl-error-incompatible_values-time>
      Error:
      ! `"25:00:00Z"` <character> must be coercible to <time>
      x Can't convert some values due to invalid or ambiguous time format.
      * Locations: 1

---

    Code
      to_time("13:60:00Z")
    Condition <stbl-error-incompatible_values-time>
      Error:
      ! `"13:60:00Z"` <character> must be coercible to <time>
      x Can't convert some values due to invalid or ambiguous time format.
      * Locations: 1

# to_time() errors informatively for bad factors (#294)

    Code
      to_time(given)
    Condition <stbl-error-incompatible_values-time>
      Error:
      ! `given` <factor> must be coercible to <time>
      x Can't convert some values due to invalid or ambiguous time format.
      * Locations: 2

# to_time() rejects out-of-range numerics (#294)

    Code
      to_time(-1)
    Condition <stbl-error-incompatible_values-time>
      Error:
      ! `-1` <double> must be coercible to <time>
      x Can't convert some values due to not a valid number of seconds since midnight (must be at least 0 and less than 86400).
      * Locations: 1

---

    Code
      to_time(86400)
    Condition <stbl-error-incompatible_values-time>
      Error:
      ! `86400` <double> must be coercible to <time>
      x Can't convert some values due to not a valid number of seconds since midnight (must be at least 0 and less than 86400).
      * Locations: 1

# to_time() rejects out-of-range difftime values (#294)

    Code
      to_time(given)
    Condition <stbl-error-incompatible_values-time>
      Error:
      ! `given` <difftime> must be coercible to <time>
      x Can't convert some values due to not a valid number of seconds since midnight (must be at least 0 and less than 86400).
      * Locations: 1

# to_time() rejects out-of-range hms values (#294)

    Code
      to_time(given)
    Condition <stbl-error-incompatible_values-time>
      Error:
      ! `given` <hms> must be coercible to <time>
      x Can't convert some values due to not a valid number of seconds since midnight (must be at least 0 and less than 86400).
      * Locations: 1

# to_time_scalar() provides informative error messages (#294)

    Code
      to_time_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <hms/difftime>.
      x `given` has 2 values.

---

    Code
      wrapped_to_time_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_to_time_scalar()`:
      ! `val` must be a single <hms/difftime>.
      x `val` has 2 values.

# to_time_scalar() respects allow_null (#294)

    Code
      to_time_scalar(given)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_time_scalar(given)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_time_scalar()`:
      ! `val` must not be <NULL>.

# to_time_scalar() respects allow_zero_length (#294)

    Code
      to_time_scalar(given)
    Condition <stbl-error-bad_empty>
      Error:
      ! `given` must be a single <hms (non-empty)/difftime (non-empty)>.
      x `given` has no values.

