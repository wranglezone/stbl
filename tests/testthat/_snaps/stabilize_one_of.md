# stabilize_one_of() errors with a combined message when all functions fail (#215)

    Code
      stabilize_one_of(NULL, specify_int(allow_null = FALSE), specify_chr(allow_null = FALSE))
    Condition
      Error:
      ! `NULL` must match at least one of the provided stabilizers.
      x `NULL` must not be <NULL>.
      x `NULL` must not be <NULL>.

---

    Code
      wrapped_stabilize_one_of(NULL, specify_int(allow_null = FALSE), specify_chr(
        allow_null = FALSE))
    Condition
      Error in `wrapped_stabilize_one_of()`:
      ! `val` must match at least one of the provided stabilizers.
      x `val` must not be <NULL>.
      x `val` must not be <NULL>.

# stabilize_one_of() errors when ... is empty (#215)

    Code
      stabilize_one_of(1L)
    Condition
      Error:
      ! At least one function must be provided via `...`.
      i Supply stabilizer functions, or prototypes for `to_one_of()`.

# stabilize_one_of() errors when ... contains named elements (#215)

    Code
      stabilize_one_of(1L, int = stabilize_int)
    Condition
      Error:
      ! All elements passed via `...` must be unnamed.
      i Functions are applied to `x` in sequence, not by name.

# to_one_of() errors with a combined message when all prototypes fail (#215)

    Code
      to_one_of(new.env(), integer(), character())
    Condition
      Error:
      ! `new.env()` must match at least one of the provided stabilizers.
      x `new.env()` must be a vector, not an environment.
      x Can't coerce `new.env()` <environment> to <character>.

---

    Code
      wrapped_to_one_of(new.env(), integer(), character())
    Condition
      Error in `wrapped_to_one_of()`:
      ! `val` must match at least one of the provided stabilizers.
      x `val` must be a vector, not an environment.
      x Can't coerce `val` <environment> to <character>.

# to_one_of() errors when ... is empty (#215)

    Code
      to_one_of(1L)
    Condition
      Error:
      ! At least one function must be provided via `...`.
      i Supply stabilizer functions, or prototypes for `to_one_of()`.

