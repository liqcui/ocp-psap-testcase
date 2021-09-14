oc create -f- <<EOF
apiVersion: performance.openshift.io/v1
kind: PerformanceProfile
metadata:
  name: performance
  namespace: openshift-operators
spec:
  cpu:
    isolated: "2-3"
    reserved: "0-1"
  hugepages:
    defaultHugepagesSize: "1G"
    pages:
    - size: "1G"
      node: 0
      count: 1
  realTimeKernel:
    enabled: true
  numa:
    #Valid values are none (default), best-effort, restricted, and single-numa-node
    topologyPolicy: "best-effort"
  nodeSelector:
    node-role.kubernetes.io/worker-cnf: ""
EOF
