# specify_cls builds the expected function snapshot with no args (#150)

    Code
      baseline
    Output
      function (x, ..., x_arg = rlang::caller_arg(x), call = rlang::caller_env(), 
          x_class = stbl::object_type(x)) 
      {
          stbl::stabilize_chr(x, ..., x_arg = x_arg, call = call, x_class = x_class)
      }
      attr(,"class")
      [1] "stbl_specified_fn" "function"         

# specify_cls builds the expected function snapshot with at least one arg (#150, #161)

    Code
      no_null
    Output
      function (x, ..., x_arg = rlang::caller_arg(x), call = rlang::caller_env(), 
          x_class = stbl::object_type(x)) 
      {
          {
              duplicated_args <- intersect(...names(), "allow_null")
              if (length(duplicated_args)) {
                  stbl::pkg_abort("stbl", message = c("Arguments passed via `...` cannot duplicate specification.", 
                      i = "Duplicated arguments: {.arg {duplicated_args}}"), 
                      subclass = "duplicate_args")
              }
          }
          stbl::stabilize_chr(x, allow_null = FALSE, ..., x_arg = x_arg, 
              call = call, x_class = x_class)
      }
      attr(,"class")
      [1] "stbl_specified_fn" "function"         

# The function built via specify_cls errors informatively for duplicated args (#150, #161)

    Code
      no_null(NULL, allow_null = FALSE)
    Condition
      Error in `no_null()`:
      ! Arguments passed via `...` cannot duplicate specification.
      i Duplicated arguments: `allow_null`

# specify_cls builds the expected scalar function snapshot (#150)

    Code
      scalar_checker
    Output
      function (x, ..., x_arg = rlang::caller_arg(x), call = rlang::caller_env(), 
          x_class = stbl::object_type(x)) 
      {
          stbl::stabilize_chr_scalar(x, ..., x_arg = x_arg, call = call, 
              x_class = x_class)
      }
      attr(,"class")
      [1] "stbl_specified_fn" "function"         

