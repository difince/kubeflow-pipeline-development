## CURL Example Requests
[Kubeflow Pipelines API Reference](https://www.kubeflow.org/docs/components/pipelines/reference/api/kubeflow-pipeline-api-spec/)


#### List All Pipelines

`curl localhost:8888/apis/v1beta1/pipelines | json_pp`

####GetPipelineByNameAndNamespace
`curl -X GET "localhost:8888/apis/v1beta1/namespaces/kubeflow-user-example-com/pipelines/mm" | json_pp`

In case of standalone application or shared pipeline (the pipeline does not belong to specific namespace) the query should look like this:

`curl -X GET "localhost:8888/apis/v1beta1/namespaces/-/pipelines/mm" | json_pp`

#### Unachive a run
`curl -X POST localhost:8888/apis/v1beta1/runs/898631d9-dd22-4f1a-975a-241cd5e86ead:unarchive`
