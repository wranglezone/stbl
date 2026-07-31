# to_fct() throws errors for bad levels (#62, #67, #177)

    Code
      (expect_pkg_error_classes(to_fct(letters[1:5], levels = c("a", "c"), to_na = "b"),
      "stbl", "fct_levels"))
    Output
      <error/stbl-error-fct_levels>
      Error:
      ! Each value of `letters[1:5]` must be in the expected levels.
      i Allowed levels: "a" and "c".
      i Values that are converted to `NA`: "b".
      x Unexpected values: "d" and "e".

---

    Code
      (expect_pkg_error_classes(wrapped_to_fct(letters[1:5], levels = c("a", "c"),
      to_na = "b"), "stbl", "fct_levels"))
    Output
      <error/stbl-error-fct_levels>
      Error in `wrapped_to_fct()`:
      ! Each value of `val` must be in the expected levels.
      i Allowed levels: "a" and "c".
      i Values that are converted to `NA`: "b".
      x Unexpected values: "d" and "e".

# to_fct() respects allow_null (#62)

    Code
      (expect_pkg_error_classes(to_fct(given, allow_null = FALSE), "stbl", "bad_null")
      )
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_fct(given, allow_null = FALSE), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_to_fct()`:
      ! `val` must not be <NULL>.

# to_fct() works for lists (#64, #273)

    Code
      (expect_pkg_error_classes(to_fct(list("a", 1:5)), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `list("a", 1:5)` <list> must be coercible to <factor>
      x Can't convert some values due to incompatible element types.
      * Locations: 2

# to_fct() errors for things that can't be coerced (#62, #273)

    Code
      (expect_pkg_error_classes(to_fct(given), "stbl", "coerce", "factor"))
    Output
      <error/stbl-error-coerce-factor>
      Error:
      ! Can't coerce `given` <function> to <factor>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_fct(given), "stbl", "coerce", "factor"))
    Output
      <error/stbl-error-coerce-factor>
      Error in `wrapped_to_fct()`:
      ! Can't coerce `val` <function> to <factor>.

---

    Code
      (expect_pkg_error_classes(to_fct(given), "stbl", "coerce", "factor"))
    Output
      <error/stbl-error-coerce-factor>
      Error:
      ! Can't coerce `given` <data.frame> to <factor>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_fct(given), "stbl", "coerce", "factor"))
    Output
      <error/stbl-error-coerce-factor>
      Error in `wrapped_to_fct()`:
      ! Can't coerce `val` <data.frame> to <factor>.

---

    Code
      (expect_pkg_error_classes(to_fct(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `given` <list> must be coercible to <factor>
      x Can't convert some values due to incompatible element types.
      * Locations: 1 and 2

---

    Code
      (expect_pkg_error_classes(wrapped_to_fct(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error in `wrapped_to_fct()`:
      ! `val` <list> must be coercible to <factor>
      x Can't convert some values due to incompatible element types.
      * Locations: 1 and 2

# to_fct_scalar() provides informative error messages (#62)

    Code
      (expect_pkg_error_classes(to_fct_scalar(given), "stbl", "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error:
      ! `given` must be a single <factor>.
      x `given` has 26 values.

---

    Code
      (expect_pkg_error_classes(wrapped_to_fct_scalar(given), "stbl", "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error in `wrapped_to_fct_scalar()`:
      ! `val` must be a single <factor>.
      x `val` has 26 values.

# to_fct_scalar respects allow_zero_length (#62, #43, #45, #189)

    Code
      (expect_pkg_error_classes(to_fct_scalar(given), "stbl", "bad_empty"))
    Output
      <error/stbl-error-bad_empty>
      Error:
      ! `given` must be a single <factor (non-empty)>.
      x `given` has no values.

# to_fct() errors for ints with unexpected levels (#241)

    Code
      (expect_pkg_error_classes(to_fct(given, levels = c("1", "2")), "stbl",
      "fct_levels"))
    Output
      <error/stbl-error-fct_levels>
      Error:
      ! Each value of `<chr>` must be in the expected levels.
      i Allowed levels: "1" and "2".
      x Unexpected values: "3".

---

    Code
      (expect_pkg_error_classes(wrapped_to_fct(given, levels = c("1", "2")), "stbl",
      "fct_levels"))
    Output
      <error/stbl-error-fct_levels>
      Error in `wrapped_to_fct()`:
      ! Each value of `<chr>` must be in the expected levels.
      i Allowed levels: "1" and "2".
      x Unexpected values: "3".

