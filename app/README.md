# Instruction

- setup env variable `WORKING_DIR` with path of directory in side which app/ directory is placed.
- To setup your python env: run script `source venv.sh`
- After the env is activated by the venv script you can run your application by running script `bash run_app.sh`
- Goto **localhost:8000** to test if the api is running
- Open another terminal and run the `source venv.sh` again to activate the python env
- To start tests run script `bash run_tests.sh`
- After tests are completed. Run script `bash summarize_results.sh pytest_2025-12-22_143254.log`
- only pass the log file name

## NOTE
    - Running the fastapi app is not necessary for execution of run_tests.sh script.
    - It can test internally checking the code.