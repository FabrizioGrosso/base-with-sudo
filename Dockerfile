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

WORKDIR /home

## --------------------------- ##

# DO NOT EDIT USER VALUE
USER jovyan
