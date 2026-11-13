# specify_each() specifiers report x_arg in errors (#402)

    Code
      specify_each(stabilize_int)(my_x)
    Condition <stbl-error-cant_stabilize_each>
      Error:
      ! `my_x` <list> must have every element satisfy `spec`.
      x Location 1: `my_x[[1]]` <character> must be convertible to <integer> (Locations: 1)

