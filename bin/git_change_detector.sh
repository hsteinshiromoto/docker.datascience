#!/usr/bin/env bash

# Set the files to check for changes
FILES_TO_CHECK=(
  "pyproject.toml"
  "debian-requirements.txt"
  "Dockerfile"
  "Dockerfile.base"
  "Dockerfile.dask"
  "Dockerfile.keras"
  "Dockerfile.pycaret"
  "Dockerfile.pymc"
  "Dockerfile.sklearn"
)

# Check if there are any changes in the specified files
if git diff --quiet --exit-code HEAD -- "${FILES_TO_CHECK[@]}"; then
  echo "No changes detected."
  exit 0
else
  echo "Changes detected!"
  exit 1
fi