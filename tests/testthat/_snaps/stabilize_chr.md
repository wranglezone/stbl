# stabilize_chr() errors for bad regex matches (#27, #52)

    Code
      stabilize_chr(given, regex = pattern)
    Condition
      Error:
      ! `given` must match the regex pattern "^\\d{5}(?:[-\\s]\\d{4})?$"
      x Some values fail the check.
      x Location: 1
      x Value: 123456789

---

    Code
      wrapped_stabilize_chr(given, regex = pattern)
    Condition
      Error in `wrapped_stabilize_chr()`:
      ! `val` must match the regex pattern "^\\d{5}(?:[-\\s]\\d{4})?$"
      x Some values fail the check.
      x Location: 1
      x Value: 123456789

# stabilize_chr() works with complex url regex (#52)

    Code
      stabilize_chr("example.com", regex = url_regex)
    Output
      [1] "example.com"

---

    Code
      stabilize_chr(c("example.com", "not a url"), regex = url_regex)
    Condition
      Error:
      ! `c("example.com", "not a url")` must match the regex pattern "^(?:(?:(?:https?|ftp):)?\\/\\/)?(?:\\S+(?::\\S*)?@)?(?:(?!(?:10|127)(?:\\.\\d{1,3}){3})(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z0-9\\u00a1-\\uffff][a-z0-9\\u00a1-\\uffff_-]{0,62})?[a-z0-9\\u00a1-\\uffff]\\.)+(?:[a-z\\u00a1-\\uffff]{2,}\\.?))(?::\\d{2,5})?(?:[/?#]\\S*)?$"
      x Some values fail the check.
      x Location: 2
      x Value: not a url

# stabilize_chr() allows for customized error messages (#52)

    Code
      stabilize_chr(c("not a url", "example.com"), regex = c(`must be a url.` = url_regex))
    Condition
      Error:
      ! `c("not a url", "example.com")` must be a url.
      x Some values fail the check.
      x Location: 1
      x Value: not a url

# stabilize_chr() works with regex that contains braces (#52)

    Code
      stabilize_chr(c("b", "aa"), regex = "a{1,3}")
    Condition
      Error:
      ! `c("b", "aa")` must match the regex pattern "a{1,3}"
      x Some values fail the check.
      x Location: 1
      x Value: b

# stabilize_chr() accepts negated regex args (#85)

    Code
      stabilize_chr(given, regex = regex)
    Condition
      Error:
      ! `given` must not match the regex pattern "c"
      x Some values fail the check.
      x Location: 3
      x Value: c

# stabilize_chr() accepts multiple regex rules (#86, #85)

    Code
      stabilize_chr(given, regex = rules)
    Condition
      Error:
      ! `given` must match the regex pattern "a"
      x Some values fail the check.
      x Location: 4
      x Value: plum
      `given` must not match the regex pattern "b"
      x Some values fail the check.
      x Locations: 2 and 3
      x Values: banana and boat

# stabilize_chr() works with stringr::fixed() (#87)

    Code
      stabilize_chr(c("a.b", "acb"), regex = stringr::fixed("a.b"))
    Condition
      Error:
      ! `c("a.b", "acb")` must match the regex pattern "a.b"
      x Some values fail the check.
      x Location: 2
      x Value: acb

# stabilize_chr() works with stringr::coll() (#87)

    Code
      stabilize_chr(c("a", "A"), regex = stringr::coll("a"))
    Condition
      Error:
      ! `c("a", "A")` must match the regex pattern "a"
      x Some values fail the check.
      x Location: 2
      x Value: A

# stabilize_chr() works with stringr::regex() (#87)

    Code
      stabilize_chr(c("A", "B"), regex = stringr::regex("a", ignore_case = TRUE))
    Condition
      Error:
      ! `c("A", "B")` must match the regex pattern "a"
      x Some values fail the check.
      x Location: 2
      x Value: B

# stabilize_chr_scalar() errors for non-scalars (#22)

    Code
      stabilize_chr_scalar(given)
    Condition
      Error:
      ! `given` must be a single <character>.
      x `given` has 26 values.

---

    Code
      wrapped_stabilize_chr_scalar(given)
    Condition
      Error in `wrapped_stabilize_chr_scalar()`:
      ! `val` must be a single <character>.
      x `val` has 26 values.

# stabilize_chr_scalar() works with regex that contains braces (#52)

    Code
      stabilize_chr_scalar("b", regex = "a{1,3}")
    Condition
      Error:
      ! `"b"` must match the regex pattern "a{1,3}"
      x "b" fails the check.

