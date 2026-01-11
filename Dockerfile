FROM quay.io/uninuvola/base:main

# DO NOT EDIT USER VALUE
USER root

## -- ADD YOUR CODE HERE !! -- ##

# INSTALL OLLAMA
RUN curl -fsSL https://ollama.com/install.sh | sh
RUN pip install ollama

# RUN OLLAMA SERVE AND PULL MODELS
COPY ./run-ollama.sh /tmp/run-ollama.sh

WORKDIR /tmp

RUN chmod +x run-ollama.sh \
    && ./run-ollama.sh

EXPOSE 11434

RUN pip install langchain_ollama

# Install required packages
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https \
    software-properties-common

# Add Docker’s official GPG key
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

# Install Docker Engine
RUN apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

RUN apt-get install -y uidmap
# Start Docker daemon when container launches
CMD ["sh", "-c", "dockerd & tail -f /dev/null"]
# RUN dockerd
#    dockerd-rootless-setuptool.sh install

# Install nvidia-container-toolkit
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
RUN apt-get update && apt-get install -y --no-install-recommends \
   curl \
   gnupg2
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
RUN apt-get update
RUN export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.18.1-1
RUN apt-get install -y \
      nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}


WORKDIR /home

## --------------------------- ##

# DO NOT EDIT USER VALUE
USER jovyan
