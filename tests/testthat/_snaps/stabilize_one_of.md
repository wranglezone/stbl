# stabilize_one_of() errors with a combined message when all functions fail (#215)

    Code
      (expect_pkg_error_classes(stabilize_one_of(NULL, specify_int(allow_null = FALSE),
      specify_chr(allow_null = FALSE)), "stbl", "cant_stabilize_one_of"))
    Output
      <error/stbl-error-cant_stabilize_one_of>
      Error:
      ! `NULL` must match at least one of the provided stabilizers.
      x `NULL` must not be <NULL>.
      x `NULL` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_one_of(NULL, specify_int(
        allow_null = FALSE), specify_chr(allow_null = FALSE)), "stbl",
      "cant_stabilize_one_of"))
    Output
      <error/stbl-error-cant_stabilize_one_of>
      Error in `wrapped_stabilize_one_of()`:
      ! `val` must match at least one of the provided stabilizers.
      x `val` must not be <NULL>.
      x `val` must not be <NULL>.

# stabilize_one_of() errors when ... is empty (#215)

    Code
      (expect_pkg_error_classes(stabilize_one_of(1L), "stbl", "empty_specs"))
    Output
      <error/stbl-error-empty_specs>
      Error:
      ! At least one function must be provided via `...`.
      i Supply stabilizer functions, or prototypes for `to_one_of()`.

# stabilize_one_of() errors when ... contains named elements (#215)

    Code
      (expect_pkg_error_classes(stabilize_one_of(1L, int = stabilize_int), "stbl",
      "named_spec"))
    Output
      <error/stbl-error-named_spec>
      Error:
      ! All elements passed via `...` must be unnamed.
      i Functions are applied to `x` in sequence, not by name.

