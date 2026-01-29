FROM ucsb/rstudio-base:latest

MAINTAINER LSIT Systems <lsitops@lsit.ucsb.edu>

USER root

ENV TZ America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && \
    apt install -yq nano wget libgeos-dev libproj-dev libtbb-dev && \
    apt clean

RUN pip install palettable twarc textblob plotnine openpyxl 'transformers[torch]' ipywidgets tensorflow-cpu

RUN mamba update --all && mamba install -y --freeze-installed \
    gdal \
    geos \
    keras \
    libgdal \
    pydot \
    r-bayesfactor \
    r-bookdown \
    r-cowplot \
    r-gapminder \
    r-ggwordcloud \
    r-geojsonsf \
    r-ggpubr \
    r-googledrive \
    r-here \
    r-hexbin \
    r-leaflet \
    r-lwgeom \
    r-palmerpenguins \
    r-patchwork \
    r-plyr \
    r-proj4 \
    r-pscl \
    r-rastervis \
    r-rcolorbrewer \
    r-remotes \
    r-reshape \
    r-rsqlite \
    r-rticles \
    r-sentimentr \
    r-stringr \
    r-syuzhet \
    r-terra \
    r-tidytext \
    r-tidyverse \
    r-wordcloud2 \
    scikit-learn \
    seaborn \
    selenium \
    spacy \
    webdriver-manager \
    xgboost && \
    conda clean --all && \
    /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

# Install some from CRAN to avoid downgrades
RUN R -e "install.packages(c('emoji', 'osmdata', 'tidyterra', 'sf', 'ratdat'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

# Install the latest version of quarto from the website. 
RUN wget https://quarto.org/download/latest/quarto-linux-amd64.deb && \
    dpkg -i quarto-linux-amd64.deb && \
    rm quarto-linux-amd64.deb

RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER
