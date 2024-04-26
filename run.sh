#!/bin/bash

# set -e

source ./scripts/run.sh
# ---------------------------------------------------------------------- #
# Define Docker Variables
# ---------------------------------------------------------------------- #
declare -a reloads=(
    # rust
    # cbase
    # cpp
    # javascript
    # python
)

declare -a logs=(
    rust
    cbase
    cpp
    javascript
    python
)

# ---------------------------------------------------------------------- #
# Utils Functions
# ---------------------------------------------------------------------- #
save_result(){
    local dir=./data
    
    docker compose logs -f | grep Elapsed > "$dir/RAW.md"
    
    sed -i 's/Elapsed://g' "$dir/RAW.md"
    sed -i 's/cpp/c\+\+/g' "$dir/RAW.md"
    sed -i 's/cbase/c/g' "$dir/RAW.md"
    sed -i 's/\s\+/ /g' "$dir/RAW.md"
    sort -o "$dir/RAW.md" -hk 3 "$dir/RAW.md"
    
    awk -F "|" '{printf "| %-12s | %-10s | %-24s |\n", $2, $3, $4; }' "$dir/HEADERS.md" >  "$dir/Result.md"
    awk -F "|" '{printf "| %-12s | %-10s | %-24s |\n", $1, $2, $3; }' "$dir/RAW.md" >>  "$dir/Result.md"
    
    rm "$dir/RAW.md"
    cat "$dir/Result.md"
}

# ---------------------------------------------------------------------- #
# OPTIONS
# ---------------------------------------------------------------------- #
run_devcontainer(){
    run_rust_dev
    run_python_dev
    run_javascript_dev
    exit 0
}
run_locally(){
    run_rust
    run_python
    run_javascript
    exit 0
}
run_docker(){
    reload_services ${reloads[*]}
    handle_errors $?
    
    docker image prune -f
    handle_errors $?
    
    follow_logs ${logs[*]}
    save_result
    
    exit 0
}

use_env_file(){
    [[ $(get_bool DEVCONTAINER) == "true" ]] && run_devcontainer
    [[ $(get_bool RUN_LOCAL) == "true" ]] && run_locally
    run_docker
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "dlcsh" OPTION; do
        case $OPTION in
            d) run_devcontainer ;;
            l) run_locally      ;;
            c) run_docker       ;;
            s) save_result      ;;
            h) display_usage    ;;
            ?) display_usage    ;;
        esac
    done
    shift $((OPTIND -1))
    
    use_env_file
}

main $@
