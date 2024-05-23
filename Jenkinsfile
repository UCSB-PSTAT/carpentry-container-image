pipeline {
    agent none
    triggers {
        upstream(upstreamProjects: 'UCSB-PSTAT GitHub/jupyter-base/main', threshold: hudson.model.Result.SUCCESS)
    }
    environment {
        IMAGE_NAME = 'carpentry-collab'
    }
    stages {
        stage('Build Test Deploy') {
            agent {
                label 'jupyter'
            }
            stages{
                stage('Build') {
                    steps {
                        echo "NODE_NAME = ${env.NODE_NAME}"
                        sh 'podman build -t $IMAGE_NAME --pull --force-rm --no-cache .'
                     }
                    post {
                        unsuccessful {
                            sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                        }
                    }
                }
                stage('Test') {
                    steps {
                        sh 'podman run -it --rm localhost/$IMAGE_NAME which nano'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME which quarto'
			sh 'podman run -it --rm localhost/$IMAGE_NAME R -e "library(\"BayesFactor\");library(\"bookdown\");library(\"cowplot\");library(\"curl\");library(\"dplyr\");library(\"emoji\");library(\"gapminder\");library(\"geojsonsf\");library(\"ggplot2\");library(\"ggpubr\");library(\"googledrive\");library(\"here\");library(\"hexbin\");library(\"Orcs\");library(\"palmerpenguins\");library(\"patchwork\");library(\"plyr\");library(\"pscl\");library(\"RColorBrewer\");library(\"raster\");library(\"rasterVis\");library(\"remotes\");library(\"reshape\");library(\"rgdal\");library(\"RSQLite\");library(\"rticles\");library(\"scales\");library(\"sf\");library(\"terra\");library(\"tidyr\");library(\"tidyterra\");library(\"tidyverse\")"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import twarc"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "from openpyxl import Workbook"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import matplotlib"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import plotnine"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import numpy"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import pandas"'
                        sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import textblob; from osgeo import gdal"'
                        sh 'podman run -d --name=$IMAGE_NAME --rm -p 8888:8888 localhost/$IMAGE_NAME start-notebook.sh --NotebookApp.token="jenkinstest"'
                        sh 'sleep 10 && curl -v http://localhost:8888/lab?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                        sh 'curl -v http://localhost:8888/tree?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                    }
                    post {
                        always {
                            sh 'podman rm -ifv $IMAGE_NAME'
                        }
                        unsuccessful {
                            sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                        }
                    }
                }
                stage('Deploy') {
                    when { branch 'main' }
                    environment {
                        DOCKER_HUB_CREDS = credentials('DockerHubToken')
                    }
                    steps {
                        sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/$IMAGE_NAME:latest --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                        sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/$IMAGE_NAME:v$(date "+%Y%m%d") --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                    }
                    post {
                        always {
                            sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                        }
                    }
                }                
            }
            post {
                always {
                    sh 'podman rmi -i localhost/$IMAGE_NAME || true'
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
