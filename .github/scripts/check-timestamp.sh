#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

WORKFLOW_START_TIME="$1"
# Define a temp file name and ensure it's cleaned up on exit
TEMP_JSON_FILE=".github-ai-issues.tmp.json"
trap 'rm -f "$TEMP_JSON_FILE"' EXIT

if [ -z "$WORKFLOW_START_TIME" ]; then
  echo "Error: WORKFLOW_START_TIME argument is missing. Running update." >&2
  echo "changes=true"
  exit 0
fi

# Try to fetch the 'ai' branch.
# If it fails (e.g., branch doesn't exist), we definitely need to run the update.
if ! git fetch origin ai >/dev/null 2>&1; then
  echo "Could not fetch 'ai' branch (might not exist yet). Running update." >&2
  echo "changes=true"
  exit 0
fi

# Default to running the update
CHANGES="true"

# Check if the remote branch origin/ai actually exists
# We've successfully fetched, so we can check origin/ai
if git rev-parse --verify origin/ai >/dev/null 2>&1; then
  # Branch exists. Try to get the file from it.
  # '2>/dev/null' hides errors if the file doesn't exist on the branch.
  if git show origin/ai:.github/ai/issues.json > "$TEMP_JSON_FILE" 2>/dev/null; then
    # File exists on the 'ai' branch and we've copied it to our temp file.
    JSON_TIMESTAMP=$(jq -r '._metadata.updated_at // empty' "$TEMP_JSON_FILE")

    if [ -z "$JSON_TIMESTAMP" ]; then
      echo "No timestamp in issues.json on 'ai' branch. Running update." >&2
      CHANGES="true"
    else
      # Compare ISO 8601 timestamps as strings
      if [[ "$JSON_TIMESTAMP" < "$WORKFLOW_START_TIME" ]]; then
        echo "issues.json ($JSON_TIMESTAMP) is older than workflow start time ($WORKFLOW_START_TIME). Running update." >&2
        CHANGES="true"
      else
        echo "issues.json ($JSON_TIMESTAMP) is up-to-date (workflow start: $WORKFLOW_START_TIME). No changes needed." >&2
        CHANGES="false" # This is the only path where we skip the update
      fi
    fi
  else
    # File .github/ai/issues.json does not exist on 'ai' branch.
    echo "issues.json not found on 'ai' branch. Running update." >&2
    CHANGES="true"
  fi
else
  # This case should be redundant now because of the fetch check,
  # but we'll keep it as a safeguard.
  echo "Branch 'ai' not found on remote. Running update." >&2
  CHANGES="true"
fi

# This is the string that will be captured by $GITHUB_OUTPUT
# It is the *only* line that should go to stdout.
echo "changes=$CHANGES"
