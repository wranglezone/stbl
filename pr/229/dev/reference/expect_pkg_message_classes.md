# Test package message classes

When you use
[`pkg_inform()`](https://stbl.wrangle.zone/dev/reference/pkg_inform.md)
to signal messages, you can use this function to test that those
messages are generated as expected.

## Usage

``` r
expect_pkg_message_classes(object, package, ...)
```

## Arguments

- object:

  An expression that is expected to throw a message.

- package:

  `(length-1 character)` The name of the package to use in classes.

- ...:

  `(character)` Components of the class name, from least-specific to
  most.

## Value

The classes of the message invisibly on success or the message on
failure. Unlike most testthat expectations, this expectation cannot be
usefully chained.

## Examples

``` r
expect_pkg_message_classes(
  pkg_inform("stbl", "This is a test message", "test_subclass"),
  "stbl",
  "test_subclass"
)
#> <message/stbl-message-test_subclass>
#> Message:
#> This is a test message
try(
  expect_pkg_message_classes(
    pkg_inform("stbl", "This is a test message", "test_subclass"),
    "stbl",
    "different_subclass"
  )
)
#> Error : Expected `m` to have class "stbl-message-different_subclass"/"stbl-message"/"stbl-condition"/"rlang_message"/"message"/"condition".
#> Actual class: "stbl-message-test_subclass"/"stbl-message"/"stbl-condition"/"rlang_message"/"message"/"condition".
```
