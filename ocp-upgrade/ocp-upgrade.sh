if [ $# -eq 1 ];then
  OCP_VERSION=$1
  oc patch clusterversion/version --patch '{"spec":{"channel": "stable-4" }}' --type=merge
  oc patch clusterversion/version --patch '{"spec":{"upstream":"https://openshift-release.apps.ci.l2s4.p1.openshiftapps.com/graph"}}' --type=merge
  oc get clusterversion -o json|jq ".items[0].spec"
  echo "wait for ocp upgrate update for 30s "
  sleep 30s
  oc adm upgrade status
  oc adm upgrade status>./to_be_updated_version.txt
  grep $OCP_VERSION ./to_be_updated_version.txt
  if [ $? -eq 0 ];then
  	oc adm upgrade --to=$OCP_VERSION
  else
	curl -fsSL -o ./graph https://openshift-release.apps.ci.l2s4.p1.openshiftapps.com/graph
        grep -A1 $OCP_VERSION ./graph| grep payload>./payload.txt
        OCP_UPGRADE_IMAGE=`cat ./payload.txt | awk -F':' '{print $2":"$3}'| tr -d '"' | tr -d ' '`
        echo OCP_UPGRADE_IMAGE is $OCP_UPGRADE_IMAGE
        #grep -A1 $OCP_VERSION ./graph| grep payload | awk -F':' "{print $2}"
        oc adm upgrade --to-image=$OCP_UPGRADE_IMAGE --allow-explicit-upgrade
  fi
else
  	echo -e "$0 OCP_VERSION(4.9.0-0.nightly-2021-08-18-084341,4.9.0-fc.0)\nPlease input the OCP Version you want to upgrade"
fi
