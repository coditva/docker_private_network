# Private Docker Network Example
This is an example of a private network on multiple machines which can only be accessed inside a docker container.

## What is what
- A server docker file to create an Apache HTTP server on the local network.
- A client docker file to create clients to connect to the Apache server.

## How to
Build the server image from the `Dockerfile`

    sudo docker build --tag "server" server

Start the server on the `localhost`:

    sudo docker run -dp 80:80 --name "server1" server

Visit `http://localhost` on your browser to see the website.


## Cleanup
```bash
sudo docker stop server1     # stop the container
sudo docker rm server1       # remove the container
sudo docker image rm server  # remove the image
```
