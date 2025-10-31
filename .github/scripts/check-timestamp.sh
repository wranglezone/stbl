#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

WORKFLOW_START_TIME="$1"
JSON_FILE=".github/ai/issues.json"

if [ -z "$WORKFLOW_START_TIME" ]; then
  echo "Error: WORKFLOW_START_TIME argument is missing." >&2
  exit 1
fi

# Pull latest 'ai' branch to make sure we're checking the most recent file
# Add error handling in case the branch doesn't exist yet (e.g., first run)
git pull origin ai || echo "Could not pull 'ai' branch (might not exist yet)."

# Default to no changes needed
CHANGES="false"

if [ ! -f "$JSON_FILE" ]; then
  echo "issues.json not found. Running update."
  CHANGES="true"
else
  # Use jq to extract the timestamp.
  # -r removes quotes.
  # ' // empty' handles case where key doesn't exist or is null.
  JSON_TIMESTAMP=$(jq -r '._metadata.updated_at // empty' "$JSON_FILE")

  if [ -z "$JSON_TIMESTAMP" ]; then
    echo "No timestamp in issues.json. Running update."
    CHANGES="true"
  else
    # Compare ISO 8601 timestamps as strings
    if [[ "$JSON_TIMESTAMP" < "$WORKFLOW_START_TIME" ]]; then
      echo "issues.json ($JSON_TIMESTAMP) is older than workflow start time ($WORKFLOW_START_TIME). Running update."
      CHANGES="true"
    else
      echo "issues.json ($JSON_TIMESTAMP) is up-to-date (workflow start: $WORKFLOW_START_TIME). No changes needed."
      CHANGES="false"
    fi
  fi
fi

# This is the string that will be captured by $GITHUB_OUTPUT
echo "changes=$CHANGES"
