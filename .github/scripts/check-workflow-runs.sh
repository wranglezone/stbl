#!/bin/bash

# This script checks if any *other* runs of this same workflow
# were created *after* the start time of the current run.
# This is used to safely stop redundant runs during an event flurry.

# Exit immediately if a command exits with a non-zero status.
set -e

WORKFLOW_START_TIME="$1"
if [ -z "$WORKFLOW_START_TIME" ]; then
  echo "Error: WORKFLOW_START_TIME argument is missing. Running update." >&2
  echo "changes=true"
  exit 0
fi

# GITHUB_RUN_ID is provided by the GitHub Actions environment
if [ -z "$GITHUB_RUN_ID" ]; then
  echo "Error: GITHUB_RUN_ID env var not set. Running update." >&2
  echo "changes=true"
  exit 0
fi

# GITHUB_TOKEN must be passed as an env var to the 'gh' command
# Query for other runs of this workflow created *after* this one started
# We limit to 10 just to be safe, but we only care if 1 or more exist.
NEWER_RUNS=$(gh run list --workflow=update-ai.yaml --json databaseId,createdAt --limit 10 \
  -q ".[] | select(.createdAt > \"$WORKFLOW_START_TIME\" and .databaseId != $GITHUB_RUN_ID)")

if [ -n "$NEWER_RUNS" ]; then
  # Found a newer run. This current run is obsolete and should stop.
  echo "Found newer workflow run(s) started after $WORKFLOW_START_TIME. Stopping this run." >&2
  echo "changes=false"
else
  # No newer runs found. This run should proceed.
  echo "No newer workflow runs found. Proceeding." >&2
  echo "changes=true"
fi
