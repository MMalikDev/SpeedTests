#!/bin/bash

# set -e

source ./scripts/reset.sh
# ---------------------------------------------------------------------- #
# Define Docker Variables
# ---------------------------------------------------------------------- #
declare -a images=(
    code_py
    code_js
    code_rust
    code_c
    code_cpp
)
declare -a volumes=(
    #
)
declare -a bindings=(
    #
)

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    # Shut down all containers
    docker compose down
    
    # Clean up
    run folders remove_folders  ${bindings[*]}
    run volumes remove_volumes  ${volumes[*]}
    run images  remove_images   ${images[*]}
    prune_docker
}

main $@
