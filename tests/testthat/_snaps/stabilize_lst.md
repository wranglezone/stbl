# stabilize_lst() respects .allow_null (#110)

    Code
      (expect_pkg_error_classes(stabilize_lst(NULL, .allow_null = FALSE), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_lst(NULL, .allow_null = FALSE),
      "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_stabilize_lst()`:
      ! `val` must not be <NULL>.

# stabilize_lst() errors when required named element is missing (#110)

    Code
      (expect_pkg_error_classes(stabilize_lst(list(foo = "a"), name = specify_chr_scalar()),
      "stbl", "missing_element"))
    Output
      <error/stbl-error-missing_element>
      Error:
      ! `list(foo = "a")` must contain element "name".

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_lst(list(foo = "a"), name = specify_chr_scalar()),
      "stbl", "missing_element"))
    Output
      <error/stbl-error-missing_element>
      Error in `wrapped_stabilize_lst()`:
      ! `val` must contain element "name".

# stabilize_lst() errors informatively when element fails validation (#110)

    Code
      (expect_pkg_error_classes(stabilize_lst(list(count = "not-an-int"), count = specify_int_scalar()),
      "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `list(count = "not-an-int")[["count"]]` <character> must be coercible to <integer>
      x Can't convert some values due to incompatible values.
      * Locations: 1

# stabilize_lst() errors on extra named elements by default (#110)

    Code
      (expect_pkg_error_classes(stabilize_lst(list(a = 1L, b = 2L)), "stbl",
      "bad_named"))
    Output
      <error/stbl-error-bad_named>
      Error:
      ! `list(a = 1L, b = 2L)` must not contain extra named elements.
      x Extra elements: "a" and "b"

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_lst(list(a = 1L, b = 2L)), "stbl",
      "bad_named"))
    Output
      <error/stbl-error-bad_named>
      Error in `wrapped_stabilize_lst()`:
      ! `val` must not contain extra named elements.
      x Extra elements: "a" and "b"

# stabilize_lst() errors on unnamed elements by default (#110)

    Code
      (expect_pkg_error_classes(stabilize_lst(list(1L, 2L)), "stbl", "bad_unnamed"))
    Output
      <error/stbl-error-bad_unnamed>
      Error:
      ! `list(1L, 2L)` must not contain unnamed elements.
      x Unnamed positions: 1 and 2

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_lst(list(1L, 2L)), "stbl",
      "bad_unnamed"))
    Output
      <error/stbl-error-bad_unnamed>
      Error in `wrapped_stabilize_lst()`:
      ! `val` must not contain unnamed elements.
      x Unnamed positions: 1 and 2

# stabilize_lst() enforces .min_size (#110)

    Code
      (expect_pkg_error_classes(stabilize_lst(list(a = 1L), .named = specify_int_scalar(),
      .min_size = 2), "stbl", "size_too_small"))
    Output
      <error/stbl-error-size_too_small>
      Error:
      ! `list(a = 1L)` must have size >= 2.
      x 1 is too small.

# stabilize_lst() validates nested lists (#110)

    Code
      (expect_pkg_error_classes(stabilize_lst(list(aes = list(x = mtcars, y = "hp")),
      aes = spec_aes), "stbl", "coerce", "character"))
    Output
      <error/stbl-error-coerce-character>
      Error:
      ! Can't coerce `list(aes = list(x = mtcars, y = "hp"))[["aes"]][["x"]]` <data.frame> to <character>.

# .check_duplicate_names(): errors on duplicate names by default (#110)

    Code
      (expect_pkg_error_classes(stabilize_lst(list(a = 1L, a = 2L), .named = specify_int_scalar()),
      "stbl", "duplicate_names"))
    Output
      <error/stbl-error-duplicate_names>
      Error:
      ! `list(a = 1L, a = 2L)` must not contain duplicate names.
      x Duplicate name: "a"

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_lst(list(a = 1L, a = 2L), .named = specify_int_scalar()),
      "stbl", "duplicate_names"))
    Output
      <error/stbl-error-duplicate_names>
      Error in `wrapped_stabilize_lst()`:
      ! `val` must not contain duplicate names.
      x Duplicate name: "a"

# .check_duplicate_names(): reports all duplicate name groups (#110)

    Code
      stabilize_lst(list(a = 1L, b = 2L, a = 3L, b = 4L), .named = specify_int_scalar())
    Condition
      Error:
      ! `list(a = 1L, b = 2L, a = 3L, b = 4L)` must not contain duplicate names.
      x Duplicate names: "a" and "b"

