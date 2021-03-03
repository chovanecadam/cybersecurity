# What is SMB

> The Server Message Block (SMB) protocol is a network file
> sharing protocol that allows applications on a computer to
> read and write to files and to request services from server
> programs in a computer network. [source](https://docs.microsoft.com/en-us/windows-server/storage/file-server/file-server-smb-overview)

SMB runs on TCP port 445, often with TCP/UDP 139 NetBIOS Session Service.

# Enumeration

## smbclient

[smbclient](https://linux.die.net/man/1/smbclient) offers a shell-like
interface and is part of Samba suite. You can log in with NTLM hash,
kerberos or password.

```bash
# list shares on host with comments
# doesn't display permissions
smbclient -L //10.10.10.100

# anonymous connection to a share
smbclient //mysmbserver/backups

# authenticated session with forced encryption
smbclient -e -U eve //10.10.10.100/backups
```

| command       | function                                          |
| ------------- | ------------------------------------------------- |
| put           | upload a file                                     |
| get           | download a file                                   |
| mput          | upload multiple files                             |
| mget          | download multiple files                           |
| allinfo       | download multiple files                           |
| recurse ON    | allow recursion when downloading multiple files   |
| prompt OFF    | suppress annoying prompts                         |

It also supports standard shell commands like `cd, ls, pwd, more`.

## SMBMap

[SMBMap](https://github.com/ShawnDEvans/smbmap) is a penetration testing tool
for enumeration and exploitation of SMB shares. This tool doesn't display
share comments. By default it tries to check drive permissions by reading, creating,
and deleting files. You can (and should) disable this feature by `--no-write-check`
flag.

```bash
# anonymous access, list shares with permissions
smbmap.py -H 10.10.10.100

# guest access
smbmap.py -u somethingrandom -H 10.10.10.100

# recursively list all files on share Users
smbmap.py -u username -ppassword -H 10.10.10.100 -R Users

# download file user.txt from share Users on box 10.10.10.100 logged as user username
smbmap.py -u username -ppassword -H 10.10.10.100 -R Users -A user.txt
```

## Nmap

> [Nmap](https://nmap.org/) ("Network Mapper") is a free and open-source
> utility for network discovery and security auditing.

Nmap offers several scripts for enumerating SMB shares. It will
create "nmap-test-file" to check write and delete permissions.

```bash
# possibly dangerous script
nmap --script smb-enum* --script-args=unsafe=1 -p139,445 10.10.10.100

nmap --script "safe or smb-enum-*" -p 445
```
