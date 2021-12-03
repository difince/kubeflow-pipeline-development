# Kubeflow Pipeline Development Guide

- The repository contains a [guidance](https://github.com/difince/kubeflow-pipeline-development/blob/main/kubeflow-pipeline-dev-instructions.md) file explaining how to run Kubeflow pipelines in development mode locally - thus be able to debug the code in your IDE. 
- It contains and a [bash script](https://github.com/difince/kubeflow-pipeline-development/blob/main/local_development.sh) for automating the process of building an image, pushing it into docker.hub repository and then make the image used within your running Kubeflow instance. The script also automates some of the steps that makes your local pipelince code runs as in-cluster (see here [5.](https://github.com/difince/kubeflow-pipeline-development/blob/main/kubeflow-pipeline-dev-instructions.md))

NOTE: Place **local_development.sh** into the root directory of your pipeline project - where you git clone https://github.com/kubeflow/pipelines 

#### CURL Example Requests

`curl localhost:8888/apis/v1beta1/pipelines | json_pp`

`curl localhost:8888/apis/v1beta1/pipelines/name/xaxa`

`curl localhost:8888/apis/v1beta1/pipelines/name/[Tutorial]%20DSL%20-%20Control%20structures` 

#### Other useful commands
These commands should be used in your run the entire Kubeflow, not just the Pipelines

`kubectl port-forward -n kubeflow svc/ml-pipeline-ui 8080:80`

`kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80`

`kubectl exec -ti ml-pipeline-8c4b99589-hw4lp -c ml-pipeline-api-server -n kubeflow -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt > $HOME/ca.crt`

`kubectl exec -ti $POD -c ml-pipeline-api-server -n kubeflow -- cat /var/run/secrets/kubernetes.io/serviceaccount/token > $HOME/token`

`kubectl cp kubeflow/$POD:/samples/ $HOME/samples/ -c ml-pipeline-api-server`

`kubectl proxy --port=8082 &`

