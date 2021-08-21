OCP_VERSION=$1
oc patch clusterversion/version --patch '{"spec":{"channel": "stable-4" }}' --type=merge
oc patch clusterversion/version --patch '{"spec":{"upstream":"https://openshift-release.apps.ci.l2s4.p1.openshiftapps.com/graph"}}' --type=merge
oc get clusterversion -o json|jq ".items[0].spec"
oc adm upgrade status
curl -fsSL -o ./graph https://openshift-release.apps.ci.l2s4.p1.openshiftapps.com/graph
grep -A1 $OCP_VERSION ./graph| grep payload| awk -F':' "{print $2}"
#oc adm upgrade --to=VERSION
