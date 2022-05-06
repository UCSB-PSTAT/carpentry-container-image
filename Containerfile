FROM ucsb/jupyter-base:latest

MAINTAINER LSIT Systems <lsitops@lsit.ucsb.edu>

USER root

RUN apt update -qq && apt install -yq nano && apt-get clean

RUN pip install palettable twarc textblob

USER $NB_USER

