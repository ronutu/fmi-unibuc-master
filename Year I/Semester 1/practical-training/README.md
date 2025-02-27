# Simulating a Red Team Attack with Cobalt Strike
Below is a mapping of the attack techniques used in my practical training at Bitdefender

### MITRE ATT&CK Mapping

| ID  | Name | Use |
| ------------- | ------------- | ------------- |
| T1071.001  | Application Layer Protocol: Web Protocols  | Use Cobalt Strike to establish a C2 server |
| T1059.001  | Command and Scripting Interpreter: PowerShell  | Generate powershell payload using Cobalt Strike |
| T1027.010  | Obfuscated Files or Information: Command Obfuscation  | Payload obfuscation ([Invoke-Obfuscation](https://github.com/danielbohannon/Invoke-Obfuscation)) |
| T1204.002  | User Execution: Malicious File  | Victim runs payload |
| T1018  | Remote System Discovery  | Network discovery |
| T1087.002  | Account Discovery: Domain Account  | Active Directory(AD) discovery |
| T1003.001  | OS Credential Dumping: LSASS Memory  | Dumping credentials using Mimikatz |
| T1550.002  | Use Alternate Authentication Material: Pass the Hash  | Lateral movement using Pass the Hash attack |
| T1003.003/ T1560.001/ T1006  | OS Credential Dumping: NTDS/ Archive Collected Data: Archive via Utility/ Direct Volume Access  | Create shadow copy of volume C in order to dump ntds.dit into a zip archive and dump the SYSTEM registry hive file |
| T1041  | Exfiltration Over C2 Channel  | Exfiltrate data |
