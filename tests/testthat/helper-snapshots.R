clean_function_snapshot <- function(x) {
  x[!grepl("<environment:", x)]
}
