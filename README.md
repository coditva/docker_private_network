# Private Docker Network Example
This is an example of a private network on multiple machines which can only be accessed inside a docker container.

## What is what
- `server/Dockerfile` - create an Apache HTTP server on the local network.
- `client/Dockerfile` - create clients to connect to the Apache server.
- `server/public-html/*` - html pages to be served

## How to

### Create a swarm and add an overlay network

On the server machine host, initialize the cluster:

    sudo docker swarm init --advertise-addr 192.168.99.101
    # you can choose any other IP address if you like

On the remote client host, join the swarm:

    sudo docker swarm join --token <token> 192.168.99.101:2377
    # token is the one you recieved from swarm init
    # change IP if you chose your own IP in swarm init

Create an `overlay` network for the swarm on the *server host*:

    sudo docker network create --driver overlay --attachable my-network


### Create and run server and clients:

#### Use the script to do everything for you:

    sudo ./execute server  # create and run server
    sudo ./execute client  # create and run client
    sudo ./execute clean   # remove server and client containers
    sudo ./execute distclean  # remove docker images

#### Or, execute individual commands as follows

Build the server image from the `Dockerfile` on the server host:

    sudo docker build --tag "server" server

Start the server on the `localhost`:

    sudo docker run -d --name "server" --network my-network server

Build the client image from the `Dockerfile`:

    sudo docker build --tag "client" client

Start the client with and get tty access:

    sudo docker run -it --network my-network --name client client
    # if you're using docker-machine for VM, use option "-d"

Test that you can connect to the server:

    wget server


## If you want to test this on a single host, use `docker-machine`:

Create two host machines. We will use `host0` for server and `host1` for client:

    docker-machine create --driver virtualbox host0
    docker-machine create --driver virtualbox host1

To execute any command in the virtual machines, use this command:

    docker-machine ssh <machine_name> <command>
    # e.g. docker-machine ssh host1 "wget server"

Copy the script, Dockerfiles and web-pages into the virtual machines:

    docker-machine scp -r . host0:/home/docker
    docker-machine scp -r client execute.sh host1:/home/docker

**Follow the steps in [How to](#how-to) to create a cluster and create/run
docker containers.** Remember to change all commands like:

    sudo docker build --tag server server

To:

    docker-machine ssh host0 "docker build --tag server server"


## Cleanup

    sudo docker rm -f server     # remove the container
    sudo docker rm -f client     # remove the container
    sudo docker image rm server  # remove the image
    sudo docker image rm client  # remove the image
    sudo docker network rm my-network   # remove the network

