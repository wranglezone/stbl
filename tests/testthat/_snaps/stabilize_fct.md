# stabilize_fct() throws errors for bad levels (#62, #67)

    Code
      (expect_pkg_error_classes(stabilize_fct(letters[1:5], levels = c("a", "c"),
      to_na = "b"), "stbl", "fct_levels"))
    Output
      <error/stbl-error-fct_levels>
      Error:
      ! Each value of `letters[1:5]` must be in the expected levels.
      i Allowed levels: "a" and "c".
      i Values that are converted to `NA`: "b".
      x Unexpected values: "d" and "e".

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_fct(letters[1:5], levels = c("a",
        "c"), to_na = "b"), "stbl", "fct_levels"))
    Output
      <error/stbl-error-fct_levels>
      Error in `wrapped_stabilize_fct()`:
      ! Each value of `val` must be in the expected levels.
      i Allowed levels: "a" and "c".
      i Values that are converted to `NA`: "b".
      x Unexpected values: "d" and "e".

# stabilize_fct_scalar() respects allow_null (#62, #189)

    Code
      (expect_pkg_error_classes(stabilize_fct_scalar(given), "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_fct_scalar(given), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_stabilize_fct_scalar()`:
      ! `val` must not be <NULL>.

# stabilize_fct_scalar() errors for non-scalars (#62)

    Code
      (expect_pkg_error_classes(stabilize_fct_scalar(given), "stbl", "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error:
      ! `given` must be a single <factor>.
      x `given` has 26 values.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_fct_scalar(given), "stbl",
      "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error in `wrapped_stabilize_fct_scalar()`:
      ! `val` must be a single <factor>.
      x `val` has 26 values.

