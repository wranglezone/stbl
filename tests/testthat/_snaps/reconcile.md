# reconcile() errors with no values (#408)

    Code
      reconcile()
    Condition <stbl-error-empty_values>
      Error:
      ! `reconcile()` requires at least one value.

# reconcile() rejects lossy and non-equivalent atomic pairs (#408)

    Code
      reconcile(0.5, TRUE)
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `0.5` and `TRUE` must be equivalent.

# reconcile() handles empty vectors (#408)

    Code
      reconcile(integer(), 1L)
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `integer()` and `1L` must be equivalent.
      x Lengths differ.

# reconcile() requires matching names (#408)

    Code
      reconcile(c(a = 1), c(b = 1L))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `c(a = 1)` and `c(b = 1L)` must be equivalent.
      x Names differ.

# reconcile() treats lists and atomic vectors as different categories (#408)

    Code
      reconcile(1:2, list(1, 2))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `1:2` and `list(1, 2)` must be equivalent.

# reconcile() rejects factors that are not identical (#408)

    Code
      reconcile("c", factor("a", levels = c("a", "b")))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `"c"` and `factor("a", levels = c("a", "b"))` must be equivalent.

---

    Code
      reconcile(factor(c("a", "b")), factor(c("a", "b"), levels = c("b", "a")))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `factor(c("a", "b"))` and `factor(c("a", "b"), levels = c("b", "a"))` must be equivalent.
      x Levels differ.

---

    Code
      reconcile(factor("a"), factor("a", ordered = TRUE))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `factor("a")` and `factor("a", ordered = TRUE)` must be equivalent.
      x Ordering differs.

# reconcile() rejects date-times with different time zones (#408)

    Code
      reconcile(utc, tokyo)
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `utc` and `tokyo` must be equivalent.
      x Time zones differ.

# reconcile() reconciles hms and Period values (#408)

    Code
      reconcile(period, lubridate::seconds(6))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `period` and `lubridate::seconds(6)` must be equivalent.

# reconcile() compares unranked types with vctrs (#408)

    Code
      reconcile(one_i, two_i)
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `one_i` and `two_i` must be equivalent.

---

    Code
      reconcile(as.raw(1), as.raw(1), one_i)
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `as.raw(1)` and `one_i` must be equivalent.

# reconcile() treats classed objects and other objects as equivalent only to equal values (#408)

    Code
      reconcile(foo, 1)
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `foo` and `1` must be equivalent.

---

    Code
      reconcile(env, new.env())
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `env` and `new.env()` must be equivalent.

# reconcile() reports the path to nested differences (#408)

    Code
      reconcile(list(a = list(1, 2:3)), list(a = list(1, c(2L, 4L))))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `list(a = list(1, 2:3))` and `list(a = list(1, c(2L, 4L)))` must be equivalent.
      i The first difference is at `$a[[2]]`.

---

    Code
      reconcile(list(`a b` = 1), list(`a b` = "x"))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `` list(`a b` = 1) `` and `` list(`a b` = "x") `` must be equivalent.
      i The first difference is at `` $`a b` ``.

# reconcile() requires matching list structure (#408)

    Code
      reconcile(list(1), list(1, 2))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `list(1)` and `list(1, 2)` must be equivalent.
      x Lengths differ.

---

    Code
      reconcile(list(a = 1), list(b = 1))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `list(a = 1)` and `list(b = 1)` must be equivalent.
      x Names differ.

---

    Code
      reconcile(attributed, list(1))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `attributed` and `list(1)` must be equivalent.
      x Attributes differ.

# reconcile() requires matching data frame structure (#408)

    Code
      reconcile(data.frame(a = 1), data.frame(b = 1))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `data.frame(a = 1)` and `data.frame(b = 1)` must be equivalent.
      x Column names differ.

---

    Code
      reconcile(data.frame(a = 1, b = 2), data.frame(b = 2, a = 1))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `data.frame(a = 1, b = 2)` and `data.frame(b = 2, a = 1)` must be equivalent.
      x Column names differ.

---

    Code
      reconcile(data.frame(a = 1), data.frame(a = 1, row.names = "x"))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `data.frame(a = 1)` and `data.frame(a = 1, row.names = "x")` must be equivalent.
      x Row names differ.

---

    Code
      reconcile(data.frame(a = 1), tibble::tibble(a = 1))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `data.frame(a = 1)` and `tibble::tibble(a = 1)` must be equivalent.
      x Classes differ.

---

    Code
      reconcile(data.frame(a = 1), list(a = 1))
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `data.frame(a = 1)` and `list(a = 1)` must be equivalent.

# reconcile() only treats identical functions and NULL as equivalent (#408)

    Code
      reconcile(mean, median)
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `mean` and `median` must be equivalent.

# reconcile() checks every pair of three or more values (#408)

    Code
      reconcile("TRUE", TRUE, 1L)
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `"TRUE"` and `1L` must be equivalent.

---

    Code
      reconcile(1L, TRUE, "TRUE")
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `1L` and `"TRUE"` must be equivalent.

# reconcile() uses names as labels (#408)

    Code
      reconcile(first = 0.5, second = TRUE)
    Condition <stbl-error-cant_reconcile>
      Error:
      ! `first` and `second` must be equivalent.

# reconcile() reports errors from the caller's perspective (#408)

    Code
      wrapped_reconcile(0.5, TRUE)
    Condition <stbl-error-cant_reconcile>
      Error in `wrapped_reconcile()`:
      ! `val` and `TRUE` must be equivalent.

