# Dockerfile

# Script       : VidPhisher
# Author       : KasRoudra
# Github       : https://github.com/KasRoudra
# Messenger    : https://m.me/KasRoudra
# Email        : kasroudrakrd@gmail.com
# Date         : 05-06-2022
# Main Language: Shell

# Download and import main images

# Operating system
FROM debian:latest

# Author info
LABEL MAINTAINER="https://github.com/KasRoudra/VidPhisher"

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

## "sudo docker build . -t kasroudra/vidphisher:latest", "sudo docker run --rm -it kasroudra/vidphisher:latest"

## "sudo docker pull kasroudra/vidphisher", "sudo docker run --rm -it kasroudra/vidphisher"
