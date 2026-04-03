# specify_df() errors when required column is missing (#142)

    Code
      (expect_pkg_error_classes(validator(data.frame(name = "Alice")), "stbl",
      "missing_element"))
    Output
      <error/stbl-error-missing_element>
      Error:
      ! `data.frame(name = "Alice")` must contain element "age".

# specify_df() passes through .min_rows, .max_rows (#142)

    Code
      (expect_pkg_error_classes(validator(data.frame(a = 1L)), "stbl", "too_few_rows")
      )
    Output
      <error/stbl-error-too_few_rows>
      Error:
      ! `data.frame(a = 1L)` must have at least 2 rows.
      x 1 is too few.

# specify_df() passes through .col_names (#142)

    Code
      (expect_pkg_error_classes(validator(data.frame(a = 1L)), "stbl", "missing_cols")
      )
    Output
      <error/stbl-error-missing_cols>
      Error:
      ! `data.frame(a = 1L)` must contain column "b".

