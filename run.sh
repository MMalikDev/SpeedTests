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
    docker-compose logs --follow 2>&1 \
    | awk '/Elapsed/{print "|"$0"|" >> "'$dir/RAW.md'" }'
    sed -i 's/Elapsed://g' $dir/RAW.md
    sed -i 's/  / /g' $dir/RAW.md
    
    cp $dir/HEADERS.md $dir/Result.md
    sort -hk 3 $dir/RAW.md >> $dir/Result.md
}

# ---------------------------------------------------------------------- #
# OPTIONS
# ---------------------------------------------------------------------- #
run_devcontainer(){
    run_python_dev
    exit 0
}
run_locally(){
    run_python
    exit 0
}
run_docker(){
    reload_services ${reloads[*]}
    handle_errors $?
    
    save_result
    
    docker image prune -f
    follow_logs ${logs[*]}
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
    while getopts "dlch" OPTION; do
        case $OPTION in
            d) run_devcontainer ;;
            l) run_locally      ;;
            c) run_docker       ;;
            h) display_usage    ;;
            ?) display_usage    ;;
        esac
    done
    shift $((OPTIND -1))
    use_env_file
}

main $@
