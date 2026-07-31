# stabilize_any_of() errors with a combined message when all functions fail (#215, #285)

    Code
      stabilize_any_of(NULL, specify_int(allow_null = FALSE), specify_chr(allow_null = FALSE))
    Condition <stbl-error-cant_stabilize_any_of>
      Error:
      ! `NULL` must match at least one of the provided stabilizers.
      x `NULL` must not be <NULL>.
      x `NULL` must not be <NULL>.

---

    Code
      wrapped_stabilize_any_of(NULL, specify_int(allow_null = FALSE), specify_chr(
        allow_null = FALSE))
    Condition <stbl-error-cant_stabilize_any_of>
      Error in `wrapped_stabilize_any_of()`:
      ! `val` must match at least one of the provided stabilizers.
      x `val` must not be <NULL>.
      x `val` must not be <NULL>.

# stabilize_any_of() includes Locations from incompatible_type errors (#215, #285)

    Code
      stabilize_any_of(x, stabilize_lgl, stabilize_int)
    Condition <stbl-error-cant_stabilize_any_of>
      Error:
      ! `x` must match at least one of the provided stabilizers.
      x `x` <character> must be coercible to <logical> (Locations: 1)
      x `x` <character> must be coercible to <integer> (Locations: 1 and 3)

---

    Code
      wrapped_stabilize_any_of(x, stabilize_lgl, stabilize_int)
    Condition <stbl-error-cant_stabilize_any_of>
      Error in `wrapped_stabilize_any_of()`:
      ! `val` must match at least one of the provided stabilizers.
      x `val` <character> must be coercible to <logical> (Locations: 1)
      x `val` <character> must be coercible to <integer> (Locations: 1 and 3)

# stabilize_any_of() errors when ... is empty (#215, #285)

    Code
      stabilize_any_of(1L)
    Condition <stbl-error-empty_specs>
      Error:
      ! At least one function must be provided via `...`.
      i Supply stabilizer functions, or prototypes for `to_any_of()`.

# stabilize_any_of() errors when ... contains named elements (#215, #285)

    Code
      stabilize_any_of(1L, int = stabilize_int)
    Condition <stbl-error-named_spec>
      Error:
      ! All elements passed via `...` must be unnamed.
      i Functions are applied to `x` in sequence, not by name.

