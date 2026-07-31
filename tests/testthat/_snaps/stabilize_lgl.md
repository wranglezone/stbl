# stabilize_lgl() checks NAs (#28)

    Code
      (expect_pkg_error_classes(stabilize_lgl(given, allow_na = FALSE), "stbl",
      "bad_na"))
    Output
      <error/stbl-error-bad_na>
      Error:
      ! `given` must not contain NA values.
      * NA locations: 2

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_lgl(given, allow_na = FALSE),
      "stbl", "bad_na"))
    Output
      <error/stbl-error-bad_na>
      Error in `wrapped_stabilize_lgl()`:
      ! `val` must not contain NA values.
      * NA locations: 2

# stabilize_lgl() checks min_size (#28)

    Code
      (expect_pkg_error_classes(stabilize_lgl(given, min_size = 5), "stbl",
      "size_too_small"))
    Output
      <error/stbl-error-size_too_small>
      Error:
      ! `given` must have size >= 5.
      x 4 is too small.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_lgl(given, min_size = 5), "stbl",
      "size_too_small"))
    Output
      <error/stbl-error-size_too_small>
      Error in `wrapped_stabilize_lgl()`:
      ! `val` must have size >= 5.
      x 4 is too small.

# stabilize_lgl() checks max_size (#28)

    Code
      (expect_pkg_error_classes(stabilize_lgl(given, max_size = 3), "stbl",
      "size_too_large"))
    Output
      <error/stbl-error-size_too_large>
      Error:
      ! `given` must have size <= 3.
      x 4 is too big.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_lgl(given, max_size = 3), "stbl",
      "size_too_large"))
    Output
      <error/stbl-error-size_too_large>
      Error in `wrapped_stabilize_lgl()`:
      ! `val` must have size <= 3.
      x 4 is too big.

# stabilize_lgl_scalar() respects allow_null (#28, #189)

    Code
      (expect_pkg_error_classes(stabilize_lgl_scalar(given), "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_lgl_scalar(given), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_stabilize_lgl_scalar()`:
      ! `val` must not be <NULL>.

# stabilize_lgl_scalar() errors on non-scalars (#28)

    Code
      (expect_pkg_error_classes(stabilize_lgl_scalar(given), "stbl", "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error:
      ! `given` must be a single <logical>.
      x `given` has 3 values.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_lgl_scalar(given), "stbl",
      "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error in `wrapped_stabilize_lgl_scalar()`:
      ! `val` must be a single <logical>.
      x `val` has 3 values.

