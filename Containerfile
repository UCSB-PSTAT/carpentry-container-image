FROM ucsb/rstudio-base:latest

MAINTAINER LSIT Systems <lsitops@lsit.ucsb.edu>

USER root

RUN apt update -qq && apt install -yq nano wget && apt-get clean

RUN pip install palettable twarc textblob plotnine openpyxl

RUN mamba install gdal geos xgboost r-rastervis r-remotes r-rgdal r-sf r-here r-proj4 r-rticles  r-palmerpenguins r-hexbin r-patchwork r-bookdown r-BayesFactor r-here r-rsqlite r-gapminder scikit-learn

# Install pre-release version of quarto for the CLI
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.467/quarto-1.4.467-linux-amd64.deb && \
    dpkg -i quarto-1.4.467-linux-amd64.deb && \
    rm quarto-1.4.467-linux-amd64.deb

USER $NB_USER
