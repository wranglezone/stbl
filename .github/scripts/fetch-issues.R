library(gh)
library(glue)
library(purrr)
library(jsonlite)

repo_full_name <- Sys.getenv("GITHUB_REPOSITORY")
if (repo_full_name == "") {
  stop(
    "Error: GITHUB_REPOSITORY environment variable not set.\n",
    "Please set it for local testing (e.g., Sys.setenv(GITHUB_REPOSITORY = 'wranglezone/stbl')).",
    call. = FALSE
  )
}
repo_parts <- strsplit(repo_full_name, "/")[[1]]
org_name <- repo_parts[1]
repo_name <- repo_parts[2]

output_path <- ".github/ai/issues.json"

# gh automatically handles pagination with .limit = Inf
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

if (max_issue_number > 0) {
  all_issues <- stats::setNames(
    replicate(max_issue_number, list(), simplify = FALSE),
    seq_len(max_issue_number)
  )

  for (issue in issues_raw) {
    comments <- if (issue$comments > 0) {
      gh::gh(issue$comments_url, .limit = Inf) |>
        purrr::map_chr("body")
    }

    all_issues[[issue$number]] <- list(
      title = issue$title,
      type = issue$type,
      milestone = issue$milestone$number,
      body = issue$body,
      comments = comments
    )
  }

  issue_collection <- list(
    `_metadata` = list(
      description = glue::glue(
        "A collection of GitHub issues for the {repo_name} repository."
      ),
      lookup_key = "issue_number",
      comment = "Each key in the 'issues' object is a string representation of the GitHub issue number. Empty objects are placeholders so that positions and ids match. Empty objects should be ignored."
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
}
