#!/bin/bash
#Check if NS has been created
if [ $# -eq 0 ];then
	echo "Please specify version, eg: 4.9"
	exit 1
else
     VERSION=$1
fi
oc get ns| grep openshift-special-resource-operator
if [ ! $? -eq 0 ];then
oc create -f- <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: openshift-special-resource-operator
EOF
fi
oc get OperatorGroup -n openshift-special-resource-operator | grep openshift-special-resource-operator
if [ ! $? -eq 0 ];then
oc create -f- <<EOF
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  generateName: openshift-special-resource-operator-
  name: openshift-special-resource-operator
  namespace: openshift-special-resource-operator
spec:
  targetNamespaces:
  - openshift-special-resource-operator
EOF
fi
#VERSION=`oc get packagemanifest special-resource-operator -n openshift-marketplace -o jsonpath='{.status.defaultChannel}'`
oc get Subscription -n openshift-special-resource-operator | grep special-resource-operator
if [ $? -eq 0 ];then
   oc delete Subscription special-resource-operator -n openshift-special-resource-operator
fi
sleep 30s
oc create -f- <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: special-resource-operator
  namespace: openshift-special-resource-operator
spec:
  channel: "$VERSION"
  installPlanApproval: Automatic
  name: special-resource-operator
  source: qe-app-registry
  #source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF
sleep 60s
oc get pods -n openshift-special-resource-operator
