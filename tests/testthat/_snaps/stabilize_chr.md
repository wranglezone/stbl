# stabilize_chr() errors for bad regex matches (#27, #52, #310)

    Code
      stabilize_chr(given, regex = pattern)
    Condition <stbl-error-regex_mismatch>
      Error:
      ! `given` must match the regex pattern "^\\d{5}(?:[-\\s]\\d{4})?$"
      x Some values fail the check.
      x Location: 1
      x Value: 123456789

---

    Code
      wrapped_stabilize_chr(given, regex = pattern)
    Condition <stbl-error-regex_mismatch>
      Error in `wrapped_stabilize_chr()`:
      ! `val` must match the regex pattern "^\\d{5}(?:[-\\s]\\d{4})?$"
      x Some values fail the check.
      x Location: 1
      x Value: 123456789

# stabilize_chr() works with complex url regex (#52, #310)

    Code
      stabilize_chr("example.com", regex = url_regex)
    Output
      [1] "example.com"

---

    Code
      stabilize_chr(c("example.com", "not a url"), regex = url_regex)
    Condition <stbl-error-regex_mismatch>
      Error:
      ! `c("example.com", "not a url")` must match the regex pattern "^(?:(?:(?:https?|ftp):)?\\/\\/)?(?:\\S+(?::\\S*)?@)?(?:(?!(?:10|127)(?:\\.\\d{1,3}){3})(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z0-9\\u00a1-\\uffff][a-z0-9\\u00a1-\\uffff_-]{0,62})?[a-z0-9\\u00a1-\\uffff]\\.)+(?:[a-z\\u00a1-\\uffff]{2,}\\.?))(?::\\d{2,5})?(?:[/?#]\\S*)?$"
      x Some values fail the check.
      x Location: 2
      x Value: not a url

# stabilize_chr() allows for customized error messages (#52, #310)

    Code
      stabilize_chr(c("not a url", "example.com"), regex = c(`must be a url.` = url_regex))
    Condition <stbl-error-regex_mismatch>
      Error:
      ! `c("not a url", "example.com")` must be a url.
      x Some values fail the check.
      x Location: 1
      x Value: not a url

# stabilize_chr() works with regex that contains braces (#52, #310)

    Code
      stabilize_chr(c("b", "aa"), regex = "a{1,3}")
    Condition <stbl-error-regex_mismatch>
      Error:
      ! `c("b", "aa")` must match the regex pattern "a{1,3}"
      x Some values fail the check.
      x Location: 1
      x Value: b

# stabilize_chr() accepts negated regex args (#85, #310)

    Code
      stabilize_chr(given, regex = regex)
    Condition <stbl-error-regex_mismatch>
      Error:
      ! `given` must not match the regex pattern "c"
      x Some values fail the check.
      x Location: 3
      x Value: c

# stabilize_chr() accepts multiple regex rules (#86, #85, #310)

    Code
      stabilize_chr(given, regex = rules)
    Condition <stbl-error-regex_mismatch>
      Error:
      ! `given` must match the regex pattern "a"
      x Some values fail the check.
      x Location: 4
      x Value: plum
      `given` must not match the regex pattern "b"
      x Some values fail the check.
      x Locations: 2 and 3
      x Values: banana and boat

# stabilize_chr() works with stringr::fixed() (#87, #310)

    Code
      stabilize_chr(c("a.b", "acb"), regex = stringr::fixed("a.b"))
    Condition <stbl-error-regex_mismatch>
      Error:
      ! `c("a.b", "acb")` must match the regex pattern "a.b"
      x Some values fail the check.
      x Location: 2
      x Value: acb

# stabilize_chr() works with stringr::coll() (#87, #310)

    Code
      stabilize_chr(c("a", "A"), regex = stringr::coll("a"))
    Condition <stbl-error-regex_mismatch>
      Error:
      ! `c("a", "A")` must match the regex pattern "a"
      x Some values fail the check.
      x Location: 2
      x Value: A

# stabilize_chr() works with stringr::regex() (#87, #310)

    Code
      stabilize_chr(c("A", "B"), regex = stringr::regex("a", ignore_case = TRUE))
    Condition <stbl-error-regex_mismatch>
      Error:
      ! `c("A", "B")` must match the regex pattern "a"
      x Some values fail the check.
      x Location: 2
      x Value: B

