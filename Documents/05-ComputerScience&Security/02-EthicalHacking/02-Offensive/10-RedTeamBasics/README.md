# Red Team Basics & MITRE ATT&CK - Curriculum

For authorized red team engagements, OSCP/CRTP/OSEP preparation, and defensive threat modeling. All activities require written authorization from the target organization.

---

## Module 1: Red Team vs Pentest
- [ ] **Penetration testing**: find as many vulnerabilities as possible in defined scope
- [ ] **Red team**: simulate real adversary to test detection and response capabilities
- [ ] **Purple team**: red + blue collaboration, improve both offense and defense
- [ ] Red team focuses on **objectives** (e.g., "access customer database") not vulnerabilities
- [ ] Red team includes stealth, persistence, evasion — pentest usually doesn't
- [ ] **Rules of engagement (RoE)**: scope, time windows, out-of-scope, communication plan, emergency stop
- [ ] **Legal**: written authorization is mandatory — "get out of jail free" letter

## Module 2: MITRE ATT&CK Framework
- [ ] **MITRE ATT&CK**: globally-accessible knowledge base of adversary tactics and techniques
- [ ] **Matrix structure**: Tactics (columns) × Techniques (rows)
- [ ] **14 tactics**:
  1. Reconnaissance
  2. Resource Development
  3. Initial Access
  4. Execution
  5. Persistence
  6. Privilege Escalation
  7. Defense Evasion
  8. Credential Access
  9. Discovery
  10. Lateral Movement
  11. Collection
  12. Command and Control
  13. Exfiltration
  14. Impact
- [ ] **Techniques and sub-techniques**: specific methods (e.g., T1055 Process Injection)
- [ ] **ATT&CK for Enterprise, Mobile, ICS, Cloud**
- [ ] **Threat groups**: APT29, APT28, FIN7 — real adversaries and their TTPs
- [ ] **Navigator**: visualize tactics/techniques used by groups
- [ ] **Use for defense**: map detection coverage, identify gaps

## Module 3: Initial Access
- [ ] **Spearphishing**: email with malicious attachment or link (authorized engagements only)
- [ ] **Drive-by compromise**: malicious websites, watering hole attacks (defensive study)
- [ ] **Supply chain**: compromised software updates (awareness)
- [ ] **Valid accounts**: leaked credentials, credential stuffing
- [ ] **Exposed services**: RDP, SSH, VPN with weak auth
- [ ] **Exploitation of public-facing apps**: the web vulnerabilities covered earlier
- [ ] **Physical access**: USB drops, rogue access (pentest scope dependent)

## Module 4: Execution & Persistence
- [ ] **Execution techniques**:
  - [ ] Command & Scripting Interpreter (PowerShell, Bash, WMI)
  - [ ] User Execution (social engineering)
  - [ ] Scheduled Task
  - [ ] Windows Management Instrumentation
- [ ] **Persistence techniques**:
  - [ ] Registry Run Keys / Startup folder
  - [ ] Scheduled Tasks
  - [ ] Windows Services
  - [ ] Account creation
  - [ ] SSH keys (Linux)
  - [ ] Cron jobs (Linux)
- [ ] **Purpose of studying persistence**: detection and defense, not malicious persistence

## Module 5: Defense Evasion (Awareness)
- [ ] **Process injection**: inject code into legitimate process
- [ ] **Fileless malware**: in-memory execution, no disk artifacts
- [ ] **Living Off the Land Binaries (LOLBAS / GTFOBins)**: abuse legitimate tools to avoid detection
- [ ] **Obfuscation**: base64, hex encoding, string manipulation
- [ ] **Timestomping**: modify file timestamps
- [ ] **Log clearing**: events that defenders would rely on
- [ ] **AMSI bypass** (awareness): understand how malware evades Windows Defender
- [ ] **Purpose**: defenders need to know these to detect; study for blue team effectiveness

## Module 6: Command & Control (C2) — Conceptual
- [ ] **C2 architecture**: implant on target → callbacks to operator server
- [ ] **C2 channels**: HTTP(S), DNS, ICMP, named pipes, SMB
- [ ] **Beaconing**: periodic check-ins to avoid always-on traffic patterns
- [ ] **C2 frameworks** (awareness for defense):
  - [ ] Cobalt Strike (commercial, widely abused by real adversaries)
  - [ ] Sliver (open source, Go-based)
  - [ ] Mythic (open source, multi-language)
  - [ ] Havoc, Brute Ratel, Metasploit
- [ ] **Detection**: JA3 fingerprinting, beaconing analysis, C2 domain intelligence
- [ ] **Use in authorized engagements only** — treat as operational tools, not toys

## Module 7: Lateral Movement & Discovery
- [ ] **Discovery**: AD enumeration (covered in topic 08), network scanning, process discovery
- [ ] **Lateral movement techniques**:
  - [ ] Remote Services: RDP, SSH, WinRM
  - [ ] SMB / Admin Shares
  - [ ] Pass-the-Hash / Pass-the-Ticket (covered in topic 08)
  - [ ] WMI, DCOM
  - [ ] Exploitation of remote services
- [ ] **Pivoting**: SSH tunneling, Chisel, Ligolo-ng, Proxychains

## Module 8: Reporting & Purple Teaming
- [ ] **Engagement reporting**: executive summary, technical findings, reproduction steps, remediation
- [ ] **Narrative**: tell the story of the attack path from initial access to objective
- [ ] **Detection opportunities**: what could have detected each step? Map to ATT&CK
- [ ] **Purple team exercises**: red runs attack, blue watches detection, gaps identified, rules written
- [ ] **Atomic Red Team** (Red Canary): library of small tests mapped to ATT&CK techniques
- [ ] **Caldera**: automated red team platform by MITRE
- [ ] **Healthy mindset**: red team exists to HELP the organization, not to "win"

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 2 | Study APT29 on ATT&CK Navigator, understand their TTPs |
| Modules 3-5 | TryHackMe "Red Team Path" rooms |
| Module 6 | Deploy Sliver in a lab environment, practice authorized beacon operations |
| Module 7 | HackTheBox Pro Labs: RastaLabs, Offshore — full red team scenarios |
| Module 8 | Write a simulated engagement report for an HTB box as if it were a pentest |

## Key Resources
- **MITRE ATT&CK** (attack.mitre.org) — THE framework
- **ATT&CK Navigator** (mitre-attack.github.io/attack-navigator)
- **Atomic Red Team** (atomicredteam.io)
- **HackTheBox Pro Labs** — RastaLabs, Offshore, Dante, APTLabs, Cybernetics
- **TryHackMe Red Team Path**
- **"Red Team Development and Operations"** - Joe Vest & James Tubberville
- **"The Hacker Playbook 3"** - Peter Kim
- **SpecterOps blog** — red team research
- **ired.team** — red team wiki
- **Certifications**: OSEP (Offensive Security), CRTO (Zero-Point Security), CRTP/CRTE (Altered Security)

---

## Important: Legal & Ethical Reminder
- [ ] **Written authorization is mandatory** for any security testing
- [ ] **Scope defines legality**: out-of-scope = illegal
- [ ] **Your test environment is always legal**: home lab, HackTheBox, TryHackMe, HTB Academy
- [ ] **Never test production systems** without explicit, signed authorization
- [ ] **Responsible disclosure**: found a vuln in the wild? Follow the disclosure process
- [ ] **When in doubt**: don't. Ask.
