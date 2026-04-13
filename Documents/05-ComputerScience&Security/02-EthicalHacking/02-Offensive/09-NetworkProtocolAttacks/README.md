# Network Protocol Attacks - Curriculum

For authorized internal pentesting on networks you own or have explicit permission to test.

---

## Module 1: Layer 2 Attacks
- [ ] **ARP spoofing**: send fake ARP replies → MITM between victim and gateway
  - [ ] Tool: `arpspoof` (dsniff), `ettercap`, `bettercap`
  - [ ] Enable IP forwarding: `echo 1 > /proc/sys/net/ipv4/ip_forward`
  - [ ] Sniff traffic with Wireshark/tcpdump after MITM
- [ ] **MAC flooding**: fill switch CAM table → switch fails open (acts as hub)
  - [ ] Tool: `macof`
- [ ] **VLAN hopping**:
  - [ ] **Switch spoofing**: pretend to be a switch to access all VLANs
  - [ ] **Double tagging**: nested 802.1Q tags → traffic reaches other VLAN
- [ ] **STP attacks**: become root bridge, intercept traffic
- [ ] **Defense**: port security, DHCP snooping, dynamic ARP inspection, BPDU guard

## Module 2: DHCP & DNS Attacks
- [ ] **DHCP starvation**: exhaust DHCP pool → legitimate clients can't connect
- [ ] **DHCP spoofing**: rogue DHCP server → clients get malicious DNS/gateway
- [ ] **DNS spoofing**: fake DNS response to redirect traffic
  - [ ] Tool: `dnsspoof`, Ettercap, Bettercap
- [ ] **DNS cache poisoning**: Kaminsky attack (historical, mostly patched)
- [ ] **Rogue DNS**: after MITM, respond to DNS queries with attacker IPs
- [ ] **DNS rebinding**: bypass same-origin policy by changing DNS resolution
- [ ] **Defense**: DHCP snooping, DNSSEC, static DNS on sensitive hosts

## Module 3: LLMNR, NBT-NS, mDNS Poisoning
- [ ] **LLMNR** (Link-Local Multicast Name Resolution): Windows fallback name resolution
- [ ] **NBT-NS** (NetBIOS Name Service): legacy Windows name resolution
- [ ] **mDNS**: multicast DNS (used by macOS/Linux)
- [ ] **Attack**: respond to broadcast queries → victim sends NTLM hash to attacker
- [ ] **Tool**: **Responder** — the go-to tool
  - [ ] `sudo responder -I eth0 -wrf`
  - [ ] Captures NTLM hashes for offline cracking
- [ ] **NTLM relay**: combine with ntlmrelayx for direct authentication (no cracking)
- [ ] **Defense**: disable LLMNR via GPO, disable NetBIOS, SMB signing

## Module 4: Network Sniffing & MITM
- [ ] **Passive sniffing**: on switched network, only see broadcast + your traffic
- [ ] **Active sniffing**: ARP spoof or port mirror to see all traffic
- [ ] **Wireshark**: capture filters (`tcp port 80`), display filters (`http.request`)
- [ ] **tcpdump**: command-line sniffer, `-w file.pcap`
- [ ] **SSL/TLS MITM**: requires installing attacker CA cert on victim (not trivial)
  - [ ] Tool: `mitmproxy`, Burp Suite
- [ ] **Credential interception**: HTTP basic auth, FTP, Telnet, legacy protocols
- [ ] **Session hijacking**: steal session cookies from unencrypted traffic
- [ ] **Defense**: TLS everywhere, HSTS, certificate pinning

## Module 5: Wireless-Adjacent (Wired Network Focus)
- [ ] **Rogue Access Point**: create wifi AP to capture credentials (awareness only)
- [ ] **Captive portal attacks**: awareness of how they work
- [ ] **Port scanning stealthy**: nmap timing templates, decoys, fragmenting packets
- [ ] **Firewall evasion**: `-f` (fragment), `--mtu`, `-D` (decoys), `--source-port`
- [ ] **IPv6 attacks**: mitm6 → rogue IPv6 DHCP → NTLM relay
  - [ ] Tool: `mitm6.py`
  - [ ] Often overlooked by defenders, high-impact

## Module 6: Tools & Methodology
- [ ] **Responder**: NTLM hash capture, rogue auth servers
- [ ] **Impacket**: `ntlmrelayx.py`, `smbrelayx.py`
- [ ] **Bettercap**: modern MITM framework (replaces Ettercap)
- [ ] **Mitm6**: IPv6 attacks
- [ ] **CrackMapExec / NetExec**: Swiss-army knife for internal pentesting
- [ ] **Nmap**: host discovery, port scanning, NSE scripts
- [ ] **Wireshark / tcpdump**: always-on for analysis
- [ ] **Methodology**: passive listen → identify targets → active sniff/spoof → capture → relay/crack

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Set up a lab network with 3 VMs, practice ARP spoofing, observe in Wireshark |
| Module 2 | Run a rogue DHCP in an isolated lab network |
| Module 3 | Responder lab in TryHackMe, capture NTLM hash, crack with hashcat |
| Module 4 | Wireshark capture exercises (capture the flag in PCAP) |
| Module 5 | mitm6 + ntlmrelayx in a lab AD environment |
| Module 6 | TryHackMe "Network Services" rooms, HackTheBox Academy network modules |

## Key Resources
- **HackTheBox Academy — Network Attacks module**
- **TryHackMe — Network Services paths**
- **Responder** (github.com/lgandx/Responder)
- **Impacket** (github.com/fortra/impacket)
- **Bettercap** (bettercap.org)
- **HackTricks — Pentesting Network pages**
- **ired.team — Network attacks**
- "The Hacker Playbook" series — Peter Kim
