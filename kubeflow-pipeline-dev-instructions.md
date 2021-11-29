# Kubeflow Pipelines development

Currently API server is not able to run locally as it performs a kubernetes client initialization trying to read in-cluster config rather than load kubeconfig. This limitation is addressed in this [issue](https://github.com/kubeflow/pipelines/issues/4738). Meanwhile for running locally we can follow this guide.

## Provisioning kubernetes cluster with Kubeflow Pipelines
For development you need a local or remote cluster so Pipelines code can connect to services like MinIO, Mysql and Kubernetes API Server.

For a local Kubernetes cluster, depending on available resources, recommended options are:
- [MiniKF](https://www.kubeflow.org/docs/started/workstation/getting-started-minikf/). Full-fledged local kubeflow deployment by Arrikto.
- [K3S](https://k3s.io/). Lightweight and fully functional certified distribution of Kubernetes by Rancher. Alternative to miniKF if RAM or CPU resources are scarce. If using this option, need to install Kubeflow pipelines on top of it.
  - [Install k3s on Linux/Mac](https://k3s.io/).
  - [Install k3s on WSL 2](https://github.com/arllanos/tekhno/blob/master/k3s-on-wsl-install.md).

### Install Kubeflow pipelines (If using K3s)
> Note: This is a standalone deployment of pipelines. Check updated standalone deployment doc [here](https://www.kubeflow.org/docs/components/pipelines/installation/standalone-deployment/).
```bash
export PIPELINE_VERSION=1.0.5

kubectl apply -k "github.com/kubeflow/pipelines/manifests/kustomize/cluster-scoped-resources?ref=$PIPELINE_VERSION"

kubectl wait --for condition=established --timeout=60s crd/applications.app.k8s.io

kubectl apply -k "github.com/kubeflow/pipelines/manifests/kustomize/env/platform-agnostic-pns?ref=$PIPELINE_VERSION"

kubectl get pods -n kubeflow
```

## Backend
### Setting up local dev environment for Kubeflow Pipelines
1. Install Go 1.13.x

2. Install dependencies
```
apt-get update && apt-get install -y cmake clang musl-dev openssl
```

3. Compile
```bash
GO111MODULE=on go build -o bin/apiserver backend/src/apiserver/*.go
```

4. Edit `backend/src/apiserver/config/config.json` to point to your dev Mysql and Minio instances.
The following config has been added
- `DBConfig.Host`
- `ObjectStoreConfig.Host`
- `ObjectStoreConfig.Port`

Optionally change `DBConfig.DBName` and `ObjectStoreConfig.BucketName` to use separate DB and Bucket for dev
```json
{
  "DBConfig": {
    "Host": "127.0.0.1",
    "DriverName": "mysql",
    "DataSourceName": "",
    "DBName": "mlpipeline",
    "GroupConcatMaxLen": "4194304"
  },
  "ObjectStoreConfig": {
    "Host": "127.0.0.1",
    "Port": "9000",
    "AccessKey": "minio",
    "SecretAccessKey": "minio123",
    "BucketName": "mlpipeline",
    "PipelinePath": "pipelines"
  },
  "InitConnectionTimeout": "6m",
  "DefaultPipelineRunnerServiceAccount": "pipeline-runner",
  "CacheEnabled": "true",
  "SharedPipelinesEnabled": "true"
}

```

5. Hack so local code run as in-cluster
> This need to be repeated after each computer and/or cluster restart
```bash
# copy in-cluster service account at /var/run/secrets/kubernetes.io/serviceaccount to local dev
sudo mkdir -p /var/run/secrets/kubernetes.io/serviceaccount

POD=$(kubectl get pods -n kubeflow -l app=ml-pipeline -o jsonpath='{.items[0].metadata.name}')

kubectl exec -ti $POD -n kubeflow -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt > $HOME/ca.crt
kubectl exec -ti $POD -n kubeflow -- cat /var/run/secrets/kubernetes.io/serviceaccount/token > $HOME/token

sudo mv $HOME/ca.crt /var/run/secrets/kubernetes.io/serviceaccount
sudo mv $HOME/token /var/run/secrets/kubernetes.io/serviceaccount

# copy samples to /samples in local dev
rm -rf $HOME/samples
rm -rf /samples
kubectl cp kubeflow/$POD:/samples/ $HOME/samples/
sudo mv  $HOME/samples /
```

6. Expose cluster services locally
```bash
# expose kubernetes API server on localhost
kubectl proxy --port=8080 &

# expose mysql
kubectl port-forward -n kubeflow svc/mysql 3306 &

# expose minio
kubectl port-forward -n kubeflow svc/minio-service 9000 &

# expose visualization server (note this will listen on 8889 locally)
kubectl port-forward -n kubeflow svc/ml-pipeline-visualizationserver 8889:8888 &
```

7. Configure `launch.json` to be able to debug in vscode.
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch",
            "type": "go",
            "request": "launch",
            "mode": "auto",
            "program": "${workspaceFolder}/backend/src/apiserver",
            "env": {
                "KUBERNETES_SERVICE_HOST":"127.0.0.1",
                "KUBERNETES_SERVICE_PORT": "8080",
                "ML_PIPELINE_VISUALIZATIONSERVER_SERVICE_HOST": "127.0.0.1",
                "ML_PIPELINE_VISUALIZATIONSERVER_SERVICE_PORT": "8889"
            },
            "args": [
                "--config=${workspaceFolder}/backend/src/apiserver/config",
                "--sampleconfig=config/sample_config.json",
                "-logtostderr=true"]
        }
    ]
}
```
8. You can now debug Pipelines apiserver locally in vscode.

### Build and push image
To build the API server image and upload it to your own **docker hub** on x86_64 machines:
```bash
export DOCKER_REGISTRY=<docker.io|other>
export DOCKER_USER=<myuser>
export DOCKER_PASSWORD=<mypassword>

echo $DOCKER_PASSWORD |docker login $DOCKER_REGISTRY --username=$DOCKER_USER --password-stdin

IMAGE=$DOCKER_REGISTRY/$DOCKER_USER/api-server
TAG=latest

docker build -t "${IMAGE}:${TAG}" -f backend/Dockerfile .

docker push ${IMAGE}:${TAG}
```

To get details for cluster registry 
```
kubectl get secret -n kubeflow regcred -o jsonpath='{.data}' | sed 's/\.//' | jq .dockerconfigjson | tr -d \" | base64 -d | jq .auths 
```

For other machine architectures or to use gcr.io registry, check [developer_guide.md](https://github.com/kubeflow/pipelines/blob/master/developer_guide.md)

## Backend deployments / images

| NAME | SRC CODE PATH | IMAGE |
|---|---|---|
| ml-pipeline | backend/src/apiserver| api-server |
| ml-pipeline-scheduledworkflow | backend/src/crd/controller/scheduledworkflow | scheduledworkflow |
| ml-pipeline-viewer-crd | backend/src/crd/controller/viewer | viewer-crd-controller |
| ml-pipeline-persistenceagent | backend/src/agent/persistence | persistenceagent |
| ml-pipeline-visualizationserver | backend/src/apiserver/visualization | visualization-server|
| cache-deployer-deployment | backend/src/cache/deployer | cache-deployer |
| cache-server | backend/src/cache | cache-server |

## Frontend
Follow instructions in frontend/README.md
Also make sure to do edit `frontend/package.json` and set proxy to hit the right backend api-server port.
```json
"proxy": "http://localhost:8888",
```

### Frontend deployments / image
| NAME | SRC CODE PATH | IMAGE |
|---|---|---|
| ml-pipeline-ui | frontend | frontend |

### Other deployments / image
| NAME | SRC CODE PATH | IMAGE |
|---|---|---|
| metadata-writer | | |
| metadata-grpc-deployment | | |
| metadata-envoy-deployment | | |
| controller-manager | | |
| minio | | |
| mysql| | |
| workflow-controller | | |
