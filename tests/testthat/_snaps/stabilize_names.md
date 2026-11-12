# stabilize_names() rejects duplicate names by default (#26)

    Code
      stabilize_names(given)
    Condition <stbl-error-duplicate_names>
      Error:
      ! `given` must not contain duplicate names.
      x Duplicate name: "a"

# stabilize_names() requires names to be present (#26)

    Code
      stabilize_names(given, required = c("a", "c", "d"))
    Condition <stbl-error-missing_element>
      Error:
      ! `given` must contain names "c" and "d".

# stabilize_names() reports x_arg in errors (#26)

    Code
      stabilize_names(my_x)
    Condition <stbl-error-duplicate_names>
      Error:
      ! `my_x` must not contain duplicate names.
      x Duplicate name: "a"

