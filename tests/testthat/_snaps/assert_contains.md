# assert_contains() errors when fewer than min_matches elements match (#290)

    Code
      assert_contains(list("a", "b"), stabilize_int)
    Condition <stbl-error-too_few_matches>
      Error:
      ! `list("a", "b")` <list> must contain at least 1 element matching `spec`.
      x Found 0 matching elements.

---

    Code
      wrapped_assert_contains(list("a", "b"), stabilize_int)
    Condition <stbl-error-too_few_matches>
      Error in `wrapped_assert_contains()`:
      ! `val` <list> must contain at least 1 element matching `spec`.
      x Found 0 matching elements.

# assert_contains() errors when more than max_matches elements match (#290)

    Code
      assert_contains(list("1", "2", "3"), stabilize_int, max_matches = 2)
    Condition <stbl-error-too_many_matches>
      Error:
      ! `list("1", "2", "3")` <list> must contain at most 2 elements matching `spec`.
      x Found 3 matching elements.

# assert_contains() default min_matches is 1 (#290)

    Code
      assert_contains(list("a", "b"), stabilize_int)
    Condition <stbl-error-too_few_matches>
      Error:
      ! `list("a", "b")` <list> must contain at least 1 element matching `spec`.
      x Found 0 matching elements.

# assert_contains() errors when min_matches < 1 (#290)

    Code
      assert_contains(list(1L), stabilize_int, min_matches = 0)
    Condition <stbl-error-outside_range>
      Error:
      ! `min_matches` must be >= 1.
      x 0 is too low.

# assert_contains() errors when max_matches < min_matches (#290)

    Code
      assert_contains(list(1L), stabilize_int, min_matches = 2, max_matches = 1)
    Condition <stbl-error-outside_range>
      Error:
      ! `max_matches` must be >= 2.
      x 1 is too low.

