FROM ucsb/jupyter-base:latest

MAINTAINER LSIT Systems <lsitops@lsit.ucsb.edu>

USER root

RUN pip install twarc

USER $NB_USER

