#!/usr/bin/env bash
set -euo pipefail

TIMESTAMP=$(date +"%F_%H%M%S")
LOG_FILE="$WORKING_DIR/logs/pytest_${TIMESTAMP}.log"
ERR_FILE="$WORKING_DIR/logs/error_${TIMESTAMP}.log"

pretty_print() {
	echo "=============================="
	echo "$1"
	echo "=============================="
}

test_failure () {
	pretty_print "pytest script exited with failure. Check $ERR_FILE or $LOG_FILE for details."
	exit 1
}

trap test_failure ERR

cd $WORKING_DIR/app

pretty_print "Changed directory to $PWD"

pretty_print "Running the tests"

python -m pytest -v 1> $LOG_FILE 2> $ERR_FILE

pretty_print "tests completed. Check $LOG_FILE for details."
