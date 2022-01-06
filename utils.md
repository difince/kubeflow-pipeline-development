
[Kubeflow Pipelines API Reference](https://www.kubeflow.org/docs/components/pipelines/reference/api/kubeflow-pipeline-api-spec/)

#### CURL Example Requests

`curl localhost:8888/apis/v1beta1/pipelines | json_pp`

`curl localhost:8888/apis/v1beta1/pipelines/name/xaxa`

`curl localhost:8888/apis/v1beta1/pipelines/name/[Tutorial]%20DSL%20-%20Control%20structures`

`curl localhost:8888/apis/v1beta1/pipelines?resource_refernece_key.id=kubeflow-user-example-com&resource_reference_key.type=NAMESPACE`

`curl -X POST localhost:8888/apis/v1beta1/runs/898631d9-dd22-4f1a-975a-241cd5e86ead:unarchive`
