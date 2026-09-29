# Check that every R/to_*.R file declares its target class(es) in a
# `# target class:` header, and that each declared class has a corresponding
# to() method in R/to.R. Fails with a non-zero exit code on any violation.

to_files <- list.files("R", pattern = "^to_.*\\.R$", full.names = TRUE)

header_re <- "^# target class: (.+)$"

# file -> character vector of claimed classes ("NA" means intentionally none)
claims <- lapply(to_files, function(f) {
  lines <- readLines(f, warn = FALSE)
  header <- grep(header_re, lines, value = TRUE)
  if (length(header) != 1L) {
    return(list(file = f, error = "missing or duplicated `# target class:` header"))
  }
  classes <- sub(header_re, "\\1", header)
  classes <- trimws(strsplit(classes, ",", fixed = TRUE)[[1]])
  list(file = f, classes = classes)
})

errors <- character()

is_error <- vapply(claims, function(x) !is.null(x$error), logical(1))
errors <- c(errors, vapply(
  claims[is_error],
  function(x) sprintf("%s: %s", x$file, x$error),
  character(1)
))

claims <- claims[!is_error]
claimed <- unlist(lapply(claims, `[[`, "classes"))
claimed <- claimed[claimed != "NA"]

# No two files may claim the same class
dupes <- unique(claimed[duplicated(claimed)])
if (length(dupes)) {
  for (d in dupes) {
    files <- vapply(
      claims,
      function(x) if (d %in% x$classes) x$file else NA_character_,
      character(1)
    )
    errors <- c(
      errors,
      sprintf(
        "class %s claimed by multiple files: %s",
        sQuote(d),
        paste(shQuote(files[!is.na(files)]), collapse = ", ")
      )
    )
  }
}

# Every claimed class needs a to.<class>() method in R/to.R
to_r <- readLines("R/to.R", warn = FALSE)
methods <- regmatches(
  to_r,
  regexec("^to\\.([.A-Za-z0-9_]+) <- function", to_r)
)
methods <- vapply(
  methods[lengths(methods) > 0],
  `[[`,
  character(1),
  2L
)

missing_methods <- setdiff(claimed, methods)
if (length(missing_methods)) {
  errors <- c(
    errors,
    sprintf(
      "no to() method in R/to.R for claimed class(es): %s",
      paste(sQuote(missing_methods), collapse = ", ")
    )
  )
}

if (length(errors)) {
  message("to() registry check failed:")
  for (e in errors) {
    message("- ", e)
  }
  quit(status = 1L, save = "no")
}

message("to() registry check passed.")
