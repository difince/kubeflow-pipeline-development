# Kubeflow Pipeline Development Guide

- The repository contains a [guidance](https://github.com/difince/kubeflow-pipeline-development/blob/main/kubeflow-pipeline-dev-instructions.md) file explaining how to run Kubeflow pipelines in development mode locally - thus be able to debug the code in your IDE. 
- It contains and a [bash script](https://github.com/difince/kubeflow-pipeline-development/blob/main/local_development.sh) for automating the process of building an image, pushing it into docker.hub repository and then make the image used within your running Kubeflow instance. The script also automates some of the steps that makes your local pipelince code runs as in-cluster (see here [5.](https://github.com/difince/kubeflow-pipeline-development/blob/main/kubeflow-pipeline-dev-instructions.md))

NOTE: Place **local_development.sh** into the root directory of your pipeline project - where you ```git clone https://github.com/kubeflow/pipelines``` 