# stabilize_chr_scalar() respects allow_null (#22, #189)

    Code
      stabilize_chr_scalar(given)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_stabilize_chr_scalar(given)
    Condition <stbl-error-bad_null>
      Error in `wrapped_stabilize_chr_scalar()`:
      ! `val` must not be <NULL>.

# stabilize_chr_scalar() errors for non-scalars (#22)

    Code
      stabilize_chr_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <character>.
      x `given` has 26 values.

---

    Code
      wrapped_stabilize_chr_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_stabilize_chr_scalar()`:
      ! `val` must be a single <character>.
      x `val` has 26 values.

# stabilize_chr_scalar() works with regex that contains braces (#52, #310)

    Code
      stabilize_chr_scalar("b", regex = "a{1,3}")
    Condition <stbl-error-regex_mismatch>
      Error:
      ! `"b"` must match the regex pattern "a{1,3}"
      x "b" fails the check.

# stabilize_chr() errors when elements have too few characters (#275)

    Code
      stabilize_chr(c("hi", "hello"), min_characters = 3)
    Condition <stbl-error-n_characters-too_few>
      Error:
      ! Each element of `c("hi", "hello")` must have >= 3 characters.
      i Some elements have too few characters.
      x Location: 1
      x Value: hi

---

    Code
      wrapped_stabilize_chr(c("hi", "hello"), min_characters = 3)
    Condition <stbl-error-n_characters-too_few>
      Error in `wrapped_stabilize_chr()`:
      ! Each element of `val` must have >= 3 characters.
      i Some elements have too few characters.
      x Location: 1
      x Value: hi

# stabilize_chr() errors when elements have too many characters (#275)

    Code
      stabilize_chr(c("hi", "hello"), max_characters = 3)
    Condition <stbl-error-n_characters-too_many>
      Error:
      ! Each element of `c("hi", "hello")` must have <= 3 characters.
      i Some elements have too many characters.
      x Location: 2
      x Value: hello

---

    Code
      wrapped_stabilize_chr(c("hi", "hello"), max_characters = 3)
    Condition <stbl-error-n_characters-too_many>
      Error in `wrapped_stabilize_chr()`:
      ! Each element of `val` must have <= 3 characters.
      i Some elements have too many characters.
      x Location: 2
      x Value: hello

# stabilize_chr() errors for single element with wrong character count (#275)

    Code
      stabilize_chr("hi", min_characters = 5)
    Condition <stbl-error-n_characters-too_few>
      Error:
      ! Each element of `"hi"` must have >= 5 characters.
      x "hi" has 2 characters.

---

    Code
      stabilize_chr("hello", max_characters = 3)
    Condition <stbl-error-n_characters-too_many>
      Error:
      ! Each element of `"hello"` must have <= 3 characters.
      x "hello" has 5 characters.

# stabilize_chr() errors when both min and max fail (#275)

    Code
      stabilize_chr(c("a", "hello_world"), min_characters = 2, max_characters = 5)
    Condition <stbl-error-n_characters>
      Error:
      ! Each element of `c("a", "hello_world")` must have >= 2 characters.
      i Some elements have too few characters.
      x Location: 1
      x Value: a
      Each element of `c("a", "hello_world")` must have <= 5 characters.
      i Some elements have too many characters.
      x Location: 2
      x Value: hello_world

# stabilize_chr() errors when min_characters > max_characters (#275)

    Code
      stabilize_chr("hello", min_characters = 5, max_characters = 3)
    Condition <stbl-error-size_x_vs_y>
      Error:
      ! `min_characters` can't be larger than `max_characters`.
      * `min_characters` = 5
      * `max_characters` = 3

# stabilize_chr_scalar() errors for wrong character count (#275)

    Code
      stabilize_chr_scalar("hi", min_characters = 5)
    Condition <stbl-error-n_characters-too_few>
      Error:
      ! Each element of `"hi"` must have >= 5 characters.
      x "hi" has 2 characters.

---

    Code
      stabilize_chr_scalar("hello", max_characters = 3)
    Condition <stbl-error-n_characters-too_many>
      Error:
      ! Each element of `"hello"` must have <= 3 characters.
      x "hello" has 5 characters.

