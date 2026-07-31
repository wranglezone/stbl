# to_any_of() errors with a combined message when all prototypes fail (#215, #285)

    Code
      to_any_of(new.env(), integer(), character())
    Condition <stbl-error-cant_stabilize_any_of>
      Error:
      ! `new.env()` must match at least one of the provided stabilizers.
      x `new.env()` must be a vector, not an environment.
      x Can't coerce `new.env()` <environment> to <character>.

---

    Code
      wrapped_to_any_of(new.env(), integer(), character())
    Condition <stbl-error-cant_stabilize_any_of>
      Error in `wrapped_to_any_of()`:
      ! `val` must match at least one of the provided stabilizers.
      x `val` must be a vector, not an environment.
      x Can't coerce `val` <environment> to <character>.

# to_any_of() errors when ... is empty (#215, #285)

    Code
      to_any_of(1L)
    Condition <stbl-error-empty_specs>
      Error:
      ! At least one function must be provided via `...`.
      i Supply stabilizer functions, or prototypes for `to_any_of()`.

