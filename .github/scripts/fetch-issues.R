library(gh)
library(glue)
library(purrr)
library(jsonlite)

repo_full_name <- Sys.getenv("GITHUB_REPOSITORY")
if (isTRUE(grepl("/", repo_full_name))) {
  repo_parts <- strsplit(repo_full_name, "/")[[1]]
} else {
  repo_parts <- unname(gh::gh_tree_remote())
}

if (length(repo_parts) != 2) {
  stop(
    "Error: GITHUB_REPOSITORY environment variable not set correctly.\n",
    "Please set it for local testing (e.g., Sys.setenv(GITHUB_REPOSITORY = 'wranglezone/stbl')).",
    call. = FALSE
  )
}

org_name <- repo_parts[[1]]
repo_name <- repo_parts[[2]]

output_path <- ".github/ai/issues.json"

issues_raw <- gh::gh(
  "/repos/{owner}/{repo}/issues",
  owner = org_name,
  repo = repo_name,
  state = "open",
  .limit = Inf
)

max_issue_number <- if (length(issues_raw)) {
  max(purrr::map_int(issues_raw, "number"))
} else {
  0
}

all_issues <- list()
max_timestamp <- purrr::map_chr(
  issues_raw,
  function(issue) {
    timestamps <- unlist(issue[c("created_at", "updated_at", "closed_at")])
    if (!length(timestamps)) {
      return(NA_character_)
    }
    max(timestamps, na.rm = TRUE)
  }
)

if (max_issue_number > 0) {
  max_timestamp <- max(max_timestamp, na.rm = TRUE)

  all_issues <- stats::setNames(
    replicate(max_issue_number, list(), simplify = FALSE),
    seq_len(max_issue_number)
  )

  for (issue in issues_raw) {
    comments <- if (issue$comments > 0) {
      tryCatch(
        {
          gh::gh(issue$comments_url, .limit = Inf) |>
            purrr::map_chr("body")
        },
        error = function(e) {
          character(0)
        }
      )
    } else {
      character(0)
    }

    all_issues[[issue$number]] <- list(
      title = issue$title,
      type = issue$type,
      milestone = issue$milestone$number,
      body = issue$body,
      comments = comments
    )
  }
}

if (!length(max_timestamp) || is.na(max_timestamp)) {
  max_timestamp <- "1970-01-01T00:00:00Z"
}

issue_collection <- list(
  `_metadata` = list(
    description = glue::glue(
      "A collection of GitHub issues for the {repo_name} repository."
    ),
    lookup_key = "issue_number",
    comment = "Each key in the 'issues' object is a string representation of the GitHub issue number. Empty objects are placeholders so that positions and ids match. Empty objects should be ignored.",
    updated_at = max_timestamp
  ),
  issues = all_issues
)

if (!dir.exists(dirname(output_path))) {
  dir.create(dirname(output_path), recursive = TRUE)
}

jsonlite::write_json(
  issue_collection,
  output_path,
  auto_unbox = TRUE,
  pretty = TRUE
)
