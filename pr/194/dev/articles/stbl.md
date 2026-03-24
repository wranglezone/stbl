# Getting started with stbl

``` r
library(stbl)
```

The goal of {stbl} is to help you stabilize function arguments *before*
you use them. This is especially important when a function performs a
slow or expensive operation, like writing to a database or calling a web
API. You want to fail fast and with a clear error message if the inputs
aren’t right.

This vignette demonstrates this principle by incrementally building a
single function, `register_user()`, which validates several arguments
before hypothetically sending them to an external service.

## The `register_user()` Function

Here is the base function we’ll be improving. Without any checks, it’s
vulnerable to bad inputs that could cause cryptic errors later on or
send corrupt data to our external service.

``` r
register_user <- function(username,
                          email_address,
                          age,
                          is_premium_member,
                          interests) {
  # Imagine this is a slow API call, rather than simply returning the list()
  list(
    username = username,
    email_address = email_address,
    age = age,
    is_premium_member = is_premium_member,
    interests = interests
  )
}
```

## Step 1: Handling a Vector with `to_*()`

Let’s start adding checks. The first check will be for the `interests`
argument. We expect this to be a character vector, but we’re not picky
about the content.
[`to_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
will convert inputs that are character-like (like factors or a simple
list of strings) into a proper character vector.

``` r
register_user <- function(username,
                          email_address,
                          age,
                          is_premium_member,
                          interests) {
  interests <- to_chr(interests)

  list(
    username = username,
    email_address = email_address,
    age = age,
    is_premium_member = is_premium_member,
    interests = interests
  )
}
```

The function still returns the list when `interests` is a character
vector:

``` r
register_user(
  username = "test_user", 
  email_address = "test@example.com", 
  age = 42, 
  is_premium_member = TRUE, 
  interests = c("R", "hiking")    # Note that this is already a character vector
) |> 
  # Note: Throughout this article, we pipe the result into `str()` to make it
  # easier to see the differences.
  str()
#> List of 5
#>  $ username         : chr "test_user"
#>  $ email_address    : chr "test@example.com"
#>  $ age              : num 42
#>  $ is_premium_member: logi TRUE
#>  $ interests        : chr [1:2] "R" "hiking"
```

It also works when `interests` is a list of strings:

``` r
register_user(
  username = "test_user", 
  email_address = "test@example.com", 
  age = 42, 
  is_premium_member = TRUE, 
  interests = list("R", "hiking") # This is a list, but becomes a character vector
) |> str()
#> List of 5
#>  $ username         : chr "test_user"
#>  $ email_address    : chr "test@example.com"
#>  $ age              : num 42
#>  $ is_premium_member: logi TRUE
#>  $ interests        : chr [1:2] "R" "hiking"
```

If the input is something that cannot be reasonably flattened to a
character vector, it fails with a helpful error message:

``` r
# Fails because the list contains a function, which is not character-like.
register_user(
  username = "test_user", 
  email_address = "test@example.com", 
  age = 42, 
  is_premium_member = TRUE, 
  interests = list("R", mean)
)
#> Error in `register_user()`:
#> ! Can't coerce `interests` <list> to <character>.
```

## Step 2: Simple Scalar Coercion with `to_*_scalar()`

Next, we’ll add checks for `age` and `is_premium_member`. These
arguments must each contain a single value. We’ll use the `_scalar`
variants:
[`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md)
and
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md).
These functions are liberal in what they accept. For example,
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
understands that `1`, `"T"`, and `"True"` all mean `TRUE`.

``` r
register_user <- function(username,
                          email_address,
                          age,
                          is_premium_member,
                          interests) {
  interests <- to_chr(interests)
  age <- to_int_scalar(age)
  is_premium_member <- to_lgl_scalar(is_premium_member)

  list(
    username = username,
    email_address = email_address,
    age = age,
    is_premium_member = is_premium_member,
    interests = interests
  )
}
```

When everything follows the rules, `register_user()` works:

``` r
register_user(
  username = "test_user", 
  email_address = "test@example.com", 
  age = "42",                 # Coercible to integer
  is_premium_member = "True", # Coercible to logical
  interests = c("R", "hiking")
) |> str()
#> List of 5
#>  $ username         : chr "test_user"
#>  $ email_address    : chr "test@example.com"
#>  $ age              : int 42
#>  $ is_premium_member: logi TRUE
#>  $ interests        : chr [1:2] "R" "hiking"
```

