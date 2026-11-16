# .normalize_required() errors for invalid leaves (#291)

    Code
      .normalize_required(list(NA_character_), "required", rlang::current_env())
    Condition <stbl-error-bad_required>
      Error:
      ! `required` must contain only non-missing character vectors.
      i Unnamed entries are always required, and named entries are conditional on their name.

# .check_required_present() describes missing names (#291)

    Code
      .check_required_present(required, present = character(), noun = "element",
      x_arg = "x", call = rlang::current_env())
    Condition <stbl-error-missing_element>
      Error:
      ! `x` must contain elements "a" and "z".

---

    Code
      .check_required_present(required, present = c("a", "z", "b", "d", "e"), noun = "column",
      x_arg = "x", call = rlang::current_env())
    Condition <stbl-error-missing_element>
      Error:
      ! `x` must contain column "c" when "b" is present.
      x must contain columns "f" and "g" when "d" and "e" are present.

# .check_required_have_specs() errors when FALSE and specs are missing (#291)

    Code
      .check_required_have_specs(required, spec_names = "a", named = FALSE,
        named_arg = ".extra_cols", call = rlang::current_env())
    Condition <stbl-error-bad_required>
      Error:
      ! Every name in the requirements must have a spec in `...` when `.extra_cols` is `FALSE`.
      x Missing specs for: "b" and "c"
      i Use `NULL` to allow required names without specs.

