FROM ucsb/rstudio-base:latest

MAINTAINER LSIT Systems <lsitops@lsit.ucsb.edu>

USER root

ENV TZ America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && \
    apt install -yq nano wget libgeos-dev libproj-dev libtbb-dev && \
    apt clean

RUN pip install palettable twarc textblob plotnine openpyxl 'transformers[torch]' ipywidgets

RUN mamba install -y --freeze-installed \
    gdal \
    geos \
    libgdal \
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
    r-sf \
    r-stringr \
    r-syuzhet \
    r-terra \
    r-tidytext \
    r-tidyverse \
    r-wordcloud2 \
    scikit-learn \
    seaborn \
    spacy \
    xgboost && \
    conda clean --all && \
    /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

# Install some from CRAN to avoid downgrades
RUN R -e "install.packages(c('emoji', 'tidyterra'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

# Install the latest version of quarto from the website. 
RUN wget https://quarto.org/download/latest/quarto-linux-amd64.deb && \
    dpkg -i quarto-linux-amd64.deb && \
    rm quarto-linux-amd64.deb

RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER
