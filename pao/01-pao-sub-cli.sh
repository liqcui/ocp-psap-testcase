#Check if NS has been created
oc get ns| grep openshift-performance-addon-operator
if [ ! $? -eq 0 ];then  
oc create -f- <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: openshift-performance-addon-operator
  annotations:
    workload.openshift.io/allowed: management
  labels:
    openshift.io/run-level: "1"
EOF
fi
oc get OperatorGroup -n openshift-performance-addon-operator |grep openshift-performance-addon-operator
if [ ! $? -eq 0 ];then
oc create -f- <<EOF
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: openshift-performance-addon-operator
  namespace: openshift-performance-addon-operator
EOF
fi

oc get Subscription -n openshift-performance-addon-operator |grep openshift-performance-addon-operator-subscription
if [ ! $? -eq 0 ];then
ocp_channel=`oc get packagemanifest performance-addon-operator -n openshift-marketplace -o jsonpath='{.status.defaultChannel}'`
oc create -f- <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-performance-addon-operator-subscription
  namespace: openshift-performance-addon-operator
spec:
  channel: "$ocp_channel" 
  name: performance-addon-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF
fi
