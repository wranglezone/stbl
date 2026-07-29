# to_one_of() errors with a combined message when all prototypes fail (#215)

    Code
      (expect_pkg_error_classes(to_one_of(new.env(), integer(), character()), "stbl",
      "cant_stabilize_one_of"))
    Output
      <error/stbl-error-cant_stabilize_one_of>
      Error:
      ! `new.env()` must match at least one of the provided stabilizers.
      x `new.env()` must be a vector, not an environment.
      x Can't coerce `new.env()` <environment> to <character>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_one_of(new.env(), integer(), character()),
      "stbl", "cant_stabilize_one_of"))
    Output
      <error/stbl-error-cant_stabilize_one_of>
      Error in `wrapped_to_one_of()`:
      ! `val` must match at least one of the provided stabilizers.
      x `val` must be a vector, not an environment.
      x Can't coerce `val` <environment> to <character>.

# to_one_of() errors when ... is empty (#215)

    Code
      (expect_pkg_error_classes(to_one_of(1L), "stbl", "empty_specs"))
    Output
      <error/stbl-error-empty_specs>
      Error:
      ! At least one function must be provided via `...`.
      i Supply stabilizer functions, or prototypes for `to_one_of()`.

