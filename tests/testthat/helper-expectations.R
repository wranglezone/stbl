# Used to scrub temp paths from snapshots.
.transform_path <- function(path) {
  function(x) {
    stringr::str_replace_all(
      x,
      stringr::fixed(as.character(path)),
      "PATH"
    )
  }
}
