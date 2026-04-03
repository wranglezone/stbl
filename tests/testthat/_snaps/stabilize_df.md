# stabilize_df() respects .allow_null (#199)

    Code
      stabilize_df(NULL, .allow_null = FALSE)
    Condition
      Error:
      ! `NULL` must not be <NULL>.

---

    Code
      wrapped_stabilize_df(NULL, .allow_null = FALSE)
    Condition
      Error in `wrapped_stabilize_df()`:
      ! `val` must not be <NULL>.

# stabilize_df() errors for non-coercible input (#199)

    Code
      stabilize_df("not a data frame")
    Condition
      Error:
      ! Can't coerce `"not a data frame"` <character> to <data.frame>.

---

    Code
      wrapped_stabilize_df("not a data frame")
    Condition
      Error in `wrapped_stabilize_df()`:
      ! Can't coerce `val` <character> to <data.frame>.

# stabilize_df() errors when required column is missing (#199)

    Code
      stabilize_df(data.frame(foo = "a"), name = specify_chr_scalar())
    Condition
      Error:
      ! `data.frame(foo = "a")` must contain element "name".

---

    Code
      wrapped_stabilize_df(data.frame(foo = "a"), name = specify_chr_scalar())
    Condition
      Error in `wrapped_stabilize_df()`:
      ! `val` must contain element "name".

# stabilize_df() errors informatively when column fails validation (#199)

    Code
      stabilize_df(data.frame(count = "not-an-int"), count = specify_int_scalar())
    Condition
      Error:
      ! `data.frame(count = "not-an-int")[["count"]]` <character> must be coercible to <integer>
      x Can't convert some values due to incompatible values.
      * Locations: 1

# stabilize_df() errors on extra columns by default (#199)

    Code
      stabilize_df(data.frame(a = 1L, b = 2L), a = specify_int_scalar())
    Condition
      Error:
      ! `data.frame(a = 1L, b = 2L)` must not contain extra named elements.
      x Extra element: "b"

---

    Code
      wrapped_stabilize_df(data.frame(a = 1L, b = 2L), a = specify_int_scalar())
    Condition
      Error in `wrapped_stabilize_df()`:
      ! `val` must not contain extra named elements.
      x Extra element: "b"

# stabilize_df() enforces .min_rows (#199)

    Code
      stabilize_df(mtcars[0, ], .min_rows = 1, .extra_cols = stabilize_present)
    Condition
      Error:
      ! `mtcars[0, ]` must have at least 1 row.
      x 0 is too few.

---

    Code
      wrapped_stabilize_df(mtcars[0, ], .min_rows = 1, .extra_cols = stabilize_present)
    Condition
      Error in `wrapped_stabilize_df()`:
      ! `val` must have at least 1 row.
      x 0 is too few.

# stabilize_df() enforces .max_rows (#199)

    Code
      stabilize_df(mtcars, .max_rows = 5, .extra_cols = stabilize_present)
    Condition
      Error:
      ! `mtcars` must have at most 5 rows.
      x 32 is too many.

# stabilize_df() enforces .col_names (#199)

    Code
      stabilize_df(data.frame(a = 1L), .col_names = c("a", "b"), .extra_cols = stabilize_present)
    Condition
      Error:
      ! `data.frame(a = 1L)` must contain column "b".

