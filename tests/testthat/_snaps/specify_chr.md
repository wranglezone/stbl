# specify_chr throws helpful errors for duplicated dots

    Code
      regex_checker("12345", regex = ".*")
    Condition
      Error in `regex_checker()`:
      ! Arguments passed via `...` cannot duplicate specification.
      i Duplicated arguments: `regex`

