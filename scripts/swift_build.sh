#!/bin/bash

mkdir $DEPLOY_DIRECTORY

swift test -c debug --enable-test-discovery --enable-code-coverage
cp $(swift test --show-codecov-path) deploy/codecov.json
