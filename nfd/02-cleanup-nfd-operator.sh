cd cluster-nfd-operator
oc delete -f config/samples/nfd.openshift.io_v1_nodefeaturediscovery.yaml
make undeploy
cd ..
if [ -d cluster-nfd-operator ];then
	rm -rf cluster-nfd-operator
fi
