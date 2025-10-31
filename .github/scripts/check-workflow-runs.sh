#!/bin/bash

# This script checks if any *other* runs of this same workflow
# were created *after* the start time of the current run.
# This is used to safely stop redundant runs during an event flurry.

# Exit immediately if a command exits with a non-zero status.
set -e

# GITHUB_RUN_ID is provided by the GitHub Actions environment
if [ -z "$GITHUB_RUN_ID" ]; then
  echo "Error: GITHUB_RUN_ID env var not set. Running update." >&2
  echo "changes=true"
  exit 0
fi

# GITHUB_TOKEN must be passed as an env var to the 'gh' command
echo "Fetching recent workflow runs..." >&2
RAW_RUNS_JSON=$(gh run list --workflow=update-ai.yaml --json databaseId,createdAt --limit 10)

# Find the 'createdAt' time for the *current* run ID
CURRENT_RUN_CREATED_AT=$(echo "$RAW_RUNS_JSON" | jq -r ".[] | select(.databaseId == $GITHUB_RUN_ID) | .createdAt")

if [ -z "$CURRENT_RUN_CREATED_AT" ]; then
  echo "Error: Could not find current run ID $GITHUB_RUN_ID in API response." >&2
  echo "changes=true"
  exit 0
fi

JQ_QUERY=".[] | select(.createdAt > \"$CURRENT_RUN_CREATED_AT\" and .databaseId != $GITHUB_RUN_ID)"
NEWER_RUNS=$(echo "$RAW_RUNS_JSON" | jq -c "$JQ_QUERY") # -c for compact output

if [ -n "$NEWER_RUNS" ]; then
  # Found a newer run. This current run is obsolete and should stop.
  echo "Found newer workflow run(s) started after $CURRENT_RUN_CREATED_AT. Stopping this run." >&2
  echo "changes=false"
else
  # No newer runs found. This run should proceed.
  echo "No newer runs found. Proceeding." >&2
  echo "changes=true"
fi

