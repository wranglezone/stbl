#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

WORKFLOW_START_TIME="$1"
# Define a temp file name and ensure it's cleaned up on exit
TEMP_JSON_FILE=".github-ai-issues.tmp.json"
trap 'rm -f "$TEMP_JSON_FILE"' EXIT

if [ -z "$WORKFLOW_START_TIME" ]; then
  echo "Error: WORKFLOW_START_TIME argument is missing." >&2
  exit 1
fi

# Try to fetch the 'ai' branch. This just gets the objects, doesn't change HEAD.
# '|| true' allows this to pass even if 'ai' branch doesn't exist on remote.
git fetch origin ai || true

# Default to running the update
CHANGES="true"

# Check if the remote branch origin/ai actually exists
if git rev-parse --verify origin/ai >/dev/null 2>&1; then
  # Branch exists. Try to get the file from it.
  # '2>/dev/null' hides errors if the file doesn't exist on the branch.
  if git show origin/ai:.github/ai/issues.json > "$TEMP_JSON_FILE" 2>/dev/null; then
    # File exists on the 'ai' branch and we've copied it to our temp file.
    JSON_TIMESTAMP=$(jq -r '._metadata.updated_at // empty' "$TEMP_JSON_FILE")

    if [ -z "$JSON_TIMESTAMP" ]; then
      echo "No timestamp in issues.json on 'ai' branch. Running update."
      CHANGES="true"
    else
      # Compare ISO 8601 timestamps as strings
      if [[ "$JSON_TIMESTAMP" < "$WORKFLOW_START_TIME" ]]; then
        echo "issues.json ($JSON_TIMESTAMP) is older than workflow start time ($WORKFLOW_START_TIME). Running update."
        CHANGES="true"
      else
        echo "issues.json ($JSON_TIMESTAMP) is up-to-date (workflow start: $WORKFLOW_START_TIME). No changes needed."
        CHANGES="false" # This is the only path where we skip the update
      fi
    fi
  else
    # File .github/ai/issues.json does not exist on 'ai' branch.
    echo "issues.json not found on 'ai' branch. Running update."
    CHANGES="true"
  fi
else
  # Remote branch 'origin/ai' does not exist.
  echo "Branch 'ai' not found on remote. Running update."
  CHANGES="true"
fi

# This is the string that will be captured by $GITHUB_OUTPUT
echo "changes=$CHANGES"
