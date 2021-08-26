cd special-resource-operator
VERSION=0.0.1 REPO=example SPECIALRESOURCE=multi-build make chart
oc create -f- <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: openshift-psap-multibuild-pull-secret
  namespace: multi-build
data:
  .dockerconfigjson: ewoJImF1dGhzIjogewoJCSJkb2NrZXIuaW8iOiB7CgkJCSJhdXRoIjogIlpHRm5jbUY1T2pRMlltSmpOekkxTFROaE1HSXRORGs1WlMxaU1qUmtMVFJoTjJZME5XWmtZakJsTlE9PSIKCQl9LAoJCSJodHRwczovL2luZGV4LmRvY2tlci5pby92MS8iOiB7CgkJCSJhdXRoIjogIlpHRm5jbUY1T2pRMlltSmpOekkxTFROaE1HSXRORGs1WlMxaU1qUmtMVFJoTjJZME5XWmtZakJsTlE9PSIKCQl9Cgl9Cn0K
type: kubernetes.io/dockerconfigjson
EOF
oc create -f- <<EOF
apiVersion: sro.openshift.io/v1beta1
kind: SpecialResource
metadata:
  name: multi-build
spec:
  debug: true
  namespace: multi-build
  chart:
    name: multi-build
    version: 0.0.1
    repository:
      name: example
      url: cm://multi-build/multi-build-chart
  set:
    kind: Values
    apiVersion: sro.openshift.io/v1beta1
    pushSecret: openshift-psap-multibuild-pull-secret
    imageToSign: docker.io/dagray/{{.Values.specialresource.metadata.name}}-{{.Values.groupName.driverContainer}}:v{{.Values.kernelFullVersion}}
    cosignPassword: strongpassword
    buildArgs:
    - name: "KMODVER"
      value: "{{ .Values.kernelFullVersion }}"
  driverContainer:
    source:
      git:
        ref: "master"
        uri: "https://github.com/openshift-psap/kvc-simple-kmod.git"
EOF
oc get pods -n multi-build -w