The `register_user()` function will fail with clear error messages if
the input isn’t a single value or can’t be coerced.

For example, when age is not a single value, `register_user()` throws an
error:

``` r
register_user(
  username = "test_user", 
  email_address = "test@example.com", 
  age = c(30, 31),            # Not a single value
  is_premium_member = TRUE, 
  interests = c("R", "hiking")
)
#> Error in `register_user()`:
#> ! `age` must be a single <integer>.
#> ✖ `age` has 2 values.
```

Likewise, this next example fails because “forty-two” cannot be
converted to an integer:

``` r
register_user(
  username = "test_user", 
  email_address = "test@example.com", 
  age = "forty-two",          # Not coercible to integer
  is_premium_member = TRUE, 
  interests = c("R", "hiking")
)
#> Error in `register_user()`:
#> ! `age` <character> must be coercible to <integer>
#> ✖ Can't convert some values due to incompatible values.
#> • Locations: 1
```

## Step 3: Complex Validation with `stabilize_*()`

Finally, let’s add more complex validation for `username` and
`email_address`. For these, simple type coercion isn’t enough; we need
to check their content and structure using
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md).
This function first coerces the input to character, then applies a list
of validation rules supplied via the `regex` argument (see the
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
documentation for details). If speed matters, you should prefer the
faster `to_*()` functions and only “upgrade” to `stabilize_*()` when you
need these additional checks.

This is our final, fully stabilized function:

``` r
register_user <- function(username,
                          email_address,
                          age,
                          is_premium_member,
                          interests) {
  # Simple checks.
  interests <- to_chr(interests)
  age <- to_int_scalar(age)
  is_premium_member <- to_lgl_scalar(is_premium_member)

  # Make sure the username is a length-1 character vector without any spaces,
  # tabs, or newlines. "\\s" means "any space character".
  space_regex <- c("must not contain spaces" = "\\s")
  attr(space_regex, "negate") <- TRUE
  username <- stabilize_chr_scalar(
    username,
    regex = space_regex
  )

  # The email address has to have the pattern "*@*.*". Or, in regex, "^" (start
  # of string), "[...]+" (one or more of any character in the brackets), "@"
  # (the at sign), "[...]+" (one or more of any character in the brackets),
  # "\\." (a literal period), "[...]{2,}" (two or more of any character in the
  # brackets), "$" (end of string).
  email_regex <- "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
  email_address <- stabilize_chr_scalar(
    email_address,
    regex = c("must be a valid email address" = email_regex)
  )

  list(
    username = username,
    email_address = email_address,
    age = age,
    is_premium_member = is_premium_member,
    interests = interests
  )
}
```

When all of the inputs follow the expectations, the call succeeds:

``` r
register_user(
  username = "test_user", 
  email_address = "test@example.com", 
  age = 42, 
  is_premium_member = TRUE, 
  interests = c("R", "hiking")
) |> str()
#> List of 5
#>  $ username         : chr "test_user"
#>  $ email_address    : chr "test@example.com"
#>  $ age              : int 42
#>  $ is_premium_member: logi TRUE
#>  $ interests        : chr [1:2] "R" "hiking"
```

If anything is wrong, it fails with informative error messages.

When the username has a space, `register_user()` fails with an
informative error message:

``` r
register_user(
  username = "test user", 
  email_address = "test@example.com", 
  age = 42, 
  is_premium_member = TRUE, 
  interests = c("R", "hiking")
)
#> Error in `register_user()`:
#> ! `username` must not contain spaces
#> ✖ "test user" fails the check.
```

This example fails because the email address is invalid:

``` r
register_user(
  username = "test_user", 
  email_address = "not-a-valid-email", 
  age = 42, 
  is_premium_member = TRUE, 
  interests = c("R", "hiking")
)
#> Error in `register_user()`:
#> ! `email_address` must be a valid email address
#> ✖ "not-a-valid-email" fails the check.
```

## Conclusion

Our `register_user()` function is now robust against a variety of bad
inputs. We’ve built up layers of protection:

- [`to_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
  ensures `interests` is a character vector.
- [`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md)
  and
  [`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
  ensure `age` and `is_premium_member` are single values of the correct
  type.
- [`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
  with regex rules ensures `username` and `email_address` meet specific
  content requirements.

If the user enters something strange, they’ll get a clear error message
*before* we do anything expensive, like calling an external API.
