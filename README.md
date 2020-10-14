# wg-rhcos

This container is created on a base UBI8 image. Then we install wireguard inside the container so we can use it on an RHCOS node.

## OpenShift

A sample `pod.yml` is included for OpenShift (k8s) deployment.

## RHCOS

To deploy the `wg-rhcos` container on a bare RHCOS node:

```
sudo podman run -d \
  --privileged \
  --network host \
  --mount type=bind,source=/etc/resolv.conf,target=/etc/resolv.conf \
  -v /etc/os-release:/etc/os-release:ro \
  -v /var/lib/containers/storage/overlay:/tmp/overlay:ro \
  -v /etc/wireguard:/etc/wireguard \
  --restart on-failure \
  quay.io/jugs/wg-rhcos
```
