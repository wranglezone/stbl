# to() errors for non-coercible types to function (#250)

    Code
      to(1L, mean)
    Condition
      Error:
      ! Can't convert `1L`, an integer vector, to a function.

