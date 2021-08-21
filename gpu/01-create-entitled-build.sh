oc create -f entitled-build/0003-cluster-wide-machineconfigs.yaml
sleep 300s
oc create -f entitled-build/0004-cluster-wide-entitled-pod.yaml
oc create -f entitled-build/0005-nvidia-driver-container.yaml
