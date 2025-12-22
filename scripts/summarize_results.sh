#!/usr/bin/env bash



if [[ -z $1 ]]; then
    echo "No arg provided trying to locate the first log file in logs/ directory."
    log_file_name=$(find logs/ -type f -name pytest_*.log | head -n 1 | awk -F '/' '{print $2}')
    if [[ -z $log_file_name ]]; then
        echo "No log file found in logs/ directory."
        echo "Usage: $0 <log_file_name>"
        exit 1
    else
        echo "Using log file: $log_file_name"
    fi
else
    log_file_name=$1
fi

log_file_path=$WORKING_DIR/logs/$log_file_name
echo "Reading log file: $log_file_path"

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