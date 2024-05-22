FROM ucsb/rstudio-base:latest

MAINTAINER LSIT Systems <lsitops@lsit.ucsb.edu>

USER root

RUN apt update -qq && apt install -yq nano wget && apt-get clean

RUN pip install palettable twarc textblob plotnine openpyxl

RUN mamba install gdal \
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
    mamba clean --all

# ORCS package isn't available in Conda/Mamba
RUN R -e "install.packages(c('Orcs'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

# Install pre-release version of quarto for the CLI
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.467/quarto-1.4.467-linux-amd64.deb && \
    dpkg -i quarto-1.4.467-linux-amd64.deb && \
    rm quarto-1.4.467-linux-amd64.deb

RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER
