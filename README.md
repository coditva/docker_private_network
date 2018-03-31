# Private Docker Network Example
This is an example of a private network on multiple machines which can only be accessed inside a docker container.

## What is what
- `server/Dockerfile` - create an Apache HTTP server on the local network.
- `client/Dockerfile` - create clients to connect to the Apache server.
- `server/public-html/*` - html pages to be served

## How to

#### Use the script to do everything for you:

```bash
./execute server  # create and run server
./execute client  # create and run client
./execute clean   # remove server and client containers
./execute distclean  # remove server and client images and docker network
```

#### Or, execute individual commands as follows

Build the server image from the `Dockerfile`:

    sudo docker build --tag "server" server

Start the server on the `localhost`:

    sudo docker run -d --name "server" server

Create a network between docker containers and add server to the network

    sudo docker network create "my-network"
    sudo docker network connect "my-network" server

Build the client image from the `Dockerfile`:

    sudo docker build --tag "client" client

Start the client with and get tty access:

    sudo docker run -it --network my-network --name client client

Test that you can connect to the server:

    wget server


## Cleanup
```bash
sudo docker stop server      # stop the container
sudo docker rm server        # remove the container
sudo docker rm client        # remove the container
sudo docker image rm server  # remove the image
sudo docker image rm client  # remove the image
sudo docker network rm my-network   # remove the network
```
