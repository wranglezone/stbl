# to_chr() respects allow_null (#22)

    Code
      (expect_pkg_error_classes(to_chr(given, allow_null = FALSE), "stbl", "bad_null")
      )
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_chr(given, allow_null = FALSE), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_to_chr()`:
      ! `val` must not be <NULL>.

# to_chr() errors for anonymous functions (#251)

    Code
      (expect_pkg_error_classes(to_chr(function(x) x), "stbl", "coerce", "character"))
    Output
      <error/stbl-error-coerce-character>
      Error:
      ! Can't coerce `function(x) x` <function> to <character>.
      i Anonymous functions can't be converted to a string name.

# to_chr() fails gracefully for weird cases (#22, #273)

    Code
      (expect_pkg_error_classes(to_chr(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `given` <list> must be coercible to <character>
      x Can't convert some values due to incompatible element types.
      * Locations: 1

---

    Code
      (expect_pkg_error_classes(wrapped_to_chr(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error in `wrapped_to_chr()`:
      ! `val` <list> must be coercible to <character>
      x Can't convert some values due to incompatible element types.
      * Locations: 1

---

    Code
      (expect_pkg_error_classes(to_chr(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `given` <list> must be coercible to <character>
      x Can't convert some values due to incompatible element types.
      * Locations: 2

---

    Code
      (expect_pkg_error_classes(wrapped_to_chr(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error in `wrapped_to_chr()`:
      ! `val` <list> must be coercible to <character>
      x Can't convert some values due to incompatible element types.
      * Locations: 2

---

    Code
      (expect_pkg_error_classes(to_chr(given), "stbl", "coerce", "character"))
    Output
      <error/stbl-error-coerce-character>
      Error:
      ! Can't coerce `given` <data.frame> to <character>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_chr(given), "stbl", "coerce", "character"))
    Output
      <error/stbl-error-coerce-character>
      Error in `wrapped_to_chr()`:
      ! Can't coerce `val` <data.frame> to <character>.

---

    Code
      (expect_pkg_error_classes(to_chr(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `given` <list> must be coercible to <character>
      x Can't convert some values due to incompatible element types.
      * Locations: 2

---

    Code
      (expect_pkg_error_classes(wrapped_to_chr(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error in `wrapped_to_chr()`:
      ! `val` <list> must be coercible to <character>
      x Can't convert some values due to incompatible element types.
      * Locations: 2

# to_chr_scalar() errors for non-scalars (#22)

    Code
      (expect_pkg_error_classes(to_chr_scalar(given), "stbl", "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error:
      ! `given` must be a single <character>.
      x `given` has 26 values.

---

    Code
      (expect_pkg_error_classes(wrapped_to_chr_scalar(given), "stbl", "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error in `wrapped_to_chr_scalar()`:
      ! `val` must be a single <character>.
      x `val` has 26 values.

# to_chr_scalar() errors for uncoerceable types (#22, #273)

    Code
      (expect_pkg_error_classes(to_chr_scalar(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `given` <list> must be coercible to <character>
      x Can't convert some values due to incompatible element types.
      * Locations: 1

---

    Code
      (expect_pkg_error_classes(wrapped_to_chr_scalar(given), "stbl",
      "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error in `wrapped_to_chr_scalar()`:
      ! `val` <list> must be coercible to <character>
      x Can't convert some values due to incompatible element types.
      * Locations: 1

# to_chr_scalar() respects allow_null (#22, #189)

    Code
      (expect_pkg_error_classes(to_chr_scalar(given), "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_chr_scalar(given), "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_to_chr_scalar()`:
      ! `val` must not be <NULL>.

# to_chr_scalar respects allow_zero_length (#22, #43, #45, #189)

    Code
      (expect_pkg_error_classes(to_chr_scalar(given), "stbl", "bad_empty"))
    Output
      <error/stbl-error-bad_empty>
      Error:
      ! `given` must be a single <character (non-empty)>.
      x `given` has no values.

# to_chr() errors for types that can't be coerced (#noissue)

    Code
      (expect_pkg_error_classes(to_chr(given), "stbl", "coerce", "character"))
    Output
      <error/stbl-error-coerce-character>
      Error:
      ! Can't coerce `given` <environment> to <character>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_chr(given), "stbl", "coerce", "character"))
    Output
      <error/stbl-error-coerce-character>
      Error in `wrapped_to_chr()`:
      ! Can't coerce `val` <environment> to <character>.

