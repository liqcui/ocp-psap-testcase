oc get ns |grep gpu-operator-resources
if [ $? -eq 0 ];then
	echo "namespace gpu-operator-resources has been created"
else
	oc create ns gpu-operator-resources
fi
        oc create -f gpu-burn-resource.yaml -n gpu-operator-resources
	sleep 5
	oc get pods -n gpu-operator-resources
