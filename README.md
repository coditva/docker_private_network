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

```bash
./execute server  # create and run server
./execute client  # create and run client
./execute clean   # remove server and client containers
./execute distclean  # remove server and client images and docker network
```

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


## Cleanup
```bash
sudo docker stop server      # stop the container
sudo docker rm server        # remove the container
sudo docker rm client        # remove the container
sudo docker image rm server  # remove the image
sudo docker image rm client  # remove the image
sudo docker network rm my-network   # remove the network
```
