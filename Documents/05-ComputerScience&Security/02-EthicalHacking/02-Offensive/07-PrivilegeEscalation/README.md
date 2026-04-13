# Privilege Escalation (Linux + Windows) - Curriculum

For authorized pentest engagements, CTFs, and OSCP preparation. Always operate within scope.

---

## Module 1: Linux Enumeration
- [ ] **System info**: `uname -a`, `/etc/os-release`, `cat /etc/issue`
- [ ] **Kernel version**: check against known exploits (searchsploit)
- [ ] **Current user**: `whoami`, `id`, `sudo -l`, `groups`
- [ ] **Users on system**: `/etc/passwd`, `/etc/shadow` (if readable)
- [ ] **Running processes**: `ps auxf`, `ps -ef`
- [ ] **Listening services**: `netstat -tulpn`, `ss -tulpn`
- [ ] **Network info**: `ifconfig`, `ip a`, `route`, `arp`
- [ ] **Installed software**: `dpkg -l`, `rpm -qa`
- [ ] **Environment variables**: `env`, `.bashrc`, `.profile`
- [ ] **Automation tools**: LinPEAS, LinEnum, linux-smart-enumeration (lse.sh)

## Module 2: Linux Privilege Escalation Vectors
- [ ] **Sudo misconfig**: `sudo -l` — any NOPASSWD entries? Any GTFOBins candidates?
- [ ] **SUID/SGID binaries**: `find / -perm -u=s -type f 2>/dev/null`
  - [ ] GTFOBins (gtfobins.github.io) — catalog of abusable SUID binaries
- [ ] **Cron jobs**: `/etc/crontab`, `/etc/cron.*`, user crontabs
  - [ ] Writable scripts in cron → overwrite with malicious code
- [ ] **Writable `/etc/passwd`**: add user with known password
- [ ] **Writable service files**: systemd services, init.d scripts
- [ ] **Kernel exploits**: DirtyCow, DirtyPipe, PwnKit (CVE-2021-4034)
- [ ] **Weak file permissions**: world-writable files in `$PATH`
- [ ] **PATH hijacking**: cron running relative-path command
- [ ] **Capabilities**: `getcap -r / 2>/dev/null` — `cap_setuid` abuse
- [ ] **NFS no_root_squash**: mount and create SUID binary
- [ ] **Docker group membership**: instant root via container mount
- [ ] **Password reuse**: check for creds in files, history, configs, memory

## Module 3: Windows Enumeration
- [ ] **System info**: `systeminfo`, `hostname`, `ver`
- [ ] **Current user/groups**: `whoami /all`, `net user`, `net localgroup`
- [ ] **Running processes**: `tasklist /v`, `Get-Process`
- [ ] **Services**: `sc query`, `Get-Service`, `wmic service list brief`
- [ ] **Installed software**: `wmic product get name,version`
- [ ] **Patches**: `wmic qfe list`, missing patches via Windows Exploit Suggester
- [ ] **Network**: `ipconfig /all`, `netstat -ano`, `arp -a`
- [ ] **Scheduled tasks**: `schtasks /query /fo LIST /v`
- [ ] **Automation tools**: WinPEAS, PowerUp, JAWS, Seatbelt, Watson

## Module 4: Windows Privilege Escalation Vectors
- [ ] **Unquoted service paths**: exploit when service path has spaces and no quotes
- [ ] **Weak service permissions**: modify service binary or config with `sc config`
- [ ] **Registry autoruns**: writable autorun keys
- [ ] **AlwaysInstallElevated**: MSI packages run as SYSTEM
- [ ] **Stored credentials**:
  - [ ] `cmdkey /list`
  - [ ] SAM/SYSTEM hives if readable
  - [ ] Unattended install files (`Unattend.xml`, `sysprep.inf`)
  - [ ] PowerShell history, web.config, application configs
- [ ] **Token impersonation**: SeImpersonate privilege → JuicyPotato, PrintSpoofer, RoguePotato, GodPotato
- [ ] **DLL hijacking**: writable directory in DLL search path
- [ ] **Scheduled task abuse**: modifiable task binary
- [ ] **UAC bypass**: fodhelper, computerdefaults, event viewer bypass
- [ ] **Kernel exploits**: MS16-032, MS17-010 (EternalBlue), PrintNightmare

## Module 5: Post-Exploitation Techniques
- [ ] **Persistence** (with authorization): SSH keys, cron jobs (Linux); scheduled tasks, services (Windows)
- [ ] **Credential harvesting**: Mimikatz (Windows), password files, browser credentials
- [ ] **Pivoting**: SSH tunneling, Chisel, Ligolo-ng, SOCKS proxies
- [ ] **Lateral movement basics**: SSH, RDP, PsExec, WinRM, SMB
- [ ] **Data exfiltration**: ensure it's in-scope and documented in engagement rules
- [ ] **Logging awareness**: what you're leaving behind (for defensive understanding)
- [ ] **Cleanup**: remove artifacts after authorized engagement completes

## Module 6: Tools & Methodology
- [ ] **LinPEAS / WinPEAS**: automated enumeration scripts
- [ ] **GTFOBins**: Linux SUID/sudo abuse reference
- [ ] **LOLBAS**: Windows "living off the land" binaries reference
- [ ] **PayloadsAllTheThings**: GitHub repo of techniques
- [ ] **HackTricks**: hacktricks.xyz — comprehensive wiki
- [ ] **Methodology**: enumerate → identify vector → verify → exploit → document
- [ ] **When stuck**: re-enumerate, read files you missed, check `/var/log`, check environment

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | TryHackMe "Linux PrivEsc" room, HackTheBox Academy Linux PrivEsc module |
| Modules 3-4 | TryHackMe "Windows PrivEsc" room, HTB Windows PrivEsc module |
| Module 5 | HackTheBox retired boxes — practice full kill chain |
| Module 6 | Build personal cheat sheet from your own notes, not copied |

## Key Resources
- **TryHackMe Linux/Windows PrivEsc paths** (best structured learning)
- **HackTheBox Academy PrivEsc modules**
- **GTFOBins** (gtfobins.github.io)
- **LOLBAS** (lolbas-project.github.io)
- **HackTricks** — Linux & Windows hardening pages
- **PayloadsAllTheThings** GitHub
- "Red Team Field Manual" (RTFM), "Blue Team Field Manual" (BTFM)
