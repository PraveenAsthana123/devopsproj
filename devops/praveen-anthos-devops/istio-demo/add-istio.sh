#!/usr/bin/env bash

export ISTIO_VERSION=1.15.0

echo "download istio"
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -

echo "change directory"
cd istio-${ISTIO_VERSION}/

echo "add istio to the path"
export PATH=${PWD}/bin:$PATH

echo "install istio - this might take a moment..."
# kubectl apply -f install/kubernetes/helm/istio/templates/crds.yaml
# sleep 5
istioctl manifest apply



kubectl apply -f samples/addons
kubectl rollout status deployment/kiali -n istio-system


echo "------------------------------------"
echo "add istio complete"
echo "now get to developing. If you want to add in the BookInfo sample you can do that by running the following:"
echo "sh ~/istio-series/getting-started/samples/launch-bookinfo.sh"
