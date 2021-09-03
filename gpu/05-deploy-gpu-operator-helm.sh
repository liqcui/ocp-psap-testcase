export HELM_VERSION=v1.8.0
cp values-${HELM_VERSION}.yaml values.yaml
helm fetch https://helm.ngc.nvidia.com/nvidia/charts/gpu-operator-${HELM_VERSION}.tgz
oc create ns gpu-operator-resources
helm install  gpu-operator gpu-operator-${HELM_VERSION}.tgz -f values.yaml -n gpu-operator-resources
