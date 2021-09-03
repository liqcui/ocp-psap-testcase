oc create -f entitled-build/0003-cluster-wide-machineconfigs.yaml
sleep 360s
oc create -f entitled-build/0004-cluster-wide-entitled-pod.yaml
sleep 60s
oc logs cluster-entitled-build-pod
sleep 120s
oc create -f entitled-build/0005-nvidia-driver-container.yaml
sleep 30s
oc logs -f nvidia-driver-internal-1-build
