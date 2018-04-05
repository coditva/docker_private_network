#!/bin/sh

# config variables
mynetwork="my-network"

if [[ $1 == "server" ]]; then

    if [[ "$(docker ps -a | grep server)" == "" ]]; then

        # create server image
        docker build --tag "server" server

        # create and run server container
        docker run -d --network $mynetwork --name "server" server
    fi

elif [[ $1 == "client" ]]; then

    if [[ "$(docker ps -a | grep client)" == "" ]]; then

        # create client image
        docker build --tag "client" client

        # create and run the client
        docker run -it --network $mynetwork --name client client
    fi

elif [[ $1 == "clean" ]]; then

    # remove server
    if [[ "$(docker ps -a | grep server)" != "" ]]; then
        docker rm -f server
    fi

    # remove client
    if [[ "$(docker ps -a | grep client)" != "" ]]; then
        docker rm client
    fi

elif [[ $1 == "distclean" ]]; then

    # remove server
    docker rm -f server
    docker image rm server

    # remove client
    docker rm client
    docker image rm client

else
    echo "Usage: $0 server|client|clean|distclean"
fi
