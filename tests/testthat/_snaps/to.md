# to() errors for non-convertible types to function (#250, #377)

    Code
      to(1L, mean)
    Condition
      Error:
      ! Can't convert `1L` <integer> to match `mean` <function>.

# to() names both sides of a stbl-handled conversion (#371, #377)

    Code
      to("a", ptype, x_arg = "x")
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! Can't convert `x` <character> to match `ptype` <integer>.
      x Can't convert some values due to non-numeric strings.
      * Locations: 1
      * Values: "a"

# to() uses a supplied to_arg (#371, #377)

    Code
      to("a", integer(), x_arg = "x", to_arg = "my_ptype")
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! Can't convert `x` <character> to match `my_ptype` <integer>.
      x Can't convert some values due to non-numeric strings.
      * Locations: 1
      * Values: "a"

# to() shows a literal .to as to_arg (#371, #377)

    Code
      to("a", integer(), x_arg = "x")
    Condition <stbl-error-incompatible_values-integer>
      Error:
      ! Can't convert `x` <character> to match `integer()` <integer>.
      x Can't convert some values due to non-numeric strings.
      * Locations: 1
      * Values: "a"

# to() names both sides when falling through to vctrs (#371, #377)

    Code
      to(1L, proto, x_arg = "x")
    Condition <stbl-error-coerce-raw>
      Error:
      ! Can't convert `x` <integer> to match `proto` <raw>.

---

    Code
      to(1L, as.raw(1L), x_arg = "x", to_arg = "y")
    Condition <stbl-error-coerce-raw>
      Error:
      ! Can't convert `x` <integer> to match `y` <raw>.

# to() rejects a non-scalar to_arg (#371)

    Code
      to("a", integer(), to_arg = c("a", "b"))
    Condition <stbl-error-non_scalar>
      Error:
      ! `to_arg` must be a single <character>.
      x `to_arg` has 2 values.

