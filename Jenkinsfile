pipeline {
    agent none
    triggers {
        upstream(upstreamProjects: 'UCSB-PSTAT GitHub/base-rstudio/main', threshold: hudson.model.Result.SUCCESS)
    }
    environment {
        IMAGE_NAME = 'carpentry-collab'
    }
    stages {
        stage('Build Test Deploy') {
            agent {
                kubernetes {
                    cloud 'rke-test'
                    inheritFrom 'podman'
                }
            }
            stages{
                stage('Build') {
                    steps {
                        echo "NODE_NAME = ${env.NODE_NAME}"
                        container('podman') {
                            sh 'podman build -t $IMAGE_NAME --pull --force-rm --no-cache .'
                        }
                     }
                    post {
                        unsuccessful {
                            container('podman') {
                                sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                            }
                        }
                    }
                }
                stage('Test') {
                    steps {
                        container('podman') {
                            sh 'podman run -it --rm localhost/$IMAGE_NAME which nano'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME which quarto'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"BayesFactor\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"bookdown\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"cowplot\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"curl\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"dplyr\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"emoji\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"gapminder\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"geojsonsf\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"ggplot2\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"ggpubr\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"googledrive\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"here\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"hexbin\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"Orcs\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"palmerpenguins\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"patchwork\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"plyr\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"pscl\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"RColorBrewer\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"raster\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"rasterVis\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"remotes\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"reshape\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"RSQLite\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"rticles\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"scales\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"terra\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"tidyr\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"tidyterra\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"tidyverse\")"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import twarc"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "from openpyxl import Workbook"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import matplotlib"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import plotnine"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import numpy"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import pandas"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -m spacy validate'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import seaborn"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import textblob; from osgeo import gdal"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import torch; from transformers import pipeline"'
                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import ipywidgets as widgets"'
                            sh 'podman run -d --name=$IMAGE_NAME --rm -p 8888:8888 localhost/$IMAGE_NAME start-notebook.sh --NotebookApp.token="jenkinstest"'
                            sh 'sleep 10 && curl -v http://localhost:8888/lab?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                            sh 'curl -v http://localhost:8888/tree?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                        }
                    }
                    post {
                        always {
                            container('podman') {
                                sh 'podman rm -ifv $IMAGE_NAME'
                            }
                        }
                        unsuccessful {
                            container('podman') {
                                sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                            }
                        }
                    }
                }
                stage('Deploy') {
                    when { branch 'main' }
                    environment {
                        DOCKER_HUB_CREDS = credentials('DockerHubToken')
                    }
                    steps {
                        container('podman') {
                            sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/$IMAGE_NAME:latest --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                            sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/$IMAGE_NAME:v$(date "+%Y%m%d") --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                        }
                    }
                    post {
                        always {
                            container('podman') {
                                sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                            }
                        }
                    }
                }                
            }
            post {
                always {
                    container('podman') {
                        sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                    }
                }
            }
        }
    }
    post {
        success {
            slackSend(channel: '#infrastructure-build', username: 'jenkins', color: 'good', message: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} just finished successfull! (<${env.BUILD_URL}|Details>)")
        }
        failure {
            slackSend(channel: '#infrastructure-build', username: 'jenkins', color: 'danger', message: "Uh Oh! Build ${env.JOB_NAME} ${env.BUILD_NUMBER} had a failure! (<${env.BUILD_URL}|Find out why>).")
        }
    }
}
