#### <i>**Link to the Official [Kubeflow Pipelines API Reference](https://www.kubeflow.org/docs/components/pipelines/reference/api/kubeflow-pipeline-api-spec/)**</i>


## CURL Example Requests
<i>Note: Not all provided examples could be directly executed. Some depends on external files or keys/names that needs 
to exist in the local DB. Use these examples just as a reference how the cURLs request could look like.</i>  

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

### RUNs

#### LIST RUNs
```
curl 'http://localhost:8080/pipeline/apis/v1beta1/runs?page_token=&page_size=10&sort_by=created_at%20desc&resource_reference_key.type=EXPERIMENT&resource_reference_key.id=5deccaac-0a27-4a2c-835d-b9d3547fd552&filter=%257B%2522predicates%2522%253A%255B%257B%2522key%2522%253A%2522storage_state%2522%252C%2522op%2522%253A%2522NOT_EQUALS%2522%252C%2522string_value%2522%253A%2522STORAGESTATE_ARCHIVED%2522%257D%255D%257D' \
  -H 'Connection: keep-alive' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="98", "Google Chrome";v="98"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.80 Safari/537.36' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'Accept: */*' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: http://localhost:8080/pipeline/' \
  -H 'Accept-Language: en,bg-BG;q=0.9,bg;q=0.8' \
  -H 'Cookie: Pycharm-b93cf1d4=ce835058-9f5e-4fbe-aeba-0f12864f0baf; authservice_session=MTY0NjkxMzY3M3xOd3dBTkZwV1F6ZEhVREkxTkZKVlVsbExXazVVVGt4V1ZFaFRNalpZVEZaSlMwTkVUME16U1ZreVZqWkVOVWRXTjBaSVIwVTJORUU9fP5tJk-iCSdjoGc9Ntxx2FN0uJ31K8tamFy4yycbz9d5' \
  --compressed

```
### JOBs

#### LIST JOBs   

```
curl 'http://localhost:8080/pipeline/apis/v1beta1/jobs?page_size=100&sort_by=&resource_reference_key.type=EXPERIMENT&resource_reference_key.id=5deccaac-0a27-4a2c-835d-b9d3547fd552' \
-H 'Connection: keep-alive' \
-H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="98", "Google Chrome";v="98"' \
-H 'sec-ch-ua-mobile: ?0' \
-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.80 Safari/537.36' \
-H 'sec-ch-ua-platform: "Linux"' \
-H 'Accept: */*' \
-H 'Sec-Fetch-Site: same-origin' \
-H 'Sec-Fetch-Mode: cors' \
-H 'Sec-Fetch-Dest: empty' \
-H 'Referer: http://localhost:8080/pipeline/' \
-H 'Accept-Language: en,bg-BG;q=0.9,bg;q=0.8' \
-H 'Cookie: Pycharm-b93cf1d4=ce835058-9f5e-4fbe-aeba-0f12864f0baf; authservice_session=MTY0NjkxMzY3M3xOd3dBTkZwV1F6ZEhVREkxTkZKVlVsbExXazVVVGt4V1ZFaFRNalpZVEZaSlMwTkVUME16U1ZreVZqWkVOVWRXTjBaSVIwVTJORUU9fP5tJk-iCSdjoGc9Ntxx2FN0uJ31K8tamFy4yycbz9d5' \
--compressed
```

#### POST JOB
```
curl 'http://localhost:8080/pipeline/apis/v1beta1/jobs' \
  -H 'Connection: keep-alive' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="98", "Google Chrome";v="98"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.80 Safari/537.36' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'Content-Type: application/json' \
  -H 'Accept: */*' \
  -H 'Origin: http://localhost:8080' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: http://localhost:8080/pipeline/' \
  -H 'Accept-Language: en,bg-BG;q=0.9,bg;q=0.8' \
  -H 'Cookie: Pycharm-b93cf1d4=ce835058-9f5e-4fbe-aeba-0f12864f0baf; authservice_session=MTY0NjkxMzY3M3xOd3dBTkZwV1F6ZEhVREkxTkZKVlVsbExXazVVVGt4V1ZFaFRNalpZVEZaSlMwTkVUME16U1ZreVZqWkVOVWRXTjBaSVIwVTJORUU9fP5tJk-iCSdjoGc9Ntxx2FN0uJ31K8tamFy4yycbz9d5' \
  --data-raw '{"description":"","name":"JOB","pipeline_spec":{"parameters":[{"name":"message","value":"message"},{"name":"pipeline-root","value":""},{"name":"pipeline-name","value":"pipeline/[Tutorial] V2 lightweight Python components"}]},"resource_references":[{"key":{"id":"5deccaac-0a27-4a2c-835d-b9d3547fd552","type":"EXPERIMENT"},"relationship":"OWNER"},{"key":{"id":"26a73732-73dd-4318-9fe1-96626498466d","type":"PIPELINE_VERSION"},"relationship":"CREATOR"}],"service_account":"","enabled":true,"max_concurrency":"10","no_catchup":false,"trigger":{"periodic_schedule":{"interval_second":"600"}}}' \
  --compressed
```