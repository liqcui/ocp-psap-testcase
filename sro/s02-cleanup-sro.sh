cd special-resource-operator
make undeploy;
if [ -d special-resource-operator ];then
	rm -rf special-resource-operator
fi
