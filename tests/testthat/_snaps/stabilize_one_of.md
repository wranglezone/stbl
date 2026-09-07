# stabilize_one_of() errors when specs overlap and more than one matches (#286)

    Code
      stabilize_one_of("1", stabilize_int, stabilize_dbl)
    Condition <stbl-error-cant_stabilize_one_of>
      Error:
      ! `"1"` must match exactly one of the provided specifications, but matched 2.
      i Matched specifications: "stabilize_int" and "stabilize_dbl"

---

    Code
      wrapped_stabilize_one_of("1", stabilize_int, stabilize_dbl)
    Condition <stbl-error-cant_stabilize_one_of>
      Error in `wrapped_stabilize_one_of()`:
      ! `val` must match exactly one of the provided specifications, but matched 2.
      i Matched specifications: "stabilize_int" and "stabilize_dbl"

# stabilize_one_of() errors with a combined message when no function succeeds (#286)

    Code
      stabilize_one_of(NULL, specify_int(allow_null = FALSE), specify_chr(allow_null = FALSE))
    Condition <stbl-error-cant_stabilize_one_of>
      Error:
      ! `NULL` must match exactly one of the provided specifications, but matched none.
      x `NULL` must not be <NULL>.
      x `NULL` must not be <NULL>.

---

    Code
      wrapped_stabilize_one_of(NULL, specify_int(allow_null = FALSE), specify_chr(
        allow_null = FALSE))
    Condition <stbl-error-cant_stabilize_one_of>
      Error in `wrapped_stabilize_one_of()`:
      ! `val` must match exactly one of the provided specifications, but matched none.
      x `val` must not be <NULL>.
      x `val` must not be <NULL>.

# stabilize_one_of() includes Locations from incompatible_values errors (#286)

    Code
      stabilize_one_of(x, stabilize_lgl, stabilize_int)
    Condition <stbl-error-cant_stabilize_one_of>
      Error:
      ! `x` must match exactly one of the provided specifications, but matched none.
      x `x` <character> must be coercible to <logical> (Locations: 1)
      x `x` <character> must be coercible to <integer> (Locations: 1 and 3)

---

    Code
      wrapped_stabilize_one_of(x, stabilize_lgl, stabilize_int)
    Condition <stbl-error-cant_stabilize_one_of>
      Error in `wrapped_stabilize_one_of()`:
      ! `val` must match exactly one of the provided specifications, but matched none.
      x `val` <character> must be coercible to <logical> (Locations: 1)
      x `val` <character> must be coercible to <integer> (Locations: 1 and 3)

# stabilize_one_of() names the matched specs when more than one succeeds (#286)

    Code
      stabilize_one_of(1L, stabilize_int, stabilize_int_scalar, stabilize_chr)
    Condition <stbl-error-cant_stabilize_one_of>
      Error:
      ! `1L` must match exactly one of the provided specifications, but matched 3.
      i Matched specifications: "stabilize_int", "stabilize_int_scalar", and "stabilize_chr"

# stabilize_one_of() errors when ... is empty (#286)

    Code
      stabilize_one_of(1L)
    Condition <stbl-error-empty_specs>
      Error:
      ! At least one function must be provided via `...`.
      i Supply stabilizer functions, or prototypes for `to_any_of()`.

# stabilize_one_of() errors when ... contains named elements (#286)

    Code
      stabilize_one_of(1L, int = stabilize_int)
    Condition <stbl-error-named_spec>
      Error:
      ! All elements passed via `...` must be unnamed.

