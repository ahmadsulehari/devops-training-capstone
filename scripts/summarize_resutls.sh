#!/usr/bin/env bash

log_file_path=$WORKING_DIR/logs/$1

if [[ -z $1 ]]; then
    echo "Usage: $0 <log_file_name>"
    exit 1
fi

if [[ -s $log_file_path ]]; then
    total_tests=$(grep -o 'collected [0-9]* items' "$log_file_path" | awk '{print $2}')
    passed_tests=$(grep -o '[0-9]* passed' "$log_file_path" | awk '{print $1}')
    failed_tests=$(grep -o '[0-9]* failed' "$log_file_path" | awk '{print $1}')
    skipped_tests=$(grep -o '[0-9]* skipped' "$log_file_path" | awk '{print $1}')
    total_time=$(grep -o 'in [0-9.shm]*' "$log_file_path" | awk '{print $2}')

    echo "Test Summary:"
    echo "Total Tests: ${total_tests:-0}"
    echo "Passed Tests: ${passed_tests:-0}"
    echo "Failed Tests: ${failed_tests:-0}"
    echo "Skipped Tests: ${skipped_tests:-0}"
    echo "Total time taken: ${total_time:-0s}"
    echo "Detailed results can be found in the log file: $1"
else
    echo "Log file not found or is empty."
fi