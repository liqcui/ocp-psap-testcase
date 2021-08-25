cd special-resource-operator;
git checkout release-4.9
VERSION=0.0.1 REPO=example SPECIALRESOURCE=simple-kmod make
oc apply -f charts/example/simple-kmod-0.0.1/simple-kmod.yaml
sleep 180s
for i in $(oc get nodes --no-headers | grep worker| awk '{print $1}'); do echo $i; oc debug node/$i -- chroot /host lsmod | grep simple_; done
