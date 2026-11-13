# stabilize_lst_positional() errors with a combined message (#284)

    Code
      stabilize_lst_positional(list("a", "b", "c"), stabilize_chr_scalar,
      stabilize_int_scalar, stabilize_lgl_scalar)
    Condition <stbl-error-cant_stabilize_positional>
      Error:
      ! `list("a", "b", "c")` <list> must satisfy the spec at every position.
      x Position 2: `list("a", "b", "c")[[2]]` <character> must be convertible to <integer> (Locations: 1)
      x Position 3: `list("a", "b", "c")[[3]]` <character> must be convertible to <logical> (Locations: 1)

---

    Code
      stabilize_lst_positional(list(1L, 2L), stabilize_int_scalar)
    Condition <stbl-error-bad_additional>
      Error:
      ! `list(1L, 2L)` must not contain more than 1 element.
      x Extra position: 2

---

    Code
      stabilize_lst_positional(list(1L), stabilize_int_scalar, stabilize_int_scalar)
    Condition <stbl-error-missing_element>
      Error:
      ! `list(1L)` must contain at least 2 elements.
      x `list(1L)` has 1.

