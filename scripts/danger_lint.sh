#!/bin/bash

# Check if mint is installed
if [ -x "$(command -v mint)" ]; then
  # Set Danger's SwiftLint version to match our Mintfile
  export SWIFTLINT_VERSION=$(mint run swiftlint version)
  # Set Danger's SwiftFormat version and binary to match our Mintfile
  export SWIFTFORMAT_VERSION=$(mint run swiftformat --version)
  export SWIFTFORMAT_PATH=$(mint which swiftformat)
fi

# Run Danger
bundle exec danger --dangerfile=Dangerfile-Lint --fail-on-errors=true --remove-previous-comments --new-comment --verbose
