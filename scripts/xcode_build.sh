#!/bin/bash

mkdir $DEPLOY_DIRECTORY

set -o pipefail && 
  env NSUnbufferedIO=YES \
  xcodebuild \
    -workspace "$XCODEBUILD_WORKSPACE" \
    -scheme "$XCODEBUILD_SCHEME" \
    -destination "$1" \
    -resultBundlePath "./deploy/Test.xcresult" \
    -enableCodeCoverage YES \
    clean test \
  | tee "./deploy/xcodebuild.log" \
  | xcpretty
  
# Bitrise also calls the following:

#     COMPILER_INDEX_STORE_ENABLE=NO \
#     GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
#     GCC_GENERATE_TEST_COVERAGE_FILES=YES \
#     xcpretty -color --report html --output output/xcode-test-results-UtilityBelt.html
