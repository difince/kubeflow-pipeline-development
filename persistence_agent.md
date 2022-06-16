# Persistence Agent

## Build Image
```
docker build -t docker.io/atanasovad/persistenceagent:1.1.2 -f backend/Dockerfile.persistenceagent .
docker push atanasovad/persistenceagent:1.1.2
kubectl edit deployment.apps/ml-pipeline-persistenceagent -o yaml -n kubeflow

```
## Run Locally

- Get locally the certificate and the token

```
POD=$(kubectl get pods -n kubeflow -l app=ml-pipeline-persistenceagent -o jsonpath='{.items[0].metadata.name}')

kubectl exec -ti $POD -n kubeflow -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt > /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
kubectl exec -ti $POD -n kubeflow -- cat /var/run/secrets/kubernetes.io/serviceaccount/token > /var/run/secrets/kubernetes.io/serviceaccount/token

```

- PersistenceAgent.run.xml

```xml
<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="PersistentAgent" type="GoApplicationRunConfiguration" factoryName="Go Application">
    <module name="pipelines" />
    <working_directory value="$PROJECT_DIR$" />
    <parameters value="--kubeconfig=$USER_HOME$/.kube/config --master=https://127.0.0.1:37295 --mlPipelineAPIServerName=localhost --mlPipelineServiceHttpPort=8888 --namespace=kubeflow-user-example-com" />
    <envs>
      <env name="KUBEFLOW_USERID_HEADER" value="kubeflow-userid" />
      <env name="KUBEFLOW_USERID_PREFIX" value="" />
      <env name="KUBERNETES_SERVICE_HOST" value="172.19.0.2" />
      <env name="KUBERNETES_SERVICE_PORT" value="6443" />
    </envs>
    <kind value="PACKAGE" />
    <package value="github.com/kubeflow/pipelines/backend/src/agent/persistence" />
    <directory value="$PROJECT_DIR$" />
    <filePath value="$PROJECT_DIR$/backend/src/agent/persistence/main.go" />
    <method v="2" />
  </configuration>
</component>

```

## Other 
```
kubectl api-resources -o wide
kubectl exec -it -n kubeflow  ml-pipeline-persistenceagent-6cb87cf64c-svsg2 -- /bin/sh

Original image: image: gcr.io/ml-pipeline/persistenceagent:1.8.1

```