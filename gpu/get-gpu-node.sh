GPU_NODES=$(oc get nodes -lnvidia.com/gpu.present=true -oname --no-headers)

for node in $(echo $GPU_NODES); do
  oc debug $node -- rm -f /host/etc/containers/oci/hooks.d/oci-nvidia-hook.json
done

