---
name: create-github-issue
description: Creates GitHub issues following a user-story format and posts them via the GitHub API. Use when the user asks to create, file, or open a GitHub issue, or when discussing a feature that should be tracked as an issue.
---

# Create GitHub Issue

## Issue format

Every issue should follow this structure:

```markdown
*Issue created with the assistance of an AI agent.* 

> As a {role}, in order to [achieve a goal], I would like [this feature or change].

[Technical description of the proposed changes or implementation details.]
```

Common roles: `package developer`, `{packagename} user`, `data analyst`, `maintainer`

## Example

For an issue in the `stbl` package:

```markdown
*Issue created with the assistance of an AI agent.*

> As a package developer, in order to validate date inputs in my functions, I would like a `stabilize_date()` function.

Add `to_date()`, `is_date_ish()`, `are_date_ish()`, and `stabilize_date()` functions following the existing patterns for other types. Should support coercion from character strings in ISO 8601 format and from numeric values (days since epoch).
```

## Creating the issue

Use `gh::gh()` to post the issue via the GitHub API. This supports setting issue types directly.

### Basic example

```r
result <- gh::gh(

"POST /repos/{owner}/{repo}/issues",
owner = "wranglezone",
repo = "stbl",
title = "Add stabilize_date() for date validation",
body = "*Issue created with the assistance of an AI agent.*

> As a package developer, in order to validate date inputs in my functions, I would like a `stabilize_date()` function.

Add `to_date()`, `is_date_ish()`, `are_date_ish()`, and `stabilize_date()` functions following the existing patterns for other types."
)
result$html_url
```

### With issue type

```r
result <- gh::gh(
"POST /repos/{owner}/{repo}/issues",
owner = "wranglezone",
repo = "stbl",
title = "Set up AI assistant configuration",
body = "Issue body here...",
type = "Task" # Can be: Feature, Task, Bug, Documentation
)
result$html_url
```

### Available parameters

- `title`: Issue title (required)
- `body`: Issue body
- `type`: Issue type name (e.g., "Feature", "Task", "Bug", "Documentation")
- `labels`: Character vector of label names
- `assignees`: Character vector of usernames
- `milestone`: Milestone number (integer)

### Checking an existing issue's type

```r
issue <- gh::gh("GET /repos/{owner}/{repo}/issues/{issue_number}",
owner = "wranglezone", repo = "stbl", issue_number = 182)
issue$type$name
```

## Workflow

1. Discuss the feature or bug with the user to understand the goal
2. Draft the issue in the user-story format
3. Show the draft to the user for approval
4. Post with `gh::gh()`
5. Report the issue URL back to the user
