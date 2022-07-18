FROM ucsb/rstudio-base:latest

MAINTAINER LSIT Systems <lsitops@lsit.ucsb.edu>

USER root

RUN apt update -qq && apt install -yq nano && apt-get clean

RUN pip install palettable twarc textblob

RUN mamba install gdal geos xgboost r-rastervis r-remotes r-sf r-here r-proj4

USER $NB_USER
