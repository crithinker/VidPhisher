# Dockerfile

# Script       : VidPhisher
# Author       : Augustine Tilo
# Github       : https://github.com/crithinker
# Email        : lifeofacriticalthinker@gmail.com
# Date         : 05-06-2022
# Main Language: Shell

# Download and import main images

# Operating system
FROM debian:latest

# Author info
LABEL MAINTAINER="https://github.com/crithinker/VidPhisher"

# Working directory
WORKDIR /VidPhisher/
# Add files 
ADD . /VidPhisher

# Installing other packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install curl unzip wget -y
RUN apt-get install --no-install-recommends php -y
RUN apt-get clean

# Main command
CMD ["./vp.sh", "--no-update"]

## Wanna run it own? Try following commnads:

## "sudo docker build . -t crithinker/vidphisher:latest", "sudo docker run --rm -it crithinker/vidphisher:latest"

## "sudo docker pull crithinker/vidphisher", "sudo docker run --rm -it crithinker/vidphisher"
