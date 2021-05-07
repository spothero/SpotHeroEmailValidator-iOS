#!/bin/bash

# Verify the script has been executed
echo "Running onboarding script..."

ONBOARD_DOCUMENTATION="https://github.com/spothero/Shared-iOS/main/ONBOARDING.md"

# 1 - Install and Verify Build Tools

# ensure that homebrew is installed
# TODO: Add check for version of homebrew
command -v brew >/dev/null 2>&1 || { echo >&2 "Homebrew is not installed."; exit 1; }

# ensure that mint is installed
# TODO: Add check for version of mint
command -v mint >/dev/null 2>&1 || { echo >&2 "Mint is not installed."; exit 1; }

# TODO: Add items from SpotHero-iOS (bundler, ruby, rvm, fastlane, etc.)

# 2 - Install Git Hooks

# if there are any scripts in the scripts/git-hooks folder, 
# copy them into the .git/hooks folder which is not source controlled
# This will replace any existing files
cp -R -a scripts/git-hooks/. .git/hooks

# Verify the script has completed
echo "Onboarding complete."
