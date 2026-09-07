# stabilize_each() errors with a combined message for all failures (#287)

    Code
      stabilize_each(list("1", "a", "b"), stabilize_int)
    Condition <stbl-error-cant_stabilize_each>
      Error:
      ! `list("1", "a", "b")` <list> must have every element satisfy `spec`.
      x Location 2: `list("1", "a", "b")[[2]]` <character> must be coercible to <integer> (Locations: 1)
      x Location 3: `list("1", "a", "b")[[3]]` <character> must be coercible to <integer> (Locations: 1)

---

    Code
      wrapped_stabilize_each(list("1", "a", "b"), stabilize_int)
    Condition <stbl-error-cant_stabilize_each>
      Error in `wrapped_stabilize_each()`:
      ! `val` <list> must have every element satisfy `spec`.
      x Location 2: `val[[2]]` <character> must be coercible to <integer> (Locations: 1)
      x Location 3: `val[[3]]` <character> must be coercible to <integer> (Locations: 1)

