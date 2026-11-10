#' Create a specified character stabilizer function
#'
#' `specify_chr()` creates a function that will call [stabilize_chr()] with the
#' provided arguments. `specify_chr_scalar()` creates a function that will call
#' [stabilize_chr_scalar()] with the provided arguments. `specify_character()`
#' is a synonym of `specify_chr()`, and `specify_character_scalar()` is a
#' synonym of `specify_chr_scalar()`.
#'
#' @inheritParams .shared-params
#' @returns A function of class `"stbl_specified_fn"` that calls
#'   [stabilize_chr()] or [stabilize_chr_scalar()] with the provided arguments.
#'   The generated function will also accept `...` for additional arguments to
#'   pass to [stabilize_chr()] or [stabilize_chr_scalar()]. You can copy/paste
#'   the body of the resulting function if you want to provide additional
#'   context or functionality.
#' @family character functions
#' @family specification functions
#' @export
#'
#' @examples
#' stabilize_email <- specify_chr(regex = "^[^@]+@[^@]+\\.[^@]+$")
#' stabilize_email("stbl@example.com")
#' try(stabilize_email("not-an-email-address"))
specify_chr <- function(
  allow_null = TRUE,
  allow_na = TRUE,
  named = NULL,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_characters = NULL,
  max_characters = NULL,
  regex = NULL,
  allowed_values = NULL,
  coerce_function = FALSE
) {
  factory_args <- .capture_factory_args()
  .specify_cls("chr", factory_args, prep_exprs = .quote_fn_exprs())
}

#' @export
#' @rdname specify_chr
specify_chr_scalar <- function(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  named = NULL,
  min_characters = NULL,
  max_characters = NULL,
  regex = NULL,
  allowed_values = NULL,
  coerce_function = FALSE
) {
  factory_args <- .capture_factory_args()
  .specify_cls(
    "chr",
    factory_args,
    scalar = TRUE,
    prep_exprs = .quote_fn_exprs()
  )
}

#' @export
#' @rdname specify_chr
specify_character <- specify_chr

#' @export
#' @rdname specify_chr
specify_character_scalar <- specify_chr_scalar

#' Expressions to capture a function's call-site name in a specified function
#'
#' The generated function wraps `x`, so the stabilizer would otherwise see the
#' symbol `x` instead of what the user supplied. Functions are wrapped in a
#' quosure so the call-site expression is preserved.
#'
#' @returns A list of expressions to run in the generated function.
#' @keywords internal
.quote_fn_exprs <- function() {
  # Dummy variables to avoid R CMD check undefined global variable notes.
  x_arg <- "x_arg"
  x_class <- "x_class"
  rlang::exprs(
    {
      # enquo() must precede is.function(), and the defaults must be forced before
      # reassigning `x`, since they inspect it.
      x_quo <- rlang::enquo(x)
      force(x_arg)
      force(x_class)
      if (is.function(x)) {
        x <- x_quo
      }
    }
  )
}
