#!/bin/bash

if [[ $1 == "server" ]]; then

    # create server image
    sudo docker build --tag "server" server

    # create and run server container
    sudo docker run -d --name "server" server

    # create network and add server to it
    sudo docker network create "my-network"
    sudo docker network connect "my-network" server


elif [[ $1 == "client" ]]; then

    # create client image
    sudo docker build --tag "client" client

    # create and run the client
    sudo docker run -it --network my-network --name client client

elif [[ $1 == "clean" ]]; then
    
    # remove server
    sudo docker stop server
    sudo docker rm server

    # remove client
    sudo docker rm client

elif [[ $1 == "distclean" ]]; then

    # remove server
    sudo docker stop server
    sudo docker rm server
    sudo docker image rm server

    # remove client
    sudo docker rm client
    sudo docker image rm client

    # remove network
    sudo docker network rm my-network

else
    echo "Usage: $0 server|client|clean|distclean"
fi
