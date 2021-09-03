MACHINE_SET=`oc get machineset -n openshift-machine-api |grep worker | awk '{print $1}' | sort | tail -1`
oc get machineset $MACHINE_SET -n openshift-machine-api -o json>./gpunode.json
cat ./gpunode.json |grep $MACHINE_SET
echo "Replace name "
sed -i "s/$MACHINE_SET/openshift-psap-qe-gpu-node01/g" ./gpunode.json
grep openshift-psap-qe-gpu-node01 ./gpunode.json
sed -i 's/"instanceType":.*/"instanceType": "g4dn.xlarge",/' ./gpunode.json
grep instanceType ./gpunode.json
oc get machines -n openshift-machine-api |grep g4dn.xlarge
if [ $? -eq 0 ];then
	echo "The GPU Node has been created"
else
	echo "Creating the GPU Nodes ..."
        oc create -f ./gpunode.json
fi
echo "Checking GPU node status ..."
sleep 120s
oc get machines -n openshift-machine-api |grep g4dn.xlarge
sleep 60s
oc get nodes
