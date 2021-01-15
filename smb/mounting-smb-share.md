# How to mount shared SMB drive

## from shell

This newly mounted drive will be also visible in GUI applications and for the rest
of the system. To just browse SMB share, use smbclient or smbmap.
More information the command [mount.cifs](https://linux.die.net/man/8/mount.cifs).

```bash
sudo apt-get install -y cifs-utils

# mount new share to your linux machine
mount -t cifs //10.10.10.100/Backups /mnt/remote_backups
```

This creates SMB share visible only to the current shell. More information about
[New-PSDrive](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-psdrive),
[Get-PSDrive](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-psdrive), 
and [Remove-PSDrive](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/remove-psdrive).

```powershell
# create temporary share visible only to the current shell
New-PSDrive -Name "bk" -PSProvider "FileSystem" -Root "\\1.2.3.4\Backups"

Copy-Item secret.txt bk:\
cd bk:\
```

This will create new drive "s:" visible to other applications on the system, ie.
File Explorer. Documentation about [net use](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/gg651155%28v%3Dws.11%29).

```shell
# connect to smb share
net use s: \\10.10.10.2\guest

# connect with credentials, openes prompt
net use s: \\10.10.10.2\auth * /user:sambauser

# restore connections at each logon
net use /persistent:yes

# disconnect from smb share
net use s: /delete
```

## from gui applications

In [Files](https://wiki.gnome.org/Apps/Files), file manager for GNOME:

1. click "other locations" on the bottom of the left menu
2. enter hostname or ip of the server "smb://10.10.10.10"
3. log in or use anonymous share

In Windows File Explorer, just enter addres or hostname as the file path:

```
\\10.10.10.2\
```
