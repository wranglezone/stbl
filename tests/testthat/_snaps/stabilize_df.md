# stabilize_df() respects .allow_null (#142)

    Code
      (expect_pkg_error_classes(stabilize_df(NULL, .allow_null = FALSE), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_df(NULL, .allow_null = FALSE),
      "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_stabilize_df()`:
      ! `val` must not be <NULL>.

# stabilize_df() errors for non-coercible input (#142)

    Code
      (expect_pkg_error_classes(stabilize_df("not a data frame"), "stbl", "coerce",
      "data.frame"))
    Output
      <error/stbl-error-coerce-data.frame>
      Error:
      ! Can't coerce `"not a data frame"` <character> to <data.frame>.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_df("not a data frame"), "stbl",
      "bad_named"))
    Output
      <error/stbl-error-bad_named>
      Error in `wrapped_stabilize_df()`:
      ! `val` must not contain extra named elements.
      x Extra element: "val"

# stabilize_df() errors when required column is missing (#142)

    Code
      (expect_pkg_error_classes(stabilize_df(data.frame(foo = "a"), name = specify_chr_scalar()),
      "stbl", "missing_element"))
    Output
      <error/stbl-error-missing_element>
      Error:
      ! `data.frame(foo = "a")` must contain element "name".

# stabilize_df() errors informatively when column fails validation (#142)

    Code
      (expect_pkg_error_classes(stabilize_df(data.frame(count = "not-an-int"), count = specify_int_scalar()),
      "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `data.frame(count = "not-an-int")[["count"]]` <character> must be coercible to <integer>
      x Can't convert some values due to incompatible values.
      * Locations: 1

# stabilize_df() errors on extra columns by default (#142)

    Code
      (expect_pkg_error_classes(stabilize_df(data.frame(a = 1L, b = 2L), a = specify_int_scalar()),
      "stbl", "bad_named"))
    Output
      <error/stbl-error-bad_named>
      Error:
      ! `data.frame(a = 1L, b = 2L)` must not contain extra named elements.
      x Extra element: "b"

# stabilize_df() validates extra columns with .extra_cols (#142)

    Code
      (expect_pkg_error_classes(stabilize_df(data.frame(a = 1L, b = "not-int"), a = specify_int_scalar(),
      .extra_cols = specify_int_scalar()), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `data.frame(a = 1L, b = "not-int")[["b"]]` <character> must be coercible to <integer>
      x Can't convert some values due to incompatible values.
      * Locations: 1

# stabilize_df() enforces .min_rows (snapshot) (#142)

    Code
      (expect_pkg_error_classes(stabilize_df(mtcars[0, ], .min_rows = 1, .extra_cols = stabilize_present),
      "stbl", "too_few_rows"))
    Output
      <error/stbl-error-too_few_rows>
      Error:
      ! `mtcars[0, ]` must have at least 1 row.
      x 0 is too few.

# stabilize_df() enforces .max_rows (snapshot) (#142)

    Code
      (expect_pkg_error_classes(stabilize_df(mtcars, .max_rows = 5, .extra_cols = stabilize_present),
      "stbl", "too_many_rows"))
    Output
      <error/stbl-error-too_many_rows>
      Error:
      ! `mtcars` must have at most 5 rows.
      x 32 is too many.

# stabilize_df() enforces .col_names (snapshot) (#142)

    Code
      (expect_pkg_error_classes(stabilize_df(data.frame(a = 1L), .col_names = c("a",
        "b"), .extra_cols = stabilize_present), "stbl", "missing_cols"))
    Output
      <error/stbl-error-missing_cols>
      Error:
      ! `data.frame(a = 1L)` must contain column "b".

# stabilize_df() with unnamed specs errors informatively (#142)

    Code
      (expect_pkg_error_classes(stabilize_df(data.frame(a = 1L), specify_int_scalar()),
      "stbl", "unnamed_spec"))
    Output
      <error/stbl-error-unnamed_spec>
      Error:
      ! All elements passed via `...` must be named.
      i Each name corresponds to a required element in the list.

