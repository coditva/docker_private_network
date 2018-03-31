#!/bin/bash

# config variables
mynetwork="my-network"

if [[ $1 == "server" ]]; then

    if [[ "$( sudo docker network ls | grep $mynetwork )" == "" ]]; then
        # create network
        sudo docker network create "$mynetwork"
    fi

    if [[ "$(sudo docker ps -a | grep server)" == "" ]]; then

        # create server image
        sudo docker build --tag "server" server

        # create and run server container
        sudo docker run -d --name "server" server

        # add server to the network
        sudo docker network connect "$mynetwork" server
    fi

elif [[ $1 == "client" ]]; then

    if [[ "$(sudo docker ps -a | grep client)" == "" ]]; then

        # create client image
        sudo docker build --tag "client" client

        # create and run the client
        sudo docker run -it --network $mynetwork --name client client
    fi

elif [[ $1 == "clean" ]]; then

    # remove server
    if [[ "$(sudo docker ps -a | grep server)" != "" ]]; then
        sudo docker rm -f server
    fi

    # remove client
    if [[ "$(sudo docker ps -a | grep client)" != "" ]]; then
        sudo docker rm client
    fi

elif [[ $1 == "distclean" ]]; then

    # remove server
    sudo docker rm -f server
    sudo docker image rm server

    # remove client
    sudo docker rm client
    sudo docker image rm client

    # remove network
    sudo docker network rm $mynetwork

else
    echo "Usage: $0 server|client|clean|distclean"
fi
