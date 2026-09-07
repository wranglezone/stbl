# to_each() stops at the first failing element (#287)

    Code
      to_each(list("1", "a", "b"), to_int)
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `list("1", "a", "b")[[2]]` <character> must be coercible to <integer>
      x Can't convert some values due to non-numeric strings.
      * Locations: 1
      * Values: "a"

---

    Code
      wrapped_to_each(list("1", "a", "b"), to_int)
    Condition <stbl-error-incompatible_values-integer>
      Error in `wrapped_to_each()`:
      ! `val[[2]]` <character> must be coercible to <integer>
      x Can't convert some values due to non-numeric strings.
      * Locations: 1
      * Values: "a"

