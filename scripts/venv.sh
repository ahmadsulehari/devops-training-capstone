#!/usr/bin/env bash
set -euo pipefail

vir_env_name="app_venv"
TIMESTAMP=$(date +"%F_%H%M%S")


pretty_print() {
	echo "=============================="
	echo "$1"
	echo "=============================="
}

failure () {
	pretty_print "Env setup script failed. Check $ERR_FILE or $LOG_FILE for details."
	exit 1
}

trap failure ERR

pretty_print "Make sure you have set WORKING_DIR env variable set in your bashrc or bash_profile \n should be the parent directory of your app project directory"

if [[ -z "$WORKING_DIR" ]]; then
	echo "[ERROR] WORKING_DIR variable is not set. Please set it to the project root directory." >> $ERR_FILE
	exit 1
fi

pretty_print "Changing directory to WORKING_DIR: $WORKING_DIR"
cd $WORKING_DIR
pretty_print "Current directory is now: $PWD"

project_dir="$WORKING_DIR/app"

if [[ ! -d $WORKING_DIR/logs ]]; then
	mkdir $WORKING_DIR/logs
fi

LOG_FILE="$WORKING_DIR/logs/success_${TIMESTAMP}.log"
ERR_FILE="$WORKING_DIR/logs/error_${TIMESTAMP}.log"

pretty_print "looking for an existing virtual enviornment with name: $vir_env_name"
if [[ -d $project_dir/$vir_env_name ]];then
	source "$project_dir/$vir_env_name/bin/activate"
	pretty_print "virtual enviornment found and activated"
else
	pretty_print "unable to find a virtual enviornment \n creating a new virtual env in $project_dir/"
	python3 -m venv $project_dir/$vir_env_name 1>> $LOG_FILE 2>> $ERR_FILE
	source "$project_dir/$vir_env_name/bin/activate"
	pretty_print "virtual enviornment created and activated"
fi

pretty_print "installing requiremnts"
if [[ -f $project_dir/requirements.txt ]]; then
	pretty_print "installing packages"
	cat $project_dir/requirements.txt
	pip install -r $project_dir/requirements.txt 1>> $LOG_FILE 2>> $ERR_FILE
    pretty_print "Successfully installed all packages"
else
	echo "[ERROR] requirements file not present" >> $ERR_FILE
	exit 1
fi

pretty_print "Setup completed successfully!"