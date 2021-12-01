# kubeflow-pipeline-development

Fisrt read **kubeflow-pipeline-dev-instructions.md** and **local_development.sh**. 
The bash script is an implementation of kubeflow-pipeline-dev-instructions.md

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

