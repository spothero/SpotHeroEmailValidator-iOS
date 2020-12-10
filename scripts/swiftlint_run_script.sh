#!/bin/sh

# Only run linting scripts locally, Danger will handle linting on CI
if ! [ -z "$CI" ]; then
  echo "The SwiftLint Run Script does not run on CI. Don't worry, Danger will handle it! (swiftlint_run_script)"
  exit 0
fi

# The workspace directory should be the git repo root
workspace_directory=$(git rev-parse --show-toplevel)

# Allow passing in a file path for .swiftlint.yml, otherwise it looks in the workspace directory
if [ -z "$0" ]; then
  swiftlint_yml_path=$0
else
  swiftlint_yml_path="${workspace_directory}/.swiftlint.yml"
fi

# Set the command
command="mint run swiftlint --config ${swiftlint_yml_path}"

# Call the command!
eval $command
