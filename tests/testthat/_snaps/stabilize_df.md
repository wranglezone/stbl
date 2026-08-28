# stabilize_df() respects .allow_null (#142)

    Code
      stabilize_df(NULL, .allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      wrapped_stabilize_df(NULL, .allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error in `wrapped_stabilize_df()`:
      ! `val` must not be <NULL>.

# stabilize_df() errors for non-coercible input (#142)

    Code
      stabilize_df("not a data frame")
    Condition <stbl-error-coerce-data.frame>
      Error:
      ! Can't coerce `"not a data frame"` <character> to <data.frame>.

---

    Code
      wrapped_stabilize_df("not a data frame")
    Condition <stbl-error-coerce-data.frame>
      Error in `wrapped_stabilize_df()`:
      ! Can't coerce `val` <character> to <data.frame>.

# stabilize_df() errors when required column is missing (#142)

    Code
      stabilize_df(data.frame(foo = "a"), name = specify_chr_scalar())
    Condition <stbl-error-missing_element>
      Error:
      ! `data.frame(foo = "a")` must contain element "name".

# stabilize_df() errors informatively when column fails validation (#142, #310, #335)

    Code
      stabilize_df(data.frame(count = "not-an-int"), count = specify_int_scalar())
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `data.frame(count = "not-an-int")[["count"]]` <character> must be coercible to <integer>
      x Can't convert some values due to non-numeric strings.
      * Locations: 1
      * Values: "not-an-int"

# stabilize_df() errors on extra columns by default (#142)

    Code
      stabilize_df(data.frame(a = 1L, b = 2L), a = specify_int_scalar())
    Condition <stbl-error-bad_named>
      Error:
      ! `data.frame(a = 1L, b = 2L)` must not contain extra named elements.
      x Extra element: "b"

# stabilize_df() validates extra columns with .extra_cols (#142, #310, #335)

    Code
      stabilize_df(data.frame(a = 1L, b = "not-int"), a = specify_int_scalar(),
      .extra_cols = specify_int_scalar())
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! `data.frame(a = 1L, b = "not-int")[["b"]]` <character> must be coercible to <integer>
      x Can't convert some values due to non-numeric strings.
      * Locations: 1
      * Values: "not-int"

# stabilize_df() enforces .min_rows (snapshot) (#142)

    Code
      stabilize_df(mtcars[0, ], .min_rows = 1, .extra_cols = assert_present)
    Condition <stbl-error-too_few_rows>
      Error:
      ! `mtcars[0, ]` must have at least 1 row.
      x 0 is too few.

# stabilize_df() enforces .max_rows (snapshot) (#142)

    Code
      stabilize_df(mtcars, .max_rows = 5, .extra_cols = assert_present)
    Condition <stbl-error-too_many_rows>
      Error:
      ! `mtcars` must have at most 5 rows.
      x 32 is too many.

# stabilize_df() enforces .col_names (snapshot) (#142)

    Code
      stabilize_df(data.frame(a = 1L), .col_names = c("a", "b"), .extra_cols = assert_present)
    Condition <stbl-error-missing_cols>
      Error:
      ! `data.frame(a = 1L)` must contain column "b".

# stabilize_df() with unnamed specs errors informatively (#142)

    Code
      stabilize_df(data.frame(a = 1L), specify_int_scalar())
    Condition <stbl-error-unnamed_spec>
      Error:
      ! All elements passed via `...` must be named.
      i Each name corresponds to a required element in the list.

