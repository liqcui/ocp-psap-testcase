MACHINE_SET=`oc get machineset -n openshift-machine-api |grep worker | awk '{print $1}' | sort | head -1`
oc get machineset $MACHINE_SET -n openshift-machine-api -o json>/tmp/gpunode.json
cat /tmp/gpunode.json |grep $MACHINE_SET
echo "Replace name "
sed -i "s/$MACHINE_SET/openshift-psap-qe-gpu-node01/g" /tmp/gpunode.json
grep openshift-psap-qe-gpu-node01 /tmp/gpunode.json
sed -i 's/"instanceType": "m5.large",/"instanceType": "g4dn.xlarge",/' /tmp/gpunode.json
oc get machines -n openshift-machine-api |grep g4dn.xlarge
if [ $? -eq 0 ];then
	echo "The GPU Node has been created"
else
	echo "Creating the GPU Nodes ..."
        oc create -f /tmp/gpunode.json
fi
echo "Checking GPU node status ..."
sleep 10s
oc get machines -n openshift-machine-api |grep g4dn.xlarge

