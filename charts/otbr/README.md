# otbr

![Version: 26.9.0](https://img.shields.io/badge/Version-26.9.0-informational?style=flat-square) ![AppVersion: v2026.09.0](https://img.shields.io/badge/AppVersion-v2026.09.0-informational?style=flat-square)

OpenThread Border Router (OTBR) connects a Thread network to the host infrastructure network

This chart requires **ipvlan**, **macvlan**, or **hostNetwork** so the pod sits on the infrastructure LAN. A normal pod network, ClusterIP, or Ingress is not enough. Dual-stack IPv6 in the cluster does not replace that attachment.

**This chart is not maintained by the upstream project and any issues with the chart should be raised [here](https://github.com/retsamedoc/helm-charts/issues/new/choose)**

## Source Code

* <https://github.com/openthread/ot-br-posix>

## Requirements

Kubernetes: `>=1.31.0-0`

## Dependencies

| Repository | Name | Version |
|------------|------|---------|
| file://../common | common | 26.9.0 |

## TL;DR

```console
helm repo add retsamedoc https://retsamedoc.github.io/helm-charts/
helm repo update
helm install otbr retsamedoc/otbr
```

## Installing the Chart

To install the chart with the release name `otbr`

```console
helm install otbr retsamedoc/otbr
```

A default install is safe to render. It does **not** form a Thread network. Attach the pod to the LAN with ipvlan, macvlan, or hostNetwork, then set the radio and `OT_INFRA_IF`. See Custom configuration.

## Uninstalling the Chart

To uninstall the `otbr` deployment

```console
helm uninstall otbr
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.
Other values may be used from the [values.yaml](https://github.com/retsamedoc/helm-charts/tree/main/charts/common/values.yaml) from the [common library](https://github.com/retsamedoc/helm-charts/tree/main/charts/common).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install otbr \
  --set controllers.main.pod.hostNetwork=true \
    retsamedoc/otbr
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install otbr retsamedoc/otbr -f values.yaml
```

## Custom configuration

A default `helm install` renders a Deployment with `hostNetwork: false` and no radio. That is intentional. It will **not** form a Thread network, and it must not be treated as a working border router.

This chart requires one of **ipvlan**, **macvlan**, or **hostNetwork**. OTBR has to create a TUN interface (`wpan0` by default), program firewall/NAT64 rules, and speak mDNS and IPv6 routing on a real infrastructure NIC. ClusterIP or Ingress cannot do that. Traefik can only front the HTTP admin UI. It does not carry Thread routing, router advertisements, or `_meshcop._udp`. Wired Ethernet is fine. Set `OT_INFRA_IF` to that NIC (`eth0`, `enp*`, …). The image default `wlan0` is only a Raspberry Pi default, not a requirement.

### Radio coprocessor

The official image reads `OT_RCP_DEVICE` (default if unset: `spinel+hdlc+uart:///dev/ttyACM0?uart-baudrate=1000000`). Mount that character device with a common-library `hostPath` volume (`hostPathType: CharDevice`) and use the same path in the URL. Many nRF52840 dongles appear as `/dev/ttyACM0`; some Silicon Labs sticks appear as `/dev/ttyUSB0`. Also mount `/dev/net/tun` so `otbr-agent` can create the Thread interface.

The official `docker run` adds `NET_ADMIN`. `NET_RAW` is often required as well for packet/firewall setup. `privileged: true` is a fallback when the runtime will not allow those device nodes. Pin the pod to the node that has the dongle (`nodeSelector` / `nodeName`). Do not run this on every node.

### Backbone interface

The official container uses `OT_INFRA_IF` (image default `wlan0`). Native setup scripts call the same NIC `INFRA_IF_NAME`. Some third-party images use `BACKBONE_INTERFACE`; **this image does not read that variable**. Set `OT_INFRA_IF` to the k3s node's infrastructure interface (often `eth0` on an appliance, or `enp*` / `wlan0` on a PC). It must not be the Thread interface (`OT_THREAD_IF`, default `wpan0`).

### LAN attachment (ipvlan, macvlan, or hostNetwork)

Pick one. This chart does not create the extra CNI network. A stock pod interface is not a substitute.

- **hostNetwork** is the simplest path on k3s and matches the official Docker `--network=host` setup. The pod uses the node's network namespace, so `OT_INFRA_IF` is a real NIC on that node (`eth0` on a wired box). The common library sets `dnsPolicy` to `ClusterFirstWithHostNet` when `hostNetwork` is true. With hostNetwork, the Service is unused for normal access. Browse `http://<node-ip>:8080`. Do not put a LoadBalancer on this Service. k3s ServiceLB would claim host ports and add iptables on the node OTBR is already programming. Leave Traefik out of this path unless you only want a hostname for the UI.
- **macvlan** or **ipvlan** attaches a secondary interface onto the node's Ethernet (or the LAN bridge) so the pod is a neighbor on that LAN without taking the whole host network namespace. Set `OT_INFRA_IF` to the name of that interface inside the pod. You still need `NET_ADMIN`, `/dev/net/tun`, the radio device, and the same host forwarding/RA sysctls on the parent NIC. Create the attachment with Multus or an equivalent. This chart only consumes it.

The web UI listens on **8080** and the REST API on **8081**. Both default to `127.0.0.1`. Set `OT_WEB_LISTEN_ADDR=0.0.0.0` (and match REST if the topology view should be reachable off-box). The web UI's topology client calls port 8081 on the same host.

Without one of those attachments, `kubectl port-forward` to 8080/8081 can reach a process that happens to be running, but routing, NAT64, and commissioning will not work.

### Persistence

The entrypoint creates `/data/thread` and symlinks `/var/lib/thread` to it. Persist **`/data`** (official docker bind is `/var/lib/otbr:/data`). Without that volume the Thread dataset is lost on restart and the border router forms a new network. A local-path PVC is enough if the pod stays on one node; a `hostPath` of `/var/lib/otbr` matches the upstream docker example.

### Node sysctls (NAT64 / forwarding)

The official docker guide runs `etc/docker/border-router/setup-host` on the **host** before the container. That writes:

- `net.ipv4.ip_forward = 1`
- `net.ipv6.conf.all.forwarding = 1`
- `net.ipv6.conf.<OT_INFRA_IF>.accept_ra = 2`
- `net.ipv6.conf.<OT_INFRA_IF>.accept_ra_rt_info_max_plen = 64`

The common library can render `controllers.main.pod.securityContext.sysctls`, but these are unsafe and interface-specific. k3s rejects them unless the kubelet allows them, and they apply to the host netns when `hostNetwork` is true. Apply `setup-host` (or an equivalent sysctl drop-in) on the node, with `INFRA_IF_NAME` set to the same value as `OT_INFRA_IF`. NAT64 itself is built into the image (`192.168.255.0/24`) and is configured by the entrypoint once `NET_ADMIN` and forwarding are in place.

Keep the chart defaults (sleep is only for `ci/ct-values.yaml`) until those host requirements are met.

## Values

**Important**: When deploying an application Helm chart you can add more values from the common library chart [here](https://github.com/retsamedoc/helm-charts/tree/main/charts/common)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| controllers.main.containers.main.env | object | See below | environment variables. |
| controllers.main.containers.main.env.TZ | string | `"UTC"` | Set the container timezone |
| controllers.main.containers.main.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| controllers.main.containers.main.image.repository | string | `"openthread/border-router"` | image repository |
| controllers.main.containers.main.image.tag | string | `"v2026.09.0"` | image tag |
| controllers.main.pod.hostNetwork | bool | `false` | Use the node network namespace. One of ipvlan, macvlan, or hostNetwork is required for a working border router. Default false so the chart renders without a radio. |
| persistence | object | See values.yaml | Configure persistence settings for the chart under this key. |
| service | object | See values.yaml | Configures service settings for the chart. Unused in the supported hostNetwork mode; kept for non-hostNetwork experiments. |

## Support

- Open an [issue](https://github.com/retsamedoc/helm-charts/issues/new/choose)
