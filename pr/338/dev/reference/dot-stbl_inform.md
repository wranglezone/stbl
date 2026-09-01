# Signal a message with standards applied

Signal a message with standards applied

## Usage

``` r
.stbl_inform(
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
)
```

## Arguments

- message:

  (`character`) The message for the new message condition. Messages will
  be formatted with
  [`cli::cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.html).

- subclass:

  (`character`) Class(es) to assign to the message. Will be prefixed by
  "stbl-message-".

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- message_env:

  (`environment`) The execution environment to use to evaluate variables
  in error messages.

- parent:

  A parent condition, as you might create during a
  [`rlang::try_fetch()`](https://rlang.r-lib.org/reference/try_fetch.html).
  See [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html)
  for additional information.

- ...:

  Additional parameters passed to
  [`cli::cli_inform()`](https://cli.r-lib.org/reference/cli_abort.html)
  and on to
  [`rlang::inform()`](https://rlang.r-lib.org/reference/abort.html).

## Value

`NULL` invisibly (called for side effects).
