# <img src="images/EIA Logo FINAL small_Round.png" alt="EIA Logo" style="zoom:15%; float:right; margin-left:8px;" />

# NX-OS vs IOS-XE vs EOS — CLI & Configuration Quick Reference

A quick-reference comparison for network engineers working across Cisco NX-OS, Cisco IOS-XE, and Arista EOS platforms, focused on CLI and configuration differences.

> This guide uses Arista EOS as the third platform. If you're working with the containerized variant (cEOS), the CLI and configuration are identical — see [cEOS vs EOS: What's Different?](#ceos-vs-eos-whats-different) for the key distinctions.

---

[TOC]

---

## Platform Overview

| | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| **Vendor** | Cisco | Cisco | Arista |
| **Typical Role** | Data center (Nexus switches) | Campus, WAN, routing (Catalyst, ISR, ASR) | Data center, campus, routing (7000/7500 series, 720X, cEOS for labs) |
| **Underlying OS** | Linux kernel (custom userspace) | Linux kernel (IOS runs as a daemon via IOSd) | Linux kernel (single-binary, fully accessible shell) |
| **Config Model** | Session-based or immediate | Immediate (running-config) | Session-based (commit) or immediate |
| **API / Automation** | NX-API (REST/JSON-RPC) | RESTCONF, NETCONF, gNMI | eAPI (JSON-RPC), NETCONF, gNMI |
| **Default CLI Style** | NX-OS CLI (similar to IOS but diverges) | Classic IOS CLI | Arista EOS CLI (similar to IOS but diverges) |

---

## Mode Navigation

| Action | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| Enter privileged exec | `enable` | `enable` | `enable` |
| Enter global config | `configure terminal` | `configure terminal` | `configure`<br /> (Note" `config t ` does work as well) |
| Enter interface config | `interface Ethernet1/1` | `interface GigabitEthernet1/0/1` | `interface Ethernet1` |
| Exit current mode | `exit` | `exit` | `exit` |
| Return to priv exec | `end` | `end` | `end` |
| Config session (named) | `configure session <name>` | N/A | `configure session <name>` |
| Commit session | `commit` | N/A | `commit` |
| Abort session | `abort` | N/A | `abort` |

---

## Interface Naming

| Platform | Physical Format | Loopback | VLAN SVI | Port-Channel |
|---|---|---|---|---|
| **NX-OS** | `Ethernet1/1` | `loopback0` | `interface Vlan10` | `port-channel1` |
| **IOS-XE** | `GigabitEthernet1/0/1, TenGigabitEtherent1/0/1,`<br />TwoGigabitEthernet1/0/1`,`<br />`TwentyFiveGigE1/0/1, `<br />`HundredGigE1/0/25` | `Loopback0` | `interface Vlan10` | `Port-channel1` |
| **EOS** | `Ethernet1` | `Loopback0` | `interface Vlan10` | `Port-Channel1` |

---

## Show Commands

| Purpose | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| Running config | `show running-config` | `show running-config` | `show running-config` |
| Interface summary | `show ip interface brief` | `show ip interface brief` | `show ip interface brief` |
| BGP summary | `show bgp ipv4 unicast summary` | `show bgp ipv4 unicast summary` | `show ip bgp summary` |
| OSPF neighbors | `show ip ospf neighbors` | `show ip ospf neighbor` | `show ip ospf neighbor` |
| Routing table | `show ip route` | `show ip route` | `show ip route` |
| MAC address table | `show mac address-table` | `show mac address-table` | `show mac address-table` |
| LLDP neighbors | `show lldp neighbors` | `show lldp neighbors` | `show lldp neighbors` |
| Version/platform | `show version` | `show version` | `show version` |
| VRF info | `show vrf` | `show vrf` | `show vrf` |

---

## Save & Copy Configuration

| Action | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| Save running to startup | `copy running-config startup-config` | `copy running-config startup-config` (or `write memory`) | `copy running-config startup-config` (or `write memory`) |
| View startup config | `show startup-config` | `show startup-config` | `show startup-config` |
| Config rollback | `rollback running-config checkpoint <name>` | `configure replace flash:backup.cfg` | `configure replace flash:backup` or session rollback |
| Checkpoint (NX-OS) | `checkpoint <name>` | N/A | N/A |



### Enable a Feature (NX-OS specific)

NX-OS requires explicit feature enablement before using many protocols:

```
feature bgp
feature ospf
feature interface-vlan
```

IOS-XE and EOS do not require this step — protocols are available by default.

---

## Common Configuration Tasks

### Assign an IP Address

| Platform | Command |
|---|---|
| **NX-OS** | `interface Ethernet1/1` → `no switchport` → `ip address 10.0.0.1/24` |
| **IOS-XE** | `interface GigabitEthernet1/0/1` → `no switchport` → `ip address 10.0.0.1 255.255.255.0` |
| **EOS** | `interface Ethernet1` → `no switchport` → `ip address 10.0.0.1/24` |

> Note: NX-OS and EOS use CIDR notation (`/24`). IOS-XE uses dotted-decimal subnet masks.

## VLAN Creation

| Platform | Command |
|---|---|
| **NX-OS** | `vlan 10` → `name DATA` |
| **IOS-XE** | `vlan 10` → `name DATA` |
| **EOS** | `vlan 10` → `name DATA` |

> VLANs are largely identical across all three platforms.

---

## Port-Channel / EtherChannel / MLAG

Each platform uses a different terminology and approach for link aggregation and multi-chassis redundancy.

### Terminology

| Concept | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| **Link aggregation** | Port-channel | EtherChannel (Port-channel) | Port-Channel |
| **Aggregation protocol** | LACP or static | LACP, PAgP, or static | LACP or static |
| **Multi-chassis redundancy** | vPC (Virtual Port-Channel) | StackWise Virtual / VSS | MLAG (Multi-Chassis Link Aggregation) |
| **Enable feature** | `feature vpc` / `feature lacp` | (always available per license) | (always available per license) |
| **Management** | Switch Level (2 switches) | One Logical Switch | Switch Level (2 switches) |



### Basic Port-Channel Configuration

**NX-OS:**

```
feature lacp
interface Ethernet1/1
  channel-group 10 mode active

interface port-channel10
  switchport mode trunk
```

**IOS-XE:**
```
interface GigabitEthernet1/0/1
  channel-group 10 mode active

interface Port-channel10
  switchport mode trunk
```

**EOS:**
```
interface Ethernet1
  channel-group 10 mode active

interface Port-Channel10
  switchport mode trunk
```

### Multi-Chassis Redundancy

These features allow a downstream device to form a single port-channel across two upstream switches for redundancy without STP blocking.

**NX-OS — vPC:**
```
feature vpc
feature lacp

vpc domain 1
  role priority 1000
  peer-keepalive destination 10.0.0.2 source 10.0.0.1
  peer-gateway

interface port-channel100
  vpc peer-link

interface port-channel10
  vpc 10
```

**IOS-XE — SVL StackWise Virtual (Catalyst 9000 example):**

```
stackwise-virtual
  domain 1
  dual-active detection pagp

interface TenGigabitEthernet1/0/1
  stackwise-virtual link 1
```
> Once StackWise Virtual is formed, the two switches act as a single logical switch. Standard EtherChannel config is used on downstream-facing port-channels — no per-port-channel vPC/MLAG-style binding is needed.

**EOS — MLAG:**
```
vlan 4094
  trunk group MLAGPEER

no spanning-tree vlan-id 4094

interface Vlan4094
  ip address 10.255.255.1/30
  no autostate

interface Port-Channel1000
  switchport mode trunk
  switchport trunk group MLAGPEER

mlag configuration
  domain-id MLAG1
  local-interface Vlan4094
  peer-address 10.255.255.2
  peer-link Port-Channel1000

interface Port-Channel10
  mlag 10
```

### Show Commands for Link Aggregation

| Purpose | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| Port-channel summary | `show port-channel summary` | `show etherchannel summary` | `show port-channel dense` |
| Brief status | N/A | N/A | `show port-channel brief` |
| Port-channel detail | `show port-channel database` | `show etherchannel detail` | `show port-channel detailed` |
| Active members | N/A | N/A | `show port-channel active-ports` |
| All configured ports | N/A | N/A | `show port-channel all-ports` |
| Load balancing | N/A | N/A | `show port-channel load-balance` |
| LACP neighbors | `show lacp neighbor` | `show lacp neighbor` | `show lacp neighbor` |
| Multi-chassis status | `show vpc` | `show stackwise-virtual` | `show mlag` |
| Multi-chassis detail | `show vpc brief` | `show stackwise-virtual dual-active-detection` | `show mlag detail` |

> EOS deprecates both `show etherchannel` and `show port-channel summary` — use `show port-channel dense` instead. EOS sub-commands include: `dense` (compact summary), `brief` (active/inactive ports with reasons), `detailed` (full status), `active-ports`, `all-ports`, `load-balance`, and `limits`.

### Key Differences

| Difference | Details |
|---|---|
| **Keyword: `channel-group` vs interface name** | All three use `channel-group` under the physical interface, but the resulting logical interface name differs: `port-channel` (NX-OS), `Port-channel` (IOS-XE), `Port-Channel` (EOS). Case matters in scripts. |
| **PAgP** | Only IOS-XE supports PAgP (Cisco proprietary). NX-OS and EOS support LACP only (or static). |
| **vPC requires features** | NX-OS needs `feature vpc` and `feature lacp` enabled. vPC also requires a dedicated peer-keepalive link and peer-link configuration. |
| **MLAG peer link** | EOS MLAG uses a dedicated VLAN (commonly 4094) with a trunk group for the peer link — a pattern unique to Arista. |
| **StackWise Virtual** | IOS-XE's approach merges two physical switches into one logical switch at the control plane, so downstream port-channels are standard EtherChannel — no per-channel binding keyword like `vpc` or `mlag`. |
| **LACP system priority** | Default LACP system priority differs across platforms. Explicitly set it when mixing vendors or when deterministic behavior is required. |

---

## Trunking

All three platforms support 802.1Q VLAN trunking but differ in syntax and default behavior.

### Trunk Configuration

**NX-OS:**
```
interface Ethernet1/1
  switchport
  switchport mode trunk
  switchport trunk allowed vlan 10,20,30
  switchport trunk native vlan 99
```

**IOS-XE:**
```
interface GigabitEthernet1/0/1
  switchport mode trunk
  switchport trunk encapsulation dot1q
  switchport trunk allowed vlan 10,20,30
  switchport trunk native vlan 99
```

**EOS:**
```
interface Ethernet1
  switchport
  switchport mode trunk
  switchport trunk allowed vlan 10,20,30
  switchport trunk native vlan 99
```

### Access Port Configuration

**NX-OS:**
```
interface Ethernet1/2
  switchport
  switchport mode access
  switchport access vlan 10
```

**IOS-XE:**
```
interface GigabitEthernet1/0/2
  switchport mode access
  switchport access vlan 10
```

**EOS:**
```
interface Ethernet2
  switchport
  switchport mode access
  switchport access vlan 10
```

### Show Commands for Trunking

| Purpose | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| Trunk summary | `show interface trunk` | `show interfaces trunk` | `show interfaces trunk` |
| Switchport detail | `show interface Ethernet1/1 switchport` | `show interfaces GigabitEthernet1/0/1 switchport` | `show interfaces Ethernet1 switchport` |
| Allowed VLANs | `show interface trunk` (includes allowed list) | `show interfaces trunk` (includes allowed list) | `show interfaces trunk` (includes allowed list) |

### Key Differences

| Difference | Details |
|---|---|
| **`switchport trunk encapsulation dot1q`** | Required on IOS-XE platforms that support both ISL and 802.1Q (older Catalysts). Not needed on platforms that only support 802.1Q. NX-OS and EOS always use 802.1Q — no encapsulation command exists. |
| **Default switchport mode** | NX-OS defaults interfaces to L3 (routed) — you must explicitly enter `switchport` before `switchport mode trunk/access`. IOS-XE defaults to `switchport` (L2). EOS defaults to L3 on some platforms — check with `show interfaces status`. |
| **`switchport` command** | Explicit on NX-OS and EOS to switch an interface from L3 to L2. On IOS-XE, interfaces are L2 by default so `switchport` is implicit. |
| **Trunk groups (EOS)** | EOS supports `trunk group` — a named set of trunk interfaces for a VLAN. This is commonly used with MLAG peer links and VXLAN. NX-OS and IOS-XE do not have this concept. |
| **Allowed VLAN modification** | All three support `add`/`remove`/`except` modifiers (e.g., `switchport trunk allowed vlan add 40`). Syntax is identical. |

---

## VRF Configuration

| Element | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| **Define VRF** | `vrf context MGMT` | `vrf definition MGMT` → `address-family ipv4` | `vrf instance MGMT` |
| **Assign to interface** | `vrf member MGMT` | `vrf forwarding MGMT` | `vrf MGMT` |
| **Show routes in VRF** | `show ip route vrf MGMT` | `show ip route vrf MGMT` | `show ip route vrf MGMT` |

> Note the different keywords: `vrf context` (NX-OS), `vrf definition` (IOS-XE), `vrf instance` (EOS).

---

## BGP Configuration

| Element | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| **Enable** | `feature bgp`<br />* Advantage License | (always available with license)<br />* Advantage/Premier (formerly Advanced/Enterprise Service) | (always available with license)<br />* Basic E-License |
| **Router process** | `router bgp 65001` | `router bgp 65001` | `router bgp 65001` |
| **Router ID** | `router-id 1.1.1.1` | `bgp router-id 1.1.1.1` | `router-id 1.1.1.1` |
| **Neighbor** | `neighbor 10.0.0.2 remote-as 65002` | `neighbor 10.0.0.2 remote-as 65002` | `neighbor 10.0.0.2 remote-as 65002` |
| **Address family** | `address-family ipv4 unicast` | `address-family ipv4 unicast` | `address-family ipv4 unicast` |
| **Advertise network** | `network 10.1.0.0/24` | `network 10.1.0.0 mask 255.255.255.0` | `network 10.1.0.0/24` |

---

## OSPF Configuration

| Element | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| **Enable** | `feature ospf`<br />Essentials | (always available with license) | (always available with license) |
| **Process** | `router ospf 1` | `router ospf 1` | `router ospf 1` |
| **Router ID** | `router-id 1.1.1.1` | `router-id 1.1.1.1` | `router-id 1.1.1.1` |
| **Interface assignment** | Under interface: `ip router ospf 1 area 0` | Under interface: `ip ospf 1 area 0` (or via `network` statement) | Under interface: (use `network` under router ospf or `ip ospf area`) |

---

## Static Route

| Platform   | Command                                       |
| ---------- | --------------------------------------------- |
| **NX-OS**  | `ip route 192.168.1.0/24 10.0.0.2`            |
| **IOS-XE** | `ip route 192.168.1.0 255.255.255.0 10.0.0.2` |
| **EOS**    | `ip route 192.168.1.0/24 10.0.0.2`            |



---

## VXLAN Configuration

VXLAN is used across all three platforms for network overlay and data center fabric designs, but the configuration model differs significantly.

### Terminology

| Concept | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| **Overlay interface** | `interface nve1` | `interface nve1` | `interface Vxlan1` |
| **VTEP source** | `source-interface loopback0` | `source-interface Loopback0` | `vxlan source-interface Loopback0` |
| **VNI-to-VLAN mapping** | `member vni` under nve | `member vni` under nve | `vxlan vlan <id> vni <vni>` under Vxlan1 |
| **EVPN control plane** | BGP EVPN address family | BGP EVPN address family (L2VPN EVPN) | BGP EVPN address family |
| **Enable feature** | `feature nv overlay` / `feature vn-segment-vlan-based` | (always available) | (always available) |

### Basic VXLAN with EVPN

**NX-OS:**
```
feature nv overlay
feature vn-segment-vlan-based
nv overlay evpn

vlan 10
  vn-segment 10010

interface nve1
  no shutdown
  host-reachability protocol bgp
  source-interface loopback0
  member vni 10010
    ingress-replication protocol bgp

interface loopback0
  ip address 10.255.0.1/32

router bgp 65001
  address-family l2vpn evpn
  neighbor 10.255.0.2 remote-as 65001
    address-family l2vpn evpn
      send-community extended
```

**IOS-XE:**
```
l2vpn evpn
  replication-type ingress

vlan configuration 10
  member evpn-instance 10 vni 10010

interface nve1
  no shutdown
  host-reachability protocol bgp
  source-interface Loopback0
  member vni 10010 ingress-replication

interface Loopback0
  ip address 10.255.0.1 255.255.255.255

router bgp 65001
  address-family l2vpn evpn
  neighbor 10.255.0.2 remote-as 65001
    address-family l2vpn evpn
      send-community extended
```

**EOS:**
```
interface Vxlan1
  vxlan source-interface Loopback0
  vxlan vlan 10 vni 10010

interface Loopback0
  ip address 10.255.0.1/32

router bgp 65001
  address-family evpn
  neighbor 10.255.0.2 remote-as 65001
    address-family evpn
      send-community extended

vlan 10
  name TENANT-A
```

### Show Commands for VXLAN

| Purpose | NX-OS | IOS-XE | EOS |
|---|---|---|---|
| VTEP/NVE status | `show nve peers` | `show nve peers` | `show vxlan vtep` |
| VNI mapping | `show nve vni` | `show nve vni` | `show vxlan vni` |
| NVE interface | `show interface nve1` | `show interface nve1` | `show interface Vxlan1` |
| EVPN routes | `show bgp l2vpn evpn` | `show bgp l2vpn evpn` | `show bgp evpn` |
| MAC via EVPN | `show l2route evpn mac all` | `show l2vpn evpn mac` | `show bgp evpn route-type mac-ip` |
| VXLAN counters | `show nve vni counters` | `show nve vni counters` | `show vxlan counters` |

### Key Differences

| Difference | Details |
|---|---|
| **Overlay interface name** | NX-OS and IOS-XE use `interface nve1`. EOS uses `interface Vxlan1` — there is only one VXLAN interface per switch on EOS. |
| **Feature enablement** | NX-OS requires `feature nv overlay` and `feature vn-segment-vlan-based`. IOS-XE and EOS have VXLAN available by default. |
| **VNI mapping syntax** | NX-OS maps VNI to VLAN with `vn-segment` under the VLAN. IOS-XE uses `vlan configuration` + `member evpn-instance`. EOS maps it directly under `interface Vxlan1` with `vxlan vlan <id> vni <vni>`. |
| **EVPN address family** | NX-OS and IOS-XE use `address-family l2vpn evpn`. EOS uses `address-family evpn` (no `l2vpn` prefix). |
| **Flood-and-learn vs EVPN** | All three support both static ingress-replication (flood-and-learn) and BGP EVPN control plane, but EVPN is the recommended approach on all platforms. |
| **L3 VNI (symmetric IRB)** | Each platform handles VRF-to-VNI mapping differently. NX-OS uses `vni` under `vrf context`. IOS-XE uses `vni` under `vrf definition`. EOS uses `vxlan vrf <name> vni <vni>` under `interface Vxlan1`. |

---

# cEOS vs EOS: What's Different?

cEOS (containerized EOS) shares the same CLI, configuration syntax, and control-plane software as Arista's full EOS, but there are important differences to be aware of.

| Area | Full EOS (vEOS / Hardware) | cEOS |
|---|---|---|
| **Data plane** | Full forwarding via hardware ASICs or kernel-based software forwarding (vEOS) | No data-plane forwarding — control plane only |
| **Deployment** | Runs on Arista hardware or as a full VM (vEOS) | Runs as a Docker container (minimal resource footprint) |
| **Boot time** | Minutes (full OS boot) | Seconds (container startup) |
| **Interface model** | Maps to real hardware ports or vNICs | Uses Linux veth pairs or host interfaces mapped into the container |
| **Management interface** | `Management1` (dedicated hardware port) | `Management0` (mapped to a Docker network) |
| **Platform features** | Full ASIC-based features: hardware ACLs, QoS queuing, line-rate forwarding, TCAM, hardware counters | Many platform-dependent features are absent or return empty/stub output (e.g., `show hardware`, TCAM counters, QoS queuing stats) |
| **Licensing** | Requires appropriate Arista license | Free for lab/testing/CI use |
| **Typical use case** | Production networks | Containerlab topologies, CI/CD pipeline testing, automation development, certification study |
| **Supported features** | Full feature set including MLAG, EVPN, streaming telemetry | Most control-plane features work (BGP, OSPF, IS-IS, EVPN, eAPI, gNMI). MLAG is limited without a real data plane |
| **Config compatibility** | N/A | Configurations are portable to/from full EOS with minor exceptions (management interface name, platform-specific commands) |

**Key takeaway:** If your config works on cEOS at the control-plane level, it will almost certainly work on production EOS hardware. The CLI and configuration syntax are identical — the differences are all in what happens beneath the control plane.

---

# Key Gotchas for Engineers Switching Between Platforms

| Gotcha | Details |
|---|---|
| **NX-OS `feature` requirement** | Forgetting `feature bgp`, `feature ospf`, etc. is the most common NX-OS mistake. Nothing works until you enable it. |
| **Subnet mask format** | IOS-XE uses dotted-decimal masks; NX-OS and EOS use CIDR prefix length. |
| **VRF syntax** | All three platforms use different keywords to define a VRF — easy to mix up. |
| **Interface names** | Completely different naming conventions; scripts and templates need per-platform handling. |
| **Config sessions** | NX-OS and EOS support commit-based config sessions; IOS-XE does not (it uses `configure replace` for rollback). |
| **NX-OS no `write memory`** | NX-OS traditionally uses `copy run start`; `write memory` may work on some versions but isn't always available. |
