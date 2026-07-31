# specify_df() errors when required column is missing (#142)

    Code
      validator(data.frame(name = "Alice"))
    Condition <stbl-error-missing_element>
      Error:
      ! `data.frame(name = "Alice")` must contain element "age".

# specify_df() passes through .min_rows, .max_rows (#142)

    Code
      validator(data.frame(a = 1L))
    Condition <stbl-error-too_few_rows>
      Error:
      ! `data.frame(a = 1L)` must have at least 2 rows.
      x 1 is too few.

# specify_df() passes through .col_names (#142)

    Code
      validator(data.frame(a = 1L))
    Condition <stbl-error-missing_cols>
      Error:
      ! `data.frame(a = 1L)` must contain column "b".

