# to() errors for non-coercible types to function (#250)

    Code
      to(1L, mean)
    Condition
      Error:
      ! Can't coerce `1L` <integer> to <function>.

