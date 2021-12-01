#!/usr/bin/env bash
cd $HOME/git/pipelines/
set -e

set_env(){
  export DOCKER_REGISTRY=docker.io
  export DOCKER_USER=<USERNAME>
  export DOCKER_PASSWORD=<PASSWORD>
  IMAGE=$DOCKER_REGISTRY/$DOCKER_USER/api-server
  TAG=1.1.2
}
login(){
  set_env
  echo -e "Login:  $DOCKER_REGISTRY/$DOCKER_USER"
  echo $DOCKER_PASSWORD |docker login $DOCKER_REGISTRY --username=$DOCKER_USER --password-stdin
}

build_img(){
  login
  docker build -t "${IMAGE}:${TAG}" -f backend/Dockerfile .
}

push_img(){
  login
  docker push ${IMAGE}:${TAG}
}

edit_pipeline_deployment(){
  rm /tmp/mydeployment.yaml 2> /dev/null
  kubectl get deployment.apps/ml-pipeline -o yaml -n kubeflow > /tmp/mydeployment.yaml
  vi /tmp/mydeployment.yaml
  kubectl apply -f /tmp/mydeployment.yaml -n kubeflow
  echo "kubectl get all -n kubeflow | grep pipeli"
  kubectl get all -n kubeflow | grep pipeli
}

print_mgs() {
       echo "Please use one of the available commands:
       build  - Build img
       push  - Push img
       edit -  Edit the file to be applies
       forward - Expose cluster services locally (8080, mysql post 3306, minio 9000, visualizationserver -> 8888
       hack - make local code run as in-cluster/ handle certificates, tokens (need to be done after each computer/cluster restart)"
}

port_forward(){
  kubectl proxy --port=8080 &
  kubectl port-forward -n kubeflow svc/mysql 3306 &
  kubectl port-forward -n kubeflow svc/minio-service 9000 &
  kubectl port-forward -n kubeflow svc/ml-pipeline-visualizationserver 8889:8888 &
}

all(){
  build_img
  push_img
  edit_pipeline_deployment
}

hack(){
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
}


if [[ $# -eq 0 ]] ; then
    print_mgs
    exit 0
fi

for i in "$@"
do
    case $i in
     build)
        echo "Build image"
        build_img
        ;;
     push)
        echo "Push image"
        push_img
        ;;
      edit)
        echo "add changes"
        edit_pipeline_deployment
        ;;
      forward)
        echo "port forwarding"
        port_forward
        ;;
      all)
        echo "Build image, push image and apply it"
        all
        ;;
      hack)
        echo "Hack so local code run as in-cluster"
        hack
        ;;
      *)
        print_mgs
        ;;
    esac
done

#Enter in a pod's container (in case one container in a pod)
#kubectl exec --stdin --tty <pod> -n kubeflow  -- /bin/bash

#exec individual commands in a container
#kubectl exec <pod> -- ps aux

#Enter in a container in case the pod has more than one container
#kubectl exec -i -t <pod> --container main-app -- /bin/bash


##############Run Locally the API-Server ##############
#Environment:
#KUBERNETES_SERVICE_HOST=127.0.0.1;KUBERNETES_SERVICE_PORT=8080;ML_PIPELINE_VISUALIZATIONSERVER_SERVICE_HOST=127.0.0.1;ML_PIPELINE_VISUALIZATIONSERVER_SERVICE_PORT=8889

#Package Path:
#github.com/kubeflow/pipelines/backend/src/apiserver

#Arguments:
#--config=/home/didi/git/pipelines/backend/src/apiserver/config --sampleconfig=/home/didi/git/pipelines/backend/src/apiserver/config/sample_config.json -logtostderr=true
