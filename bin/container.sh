#!/usr/bin/env bash

# ---
# Functions
# ---

# Documentation
display_help() {
    echo "Usage: [variable=value] $0" >&2
    echo
    echo "   -d, --deploy               deploy container"
    echo "   -h, --help                 display help"
    echo "   -r, --run_container        launch container"
    echo
    # echo some stuff here for the -a or --add-options
    exit 1
}

# Get container id
get_container_id() {
    echo "Getting container id for image ${DOCKER_IMAGE_TAG} ..."

    CONTAINER_ID=$(docker ps | grep "${DOCKER_IMAGE_TAG}" | awk '{ print $1}')

    if [[ -z "${CONTAINER_ID}" ]]; then
        echo "No container id found"

    else
        echo "Container id: ${bold}${CONTAINER_ID}${normal}"

    fi
}


make_variables() {
    # Get Variables From make_variables.sh
    # IFS='|| ' read -r -a array <<< $(./make_variables.sh)

    set -a # automatically export all variables
    source .env
    set +a

    PROJECT_ROOT=$(pwd)

    DOCKER_IMAGE=hsteinshiromoto/datascience
    DOCKER_TAG=${DOCKER_TAG:-latest}
    DOCKER_IMAGE_TAG=${DOCKER_IMAGE}:${DOCKER_TAG}

    RED="\033[1;31m"
    BLUE='\033[1;34m'
    GREEN='\033[1;32m'
    NC='\033[0m'
    bold=$(tput bold)
    normal=$(tput sgr0)
}

run_container() {

    make_variables
    get_container_id

    if [[ -z "${CONTAINER_ID}" ]]; then
        echo "Creating Container from image ${DOCKER_IMAGE_TAG} ..."

        docker run -d -P -v $(pwd):/home/docker_user -e uid=$UID -t ${DOCKER_IMAGE_TAG} $1 >/dev/null >&1

        sleep 2
        get_container_id

    else
	    echo "Container already running"
	fi

    sleep 5

    JUPYTER_PORT=$(docker ps -f "ancestor=${DOCKER_IMAGE_TAG}" | grep -o "0.0.0.0:[0-9]*->8888" | cut -d ":" -f 2 | head -n 1)

    echo -e "Port mapping: ${JUPYTER_PORT}"

    JUPYTER_TOKEN=$(docker exec -i ${CONTAINER_ID} sh -c "jupyter lab list" | tac | grep -o "token=[a-z0-9]*" | sed -n 1p | cut -d "=" -f 2)
    echo -e "Jupyter token: ${GREEN}${JUPYTER_TOKEN}${NC}"

    JUPYTER_ADDRESS=$(docker ps | grep ${DOCKER_IMAGE_TAG} | grep -o "0.0.0.0:[0-9]*")
    echo -e "Jupyter Address: ${BLUE}http://${JUPYTER_ADDRESS}/?token=${JUPYTER_TOKEN}${NC}"
}

# Available options
while :
do
    case "$1" in
        -e | --enter)
            enter  # Call your function
            exit 0
            ;;

        -h | --help)
            display_help  # Call your function
            exit 0
            ;;

        -r | --run) 
            run_container  # Call your function
            break
            ;;

        -s | --ssh)
            run_ssh_container  # Call your function
            break
            ;;

        "")
            display_help  # Call your function
            break
            ;;

        --) # End of all options
            shift
            break
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            ## or call function display_help
            exit 1
            ;;

      *)  # No more options
            break
            ;;
    esac
done



