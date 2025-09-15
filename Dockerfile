FROM quay.io/uninuvola/base:main

# DO NOT EDIT USER VALUE
USER root

## -- ADD YOUR CODE HERE !! -- ##

RUN curl -fsSL https://ollama.com/install.sh | sh

## --------------------------- ##

# DO NOT EDIT USER VALUE
USER jovyan
