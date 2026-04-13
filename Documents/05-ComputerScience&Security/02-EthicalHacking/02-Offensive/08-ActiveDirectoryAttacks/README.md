# Active Directory Attacks - Curriculum

For authorized pentesting, OSCP/CRTP preparation, and corporate red team engagements. Only test environments you have explicit permission for.

---

## Module 1: AD Fundamentals
- [ ] **What is Active Directory?** Microsoft's identity and access management for Windows networks
- [ ] **Domain**: group of computers sharing a directory database
- [ ] **Forest**: collection of domains sharing schema and global catalog
- [ ] **Domain Controller (DC)**: server hosting AD database
- [ ] **OU (Organizational Unit)**: logical grouping for management
- [ ] **GPO (Group Policy Object)**: policies applied to users/computers
- [ ] **Trust relationships**: between domains and forests
- [ ] **LDAP**: protocol to query AD
- [ ] **Kerberos**: primary authentication protocol
- [ ] **NTLM**: legacy authentication (still widely used)
- [ ] **SYSVOL**: shared folder on DC containing GPOs

## Module 2: Enumeration
- [ ] **Goal**: map domain users, groups, computers, GPOs, trusts, ACLs
- [ ] **From Windows (domain-joined)**:
  - [ ] `net user /domain`, `net group /domain`, `net localgroup /domain`
  - [ ] `PowerView`: `Get-NetUser`, `Get-NetGroup`, `Get-NetComputer`, `Get-NetDomain`
  - [ ] `AdFind.exe`, `SharpHound.exe`
- [ ] **From Linux**:
  - [ ] `ldapsearch`, `rpcclient`, `enum4linux`, `enum4linux-ng`
  - [ ] `bloodhound-python` / `bloodhound.py`
  - [ ] `impacket` suite: `GetADUsers.py`, `GetNPUsers.py`, `GetUserSPNs.py`
- [ ] **BloodHound**: visualize attack paths, find shortest path to Domain Admin
  - [ ] Collect with SharpHound (Win) or bloodhound.py (Linux)
  - [ ] Queries: "Shortest Paths to Domain Admins", "Find Kerberoastable Accounts"
- [ ] **Null sessions**: anonymous SMB access (rare but possible)

## Module 3: Kerberos Attacks
- [ ] **Kerberos flow** (simplified):
  1. Client → KDC: request TGT (Ticket Granting Ticket)
  2. Client → KDC: request TGS (service ticket) using TGT
  3. Client → Service: present TGS
- [ ] **Kerberoasting**: request service tickets, crack offline to get service account password
  - [ ] Tool: `GetUserSPNs.py`, Rubeus
  - [ ] Crack with hashcat mode 13100
  - [ ] Target: service accounts with weak passwords
- [ ] **ASREPRoasting**: users with "Do not require Kerberos preauthentication" set
  - [ ] Tool: `GetNPUsers.py`, Rubeus
  - [ ] Crack with hashcat mode 18200
- [ ] **Pass-the-Ticket**: use stolen Kerberos ticket on another machine
- [ ] **Golden Ticket**: forge TGT with compromised `krbtgt` hash → domain-wide access
- [ ] **Silver Ticket**: forge TGS for specific service
- [ ] **Diamond / Sapphire Ticket**: advanced TGT forging
- [ ] **Kerberos delegation abuse**: unconstrained, constrained, resource-based constrained delegation
- [ ] **Defense**: strong service account passwords, LAPS, protected users group, AES-only

## Module 4: NTLM Attacks
- [ ] **NTLM authentication flow**: challenge-response with hash
- [ ] **NTLM relay**: MITM → relay auth to another server
  - [ ] Tool: `ntlmrelayx.py` (impacket)
  - [ ] Common: relay to LDAP, SMB, MSSQL, HTTP endpoints
- [ ] **LLMNR / NBT-NS poisoning**: respond to broadcast name resolution → capture NTLM hashes
  - [ ] Tool: Responder
  - [ ] Combine with ntlmrelayx for relay attacks
- [ ] **Pass-the-Hash**: authenticate with NTLM hash instead of password
  - [ ] Tool: `wmiexec.py`, `psexec.py`, `evil-winrm`
- [ ] **Offline cracking**: hashcat mode 1000 (NTLM)
- [ ] **Defense**: disable NTLMv1, SMB signing, LDAP signing, disable LLMNR/NBT-NS

## Module 5: Credential Dumping & Lateral Movement
- [ ] **Mimikatz** (authorized use only):
  - [ ] `sekurlsa::logonpasswords` — extract creds from LSASS
  - [ ] `lsadump::sam` — local SAM database
  - [ ] `lsadump::dcsync` — simulate DC replication to dump all hashes
- [ ] **DCSync attack**: abuse Replicating Directory Changes permission to dump NTDS.dit
- [ ] **DCShadow**: register rogue DC to inject changes
- [ ] **Lateral movement**:
  - [ ] PsExec, wmiexec, smbexec (impacket)
  - [ ] WinRM: `evil-winrm`
  - [ ] RDP: `xfreerdp`, mstsc
  - [ ] DCOM lateral movement
- [ ] **Token impersonation**: use SeImpersonate to act as other users
- [ ] **Defense**: Credential Guard, LSA Protection, LAPS, least privilege

## Module 6: ACL & Delegation Abuse
- [ ] **ACL abuse**: rights like `GenericAll`, `GenericWrite`, `WriteDacl`, `WriteOwner`, `ForceChangePassword`
- [ ] **BloodHound queries** highlight ACL-based paths
- [ ] **Shadow Credentials**: add alt creds to msDS-KeyCredentialLink attribute
- [ ] **Unconstrained delegation**: server can impersonate any user to any service — catastrophic
- [ ] **Constrained delegation**: limited but still dangerous
- [ ] **Resource-based constrained delegation (RBCD)**: modern attack vector
- [ ] **Tool**: Rubeus, Impacket, SharpAllowedToAct

## Module 7: AD Certificate Services (ADCS) Attacks
- [ ] **ESC1-ESC15**: Certified Pre-Owned research vulnerabilities
- [ ] **Certipy / Certify**: enumeration and exploitation tools
- [ ] Common attacks: template misconfiguration → request cert as Domain Admin
- [ ] **Defense**: secure templates, audit certificate issuance

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | TryHackMe "Active Directory Basics", HackTheBox Academy AD Enumeration & Attacks module |
| Module 3 | TryHackMe "Attacktive Directory", kerberoasting lab |
| Module 4 | TryHackMe "NTLM Relay", Responder lab |
| Module 5 | HackTheBox Pro Labs: Dante, Offshore, RastaLabs |
| Module 6 | BloodHound queries on vulnerable AD lab (GOAD — Game of Active Directory) |
| Module 7 | HackTheBox ADCS-focused machines |

## Key Resources
- **GOAD (Game of Active Directory)** — free vulnerable AD lab (github.com/Orange-Cyberdefense/GOAD)
- **HackTheBox Pro Labs** — full AD environments
- **TryHackMe AD path**
- **HackTheBox Academy** AD modules (paid, high quality)
- **ired.team** — AD attack reference wiki
- **HackTricks AD section**
- **"Certified Pre-Owned"** paper (SpecterOps)
- **BloodHound documentation** (bloodhound.readthedocs.io)
- **Impacket** suite — standard toolkit
