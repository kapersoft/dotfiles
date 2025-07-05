#!/bin/zsh

# Get the latest tag matching vX.Y pattern
latest_tag=$(git tag -l "v*.*" | sort -V | tail -n 1)

if [[ -z "$latest_tag" ]]; then
  # No tags found, start with v1.0
  new_major=1
  new_minor=0
else
  # Extract major and minor versions
  # Remove 'v' prefix
  version_number=${latest_tag#v}
  IFS='.' read -r current_major current_minor <<< "$version_number"

  # Increment major version and reset minor
  new_major=$((current_major + 1))
  new_minor=0
fi

new_tag="v${new_major}.${new_minor}"
message="$1"

echo "Creating new tag: $new_tag"
if [[ -n "$message" ]]; then
  git tag -a "$new_tag" -m "$message"
else
  git tag "$new_tag"
fi
git push origin "$new_tag"

echo "Tag $new_tag created and pushed successfully."
