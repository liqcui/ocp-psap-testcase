if [ -d special-resource-operator ];then
	rm -rf special-resource-operator
fi
git clone https://github.com/openshift/special-resource-operator.git
cd special-resource-operator
git branch -a
TAG=master make deploy
sleep 60s
oc get pods -n openshift-special-resource-operator
