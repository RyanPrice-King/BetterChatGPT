#!/bin/bash

is_dir_empty() {
    local dir=$1

    # Check if the persistent volume has been configured
    if [ ! -d "$dir" ]; then
        echo "Directory does not exist."
        return 1
    fi

    # Count the number of files and directories in the specified directory
    local count=$(find "$dir" -mindepth 1 -maxdepth 1 | wc -l)

    # Check if count is zero
    if [ "$count" -eq 0 ]; then
        echo "Directory is empty."
        return 0
    else
        echo "Directory is not empty."
        return 1
    fi
}


if is_dir_empty /ChatGPT-Web; then
    git clone https://github.com/RyanPrice-King/BetterChatGPT.git /ChatGPT-Web
    cd /ChatGPT-Web
    npm install

    while true; do

      # Run npm audit to check for vulnerabilities
      npm audit
      audit_status=$?

      # Check if npm audit returned 0 (no vulnerabilities)
      if [ $audit_status -eq 0 ]; then
        echo "No audit fix is required. Exiting loop."
        break
      else
        echo "Audit fix is required. Running 'npm audit fix'."
        npm audit fix --force
      fi

    done
    npm update
fi

yarn --cwd /ChatGPT-Web dev --host
