VERSION=$1
if [ $# -eq 1 ];then
export PATH=$PATH:/usr/local/go/bin/:.
if [ -d cluster-nfd-operator ];then
	rm -rf cluster-nfd-operator
fi
git clone https://github.com/openshift/cluster-nfd-operator.git
cd cluster-nfd-operator
git checkout release-${VERSION}
make deploy IMAGE_TAG=quay.io/openshift-psap/cluster-nfd-operator:${VERSION}.0;
sleep 60s
oc create -f config/samples/nfd.openshift.io_v1_nodefeaturediscovery.yaml
sleep 30s
oc get pods -n openshift-nfd 
sleep 30s
oc describe node |grep feature|grep cpuid
else
	echo "$0: Please specify the version you want to deploy:4.9"
fi
