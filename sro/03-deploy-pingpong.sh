cd special-resource-operator
VERSION=0.0.1; REPO=example SPECIALRESOURCE=ping-pong make
sleep 180s
for i in $(oc get pods -n ping-pong --no-headers | awk '{print $1}'); do echo $i;oc logs $i -n ping-pong| tail -n3; done
