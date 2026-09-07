# to_one_of() errors when prototypes overlap and more than one matches (#286)

    Code
      to_one_of("1", integer(), double())
    Condition <stbl-error-cant_stabilize_one_of>
      Error:
      ! `"1"` must match exactly one of the provided specifications, but matched 2.
      i Matched specifications: "integer" and "double"

---

    Code
      wrapped_to_one_of("1", integer(), double())
    Condition <stbl-error-cant_stabilize_one_of>
      Error in `wrapped_to_one_of()`:
      ! `val` must match exactly one of the provided specifications, but matched 2.
      i Matched specifications: "integer" and "double"

# to_one_of() errors with a combined message when no prototype matches (#286)

    Code
      to_one_of(new.env(), integer(), character())
    Condition <stbl-error-cant_stabilize_one_of>
      Error:
      ! `new.env()` must match exactly one of the provided specifications, but matched none.
      x `new.env()` must be a vector, not an environment.
      x Can't coerce `new.env()` <environment> to <character>.

---

    Code
      wrapped_to_one_of(new.env(), integer(), character())
    Condition <stbl-error-cant_stabilize_one_of>
      Error in `wrapped_to_one_of()`:
      ! `val` must match exactly one of the provided specifications, but matched none.
      x `val` must be a vector, not an environment.
      x Can't coerce `val` <environment> to <character>.

# to_one_of() errors when ... is empty (#286)

    Code
      to_one_of(1L)
    Condition <stbl-error-empty_specs>
      Error:
      ! At least one function must be provided via `...`.
      i Supply stabilizer functions, or prototypes for `to_any_of()`.

