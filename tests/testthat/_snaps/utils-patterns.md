# .normalize_patterns() errors for invalid patterns (#292)

    Code
      .normalize_patterns("a", ".patterns", call)
    Condition <stbl-error-bad_patterns-not_list>
      Error:
      ! `.patterns` must be a named list of stabilizers.

---

    Code
      .normalize_patterns(list(stabilize_int), ".patterns", call)
    Condition <stbl-error-bad_patterns-missing_name>
      Error:
      ! `.patterns` must have a regular expression as the name of every element.

---

    Code
      .normalize_patterns(list(`[` = stabilize_int, `(` = stabilize_int), ".patterns",
      call)
    Condition <stbl-error-bad_patterns-invalid_regex>
      Error:
      ! `.patterns` must have valid regular expressions as names.
      x Invalid patterns: "[" and "("

---

    Code
      .normalize_patterns(list(a = 1, b = stabilize_int), ".patterns", call)
    Condition <stbl-error-bad_patterns-invalid_spec>
      Error:
      ! `.patterns` must have a stabilizer function as every value.
      x Invalid spec for: "a"

# .validate_pattern_elements() reports all failures together (#292)

    Code
      .validate_pattern_elements(x, nms, list(), patterns, matches, "x", rlang::current_env())
    Condition <stbl-error-cant_stabilize_patterns>
      Error:
      ! `x` must have every element matching `.patterns` satisfy its spec.
      x Location 1: `x[["S_a"]]` <character> must be convertible to <integer> (Locations: 1)
      x Location 3: `x[["S_c"]]` <character> must be convertible to <integer> (Locations: 1)

# .validate_pattern_elements() errors for specs that disagree (#292)

    Code
      .validate_pattern_elements(x, "a_b", list(), patterns, .match_patterns("a_b",
        patterns), "x", rlang::current_env())
    Condition <stbl-error-cant_stabilize_patterns>
      Error:
      ! `x` must have every element matching `.patterns` satisfy its spec.
      x Location 1: `x[["a_b"]]` must be converted equivalently by every provided stabilizer.

