from __future__ import print_function

import random
import string

import requests

import kfp_server_api
from kfp_server_api.rest import ApiException

def random_suffix() -> string:
    return ''.join(random.choices(string.ascii_lowercase + string.digits, k=10))

# Get Authentication Session
HOST = "http://localhost:8080/"
USERNAME = "user@example.com"
PASSWORD = "12341234"
USER_NAMESPACE = "kubeflow-user-example-com"

session = requests.Session()
response = session.get(HOST)

headers = {
    "Content-Type": "application/x-www-form-urlencoded",
}

data = {"login": USERNAME, "password": PASSWORD}
session.post(response.url, headers=headers, data=data)
print(session.cookies.get_dict())
session_cookie = session.cookies.get_dict()["authservice_session"]
# client = kfp.Client(
#     host=f"{HOST}/pipeline",
#     cookies=f"authservice_session={session_cookie}",
#     namespace=NAMESPACE,
# )
#
# pipelines = client.list_pipelines()

# HOST = "http://localhost:8888/"
configuration = kfp_server_api.Configuration(
    host=f"{HOST}/pipeline",
)

pipeline_yaml = "/Users/antheaj/workspace/vml-2021-kubeflow-workshop/kubeflow/pipeline/hello-world-v2.yaml"
pipeline_url = "https://github.com/kubeflow/examples/raw/master/github_issue_summarization/pipelines/example_pipelines/gh_summ_hosted_kfp.py.tar.gz"


# Create Pipeline Version
with kfp_server_api.ApiClient(configuration,
                              cookie=f'authservice_session={session_cookie}') as api_client:
    api_instance = kfp_server_api.PipelineServiceApi(api_client)

    pipelines = api_instance.list_pipelines()
    print(pipelines)

    body = kfp_server_api.ApiPipelineVersion(
        name="pipeline_version-" + random_suffix(),
        package_url=kfp_server_api.ApiUrl(pipeline_url),
        resource_references=[
            kfp_server_api.ApiResourceReference(
                key=kfp_server_api.ApiResourceKey(
                    type=kfp_server_api.ApiResourceType.PIPELINE,
                    id=pipelines.pipelines[0].id
                ),
                relationship=kfp_server_api.ApiRelationship.OWNER
            )
        ]
    )  # ApiPipelineVersion | ResourceReference inside PipelineVersion specifies the pipeline that this version belongs to.

    try:
        # Adds a pipeline version to the specified pipeline.
        api_response = api_instance.create_pipeline_version(body)
        print(api_response)
    except ApiException as e:
        print("Exception when calling PipelineServiceApi->create_pipeline_version: %s\n" % e)


# Upload Pipeline
with kfp_server_api.ApiClient(configuration,
                              cookie=f'authservice_session={session_cookie}') as api_client:
    upload_pipeline_api_instance = kfp_server_api.PipelineUploadServiceApi(api_client)
    try:
        api_response = upload_pipeline_api_instance.upload_pipeline(
            "/home/didi/Downloads/iris_pipeline_v1.yaml",name="UploadedPipelineByFile-" + random_suffix(),
            description="UploadedPipelineByFile Description")
        print(api_response)
    except ApiException as e:
        print("Exception when calling PipelineUploadServiceApi->upload_pipeline: %s\n" % e)


#List Experiments
with kfp_server_api.ApiClient(configuration,
                              cookie=f'authservice_session={session_cookie}') as api_client:
    experiment_api_instance = kfp_server_api.ExperimentServiceApi(api_client)
    try:
        api_response = experiment_api_instance.list_experiment(resource_reference_key_type=kfp_server_api.ApiResourceType.NAMESPACE,
                                                               resource_reference_key_id=USER_NAMESPACE)
        print(api_response)
    except ApiException as e:
        print("Exception when calling ExperimentServiceApi->list_experiment: %s\n" % e)

#List Runs
with kfp_server_api.ApiClient(configuration,
                              cookie=f'authservice_session={session_cookie}') as api_client:
    run_api_instance = kfp_server_api.RunServiceApi(api_client)
    try:
        api_response = run_api_instance.list_runs(resource_reference_key_type=kfp_server_api.ApiResourceType.NAMESPACE,
                                                  resource_reference_key_id=USER_NAMESPACE)
        print(api_response)
    except ApiException as e:
        print("Exception when calling RunServiceApi->list_runs: %s\n" % e)
