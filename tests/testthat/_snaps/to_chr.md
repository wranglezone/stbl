# to_chr() respects allow_null (#22)

    Code
      to_chr(given, allow_null = FALSE)
    Condition
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_chr(given, allow_null = FALSE)
    Condition
      Error in `wrapped_to_chr()`:
      ! `val` must not be <NULL>.

# to_chr() fails gracefully for weird cases (#22)

    Code
      to_chr(given)
    Condition
      Error:
      ! Can't coerce `given` <function> to <character>.

---

    Code
      wrapped_to_chr(given)
    Condition
      Error in `wrapped_to_chr()`:
      ! Can't coerce `val` <function> to <character>.

---

    Code
      to_chr(given)
    Condition
      Error:
      ! Can't coerce `given` <list> to <character>.

---

    Code
      wrapped_to_chr(given)
    Condition
      Error in `wrapped_to_chr()`:
      ! Can't coerce `val` <list> to <character>.

---

    Code
      to_chr(given)
    Condition
      Error:
      ! Can't coerce `given` <list> to <character>.

---

    Code
      wrapped_to_chr(given)
    Condition
      Error in `wrapped_to_chr()`:
      ! Can't coerce `val` <list> to <character>.

---

    Code
      to_chr(given)
    Condition
      Error:
      ! Can't coerce `given` <data.frame> to <character>.

---

    Code
      wrapped_to_chr(given)
    Condition
      Error in `wrapped_to_chr()`:
      ! Can't coerce `val` <data.frame> to <character>.

---

    Code
      to_chr(given)
    Condition
      Error:
      ! Can't coerce `given` <list> to <character>.

---

    Code
      wrapped_to_chr(given)
    Condition
      Error in `wrapped_to_chr()`:
      ! Can't coerce `val` <list> to <character>.

# to_chr_scalar() errors for non-scalars (#22)

    Code
      to_chr_scalar(given)
    Condition
      Error:
      ! `given` must be a single <character>.
      x `given` has 26 values.

---

    Code
      wrapped_to_chr_scalar(given)
    Condition
      Error in `wrapped_to_chr_scalar()`:
      ! `val` must be a single <character>.
      x `val` has 26 values.

# to_chr_scalar() errors for uncoerceable types (#22)

    Code
      to_chr_scalar(given)
    Condition
      Error:
      ! Can't coerce `given` <list> to <character>.

---

    Code
      wrapped_to_chr_scalar(given)
    Condition
      Error in `wrapped_to_chr_scalar()`:
      ! Can't coerce `val` <list> to <character>.

# to_chr_scalar() respects allow_null (#22)

    Code
      to_chr_scalar(given, allow_null = FALSE)
    Condition
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_chr_scalar(given, allow_null = FALSE)
    Condition
      Error in `wrapped_to_chr_scalar()`:
      ! `val` must not be <NULL>.

# to_chr_scalar respects allow_zero_length (#22)

    Code
      to_chr_scalar(given, allow_zero_length = FALSE)
    Condition
      Error:
      ! `given` must be a single <character (non-empty)>.
      x `given` has no values.

