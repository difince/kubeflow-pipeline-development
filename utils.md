## CURL Example Requests
<i>Note: Not all provided examples could be directly executed. Some depends on external files or keys/names that needs 
to exist in the local DB. Use these examples just as a reference how the cURLs request could look like.</i>  

[Kubeflow Pipelines API Reference](https://www.kubeflow.org/docs/components/pipelines/reference/api/kubeflow-pipeline-api-spec/)


#### List All Pipelines

`curl localhost:8888/apis/v1beta1/pipelines | json_pp`

#### GetPipelineByNameAndNamespace
`curl -X GET "localhost:8888/apis/v1beta1/namespaces/kubeflow-user-example-com/pipelines/mm" | json_pp`

In case of standalone application or shared pipeline (the pipeline does not belong to specific namespace) the query should look like this:

`curl -X GET "localhost:8888/apis/v1beta1/namespaces/-/pipelines/mm" | json_pp`

#### Upload Pipeline (not working, but worthy to debug it)
`curl 'http://localhost:8888/apis/v1beta1/pipelines/upload?name=xa&description=xa' -X POST -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundary6oDx0MhByQfRgNfs' --data-raw $'------WebKitFormBoundary6oDx0MhByQfRgNfs\r\nContent-Disposition: form-data; name="uploadfile"; filename="iris_pipeline_v1.yaml"\r\nContent-Type: application/x-yaml\r\n\r\n\r\n------WebKitFormBoundary6oDx0MhByQfRgNfs--\r\n'`

> {"error_message":"Error creating pipeline: Create pipeline failed: InvalidInputError: unknown template format: pipeline spec is invalid","error_details":"Error creating pipeline: Create pipeline failed: InvalidInputError: unknown template format: pipeline spec is invalid"}
#### Unachive a run
`curl -X POST localhost:8888/apis/v1beta1/runs/898631d9-dd22-4f1a-975a-241cd5e86ead:unarchive`
