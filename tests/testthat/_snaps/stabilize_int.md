# stabilize_int() checks min_value (#2, #6, #176)

    Code
      stabilize_int(given, min_value = 11)
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be >= 11.
      i Some values are too low.
      x Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10
      x Values: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10

---

    Code
      wrapped_stabilize_int(given, min_value = 11)
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_int()`:
      ! `val` must be >= 11.
      i Some values are too low.
      x Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10
      x Values: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10

# stabilize_int() checks max_value (#5, #176)

    Code
      stabilize_int(given, max_value = 4)
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be <= 4.
      i Some values are too high.
      x Locations: 5, 6, 7, 8, 9, and 10
      x Values: 5, 6, 7, 8, 9, and 10

---

    Code
      wrapped_stabilize_int(given, max_value = 4)
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_int()`:
      ! `val` must be <= 4.
      i Some values are too high.
      x Locations: 5, 6, 7, 8, 9, and 10
      x Values: 5, 6, 7, 8, 9, and 10

# stabilize_int_scalar() respects allow_null (#12, #189)

    Code
      stabilize_int_scalar(given)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_stabilize_int_scalar(given)
    Condition <stbl-error-bad_null>
      Error in `wrapped_stabilize_int_scalar()`:
      ! `val` must not be <NULL>.

# stabilize_int_scalar() errors on non-scalars (#12)

    Code
      stabilize_int_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <integer>.
      x `given` has 10 values.

---

    Code
      wrapped_stabilize_int_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_stabilize_int_scalar()`:
      ! `val` must be a single <integer>.
      x `val` has 10 values.

# stabilize_int() checks allowed_values (#282)

    Code
      stabilize_int(1:5, allowed_values = c(1L, 2L, 3L))
    Condition <stbl-error-allowed_values>
      Error:
      ! `1:5` must be one of the allowed values.
      i Allowed values: "1", "2", and "3".
      x Unexpected locations: 4 and 5
      x Unexpected values: "4" and "5".

---

    Code
      wrapped_stabilize_int(1:5, allowed_values = c(1L, 2L, 3L))
    Condition <stbl-error-allowed_values>
      Error in `wrapped_stabilize_int()`:
      ! `val` must be one of the allowed values.
      i Allowed values: "1", "2", and "3".
      x Unexpected locations: 4 and 5
      x Unexpected values: "4" and "5".

# stabilize_int() checks multiple_of (#283)

    Code
      stabilize_int(c(2L, 3L, 6L), multiple_of = 2)
    Condition <stbl-error-not_multiple>
      Error:
      ! `c(2L, 3L, 6L)` must be a multiple of 2.
      x Unexpected location: 2
      x Unexpected value: "3".

---

    Code
      wrapped_stabilize_int(c(2L, 3L, 6L), multiple_of = 2)
    Condition <stbl-error-not_multiple>
      Error in `wrapped_stabilize_int()`:
      ! `val` must be a multiple of 2.
      x Unexpected location: 2
      x Unexpected value: "3".

# stabilize_int_scalar() checks multiple_of (#283)

    Code
      stabilize_int_scalar(3L, multiple_of = 2)
    Condition <stbl-error-not_multiple>
      Error:
      ! `3L` must be a multiple of 2.
      x Unexpected location: 1
      x Unexpected value: "3".

# stabilize_int() checks exclusive_min_value (#276)

    Code
      stabilize_int(given, exclusive_min_value = 1)
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be > 1.
      i Some values are too low.
      x Location: 1
      x Value: 1

---

    Code
      wrapped_stabilize_int(given, exclusive_min_value = 1)
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_int()`:
      ! `val` must be > 1.
      i Some values are too low.
      x Location: 1
      x Value: 1

# stabilize_int() checks exclusive_max_value (#276)

    Code
      stabilize_int(given, exclusive_max_value = 10)
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be < 10.
      i Some values are too high.
      x Location: 10
      x Value: 10

---

    Code
      wrapped_stabilize_int(given, exclusive_max_value = 10)
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_int()`:
      ! `val` must be < 10.
      i Some values are too high.
      x Location: 10
      x Value: 10

# stabilize_int_scalar() checks exclusive_min_value and exclusive_max_value (#276)

    Code
      stabilize_int_scalar(1L, exclusive_min_value = 1)
    Condition <stbl-error-outside_range>
      Error:
      ! `1L` must be > 1.
      x 1 is too low.

---

    Code
      stabilize_int_scalar(10L, exclusive_max_value = 10)
    Condition <stbl-error-outside_range>
      Error:
      ! `10L` must be < 10.
      x 10 is too high.

# stabilize_int_scalar() checks allowed_values (#282)

    Code
      stabilize_int_scalar(5L, allowed_values = c(1L, 2L))
    Condition <stbl-error-allowed_values>
      Error:
      ! `5L` must be one of the allowed values.
      i Allowed values: "1" and "2".
      x Unexpected location: 1
      x Unexpected value: "5".

