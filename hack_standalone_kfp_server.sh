# copy in-cluster service account at /var/run/secrets/kubernetes.io/serviceaccount to local dev
sudo mkdir -p /var/run/secrets/kubernetes.io/serviceaccount

POD=$(kubectl get pods -n kubeflow -l app=ml-pipeline -o jsonpath='{.items[0].metadata.name}')

kubectl exec -ti $POD -n kubeflow -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt > $HOME/ca.crt
kubectl exec -ti $POD -n kubeflow -- cat /var/run/secrets/kubernetes.io/serviceaccount/token > $HOME/token

sudo mv $HOME/ca.crt /var/run/secrets/kubernetes.io/serviceaccount
sudo mv $HOME/token /var/run/secrets/kubernetes.io/serviceaccount

# copy samples to /samples in local dev
rm -rf $HOME/samples
sudo rm -rf /samples
kubectl cp kubeflow/$POD:/samples/ $HOME/samples/
sudo mv  $HOME/samples /

# expose kubernetes API server on localhost
kubectl proxy --port=8080 &

# expose mysql
kubectl port-forward -n kubeflow svc/mysql 3306 &

# expose minio
kubectl port-forward -n kubeflow svc/minio-service 9000 &

# expose visualization server (note this will listen on 8889 locally)
kubectl port-forward -n kubeflow svc/ml-pipeline-visualizationserver 8889:8888 &
