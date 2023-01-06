FROM ucsb/rstudio-base:latest

MAINTAINER LSIT Systems <lsitops@lsit.ucsb.edu>

USER root

RUN apt update -qq && apt install -yq nano && apt-get clean

RUN pip install palettable twarc textblob plotnine

RUN mamba install gdal geos xgboost r-rastervis r-remotes r-rgdal r-sf r-here r-proj4 r-rticles  r-palmerpenguins r-hexbin r-patchwork r-bookdown r-BayesFactor r-here r-rsqlite r-quarto r-gapminder

USER $NB_USER
