FROM ucsb/rstudio-base:latest

MAINTAINER LSIT Systems <lsitops@lsit.ucsb.edu>

USER root

ENV TZ America/Los_Angeles
RUN apt update && \
    apt install -yq nano wget && \
    apt clean && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN pip install palettable twarc textblob plotnine openpyxl

RUN mamba install -y \
    gdal \
    geos \
    r-BayesFactor \
    r-bookdown \
    r-cowplot \
    r-curl \
    r::r-emoji \
    r-gapminder \
    r-geojsonsf \
    r-ggpubr \
    r-googledrive \
    r-here \
    r-hexbin \
    r-palmerpenguins \
    r-patchwork \
    r-proj4 \
    r-rastervis \
    r-rcolorbrewer \
    r-remotes \
    r-rgdal \
    r-rsqlite \
    r-rticles \
    r-sf \
    r-terra \
    r::r-tidyterra \
    scikit-learn \
    xgboost && \
    mamba clean --all && \
    /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

# ORCS package isn't available in Conda/Mamba
RUN R -e "install.packages(c('Orcs'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

# Install the latest version of quarto from the website. 
RUN wget https://quarto.org/download/latest/quarto-linux-amd64.deb && \
    dpkg -i quarto-linux-amd64.deb && \
    rm quarto-linux-amd64.deb

RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER
