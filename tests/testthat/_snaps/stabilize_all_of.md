# stabilize_all_of() errors when any function fails (#278)

    Code
      stabilize_all_of("a", stabilize_int, stabilize_chr)
    Condition <stbl-error-cant_stabilize_all_of>
      Error:
      ! `"a"` must match all of the provided stabilizers.
      x `"a"` <character> must be coercible to <integer> (Locations: 1)

---

    Code
      wrapped_stabilize_all_of("a", stabilize_int, stabilize_chr)
    Condition <stbl-error-cant_stabilize_all_of>
      Error in `wrapped_stabilize_all_of()`:
      ! `val` must match all of the provided stabilizers.
      x `val` <character> must be coercible to <integer> (Locations: 1)

# stabilize_all_of() errors when a later spec rejects a value an earlier spec accepted (#278)

    Code
      stabilize_all_of(1L, stabilize_int, specify_dbl(min_value = 10))
    Condition <stbl-error-cant_stabilize_all_of>
      Error:
      ! `1L` must match all of the provided stabilizers.
      x `1L` must be >= 10.

# stabilize_all_of() applies every spec to the original x, not to previous results (#278)

    Code
      stabilize_all_of("1", stabilize_int, specify_dbl(coerce_character = FALSE))
    Condition <stbl-error-cant_stabilize_all_of>
      Error:
      ! `"1"` must match all of the provided stabilizers.
      x Can't coerce `"1"` <character> to <double>.

# stabilize_all_of() errors when specs succeed but disagree on the coerced value (#278)

    Code
      stabilize_all_of(1L, stabilize_int, specify_dbl())
    Condition <stbl-error-inconsistent_all_of>
      Error:
      ! `1L` must be coerced the same way by every provided stabilizer.
      i The provided stabilizers succeeded, but disagreed on the coerced value.

# stabilize_all_of() includes Locations from incompatible_values errors (#278)

    Code
      stabilize_all_of(x, stabilize_int, stabilize_chr)
    Condition <stbl-error-cant_stabilize_all_of>
      Error:
      ! `x` must match all of the provided stabilizers.
      x `x` <character> must be coercible to <integer> (Locations: 2)

# stabilize_all_of() errors when ... is empty (#278)

    Code
      stabilize_all_of(1L)
    Condition <stbl-error-empty_specs>
      Error:
      ! At least one function must be provided via `...`.
      i Supply stabilizer functions, or prototypes for `to_any_of()`.

# stabilize_all_of() errors when ... contains named elements (#278)

    Code
      stabilize_all_of(1L, int = stabilize_int)
    Condition <stbl-error-named_spec>
      Error:
      ! All elements passed via `...` must be unnamed.
      i Functions are applied to `x` in sequence, not by name.

