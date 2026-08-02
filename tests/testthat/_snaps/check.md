# .check_na() works (#95)

    Code
      .check_na(c(1, NA), allow_na = FALSE)
    Condition <stbl-error-bad_na>
      Error:
      ! `c(1, NA)` must not contain NA values.
      * NA locations: 2

# .check_size() works (#95)

    Code
      .check_size(1:5, 6, 10)
    Condition <stbl-error-size_too_small>
      Error:
      ! `1:5` must have size >= 6.
      x 5 is too small.

---

    Code
      .check_size(1:5, 1, 4)
    Condition <stbl-error-size_too_large>
      Error:
      ! `1:5` must have size <= 4.
      x 5 is too big.

# .check_scalar() works (#95)

    Code
      .check_scalar(1:2)
    Condition <stbl-error-non_scalar>
      Error:
      ! `1:2` must be a single <integer>.
      x `1:2` has 2 values.

---

    Code
      .check_scalar(NULL, allow_null = FALSE)
    Condition <stbl-error-non_scalar>
      Error:
      ! `NULL` must be a single <non-NULL>.
      x `NULL` has no values.

---

    Code
      .check_scalar(character(), allow_zero_length = FALSE)
    Condition <stbl-error-bad_empty>
      Error:
      ! `character()` must be a single <character (non-empty)>.
      x `character()` has no values.

# .check_x_no_more_than_y() works (#95)

    Code
      .check_x_no_more_than_y(2, 1)
    Condition <stbl-error-size_x_vs_y>
      Error:
      ! `2` can't be larger than `1`.
      * `2` = 2
      * `1` = 1

# .check_cast_failures() works (#310)

    Code
      .check_cast_failures(failures = failures, x_class = "character", to = logical(),
      due_to = "incompatible values", x_arg = "test_arg", call = rlang::current_env())
    Condition <stbl-error-incompatible_values-logical>
      Error:
      ! `test_arg` <character> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 2 and 4

# .check_all_named() works (#203)

    Code
      .check_all_named(list(1, 2))
    Condition <stbl-error-bad_named>
      Error:
      ! `list(1, 2)` must have all elements named.

# .check_not_jagged() works (#203)

    Code
      .check_not_jagged(list(a = 1:3, b = 1:2))
    Condition <stbl-error-jagged>
      Error:
      ! Can't coerce `list(a = 1:3, b = 1:2)` <list> to <data.frame>.
      i All list elements must have length 3 or 1.
      x Short elements: b = 2.

