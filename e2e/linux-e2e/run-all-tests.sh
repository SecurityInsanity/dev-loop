#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "$SCRIPT_DIR"

DL_COMMAND="${DL_COMMAND:-"dl"}"
if [[ "x$DL_COMMAND" == "x" ]]; then
  echo "FAILED to find DL Command!"
fi

rm -rf ./build/
$DL_COMMAND exec exec-pipeline

# Run inside another directory.
if [[ "$DL_COMMAND" =~ "../" ]]; then
  (cd tasks && ../$DL_COMMAND exec exec-pipeline)
else
  (cd tasks && $DL_COMMAND exec exec-pipeline)
fi

$DL_COMMAND run run

data=$(< ./build/run/state)

if [[ "$data" != "1
1
2
2
3
3" ]]; then
  echo "Data: [$data] from run is not: [1
1
2
2
3
3]"
  exit 3
fi
