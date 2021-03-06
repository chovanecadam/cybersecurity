# Creating new share on Linux

## How to create a shared folder on Linux

### Samba

> Samba is an implementation of the SMB/CIFS protocol for Unix systems,
> providing support for cross-platform file and printer sharing with
> Microsoft Windows, OS X, and other Unix systems.

Configuration file is located in /etc/samba/smb.conf. I've written a simple
configuration file with guest and authenticated share which can be found 
[here](../smb/smb.conf), installation script [here](../smb/samba-setup.sh).

```
service smbd start
service smbd stop
```

### Impacket

Impacket provides this [python script](https://github.com/SecureAuthCorp/impacket/blob/master/examples/smbserver.py)
which creates a new SMB share. SMB2 support is experimental, but it provides
options for a password or an NTLM authentication. In my experience, it doesn't work
well.

# Creating new share on Windows

There are two sets of permissions, filesystem permissions, and CIFS share
permissions. When accessing a share, both of these are evaluated and
the stricter takes precedence. The best practice is to set CIFS permissions
to "Everyone: Full Control" and manage permissions of files on filesystem level.
This way users can access the same files from SMB, RDP or WinRM.

## from shell

Powershell module to manage SMB shares is [SmbShare](https://docs.microsoft.com/en-us/powershell/module/smbshare/).

```powershell
# create and share new folder
mkdir C:\Users\eve\Shared
New-SmbShare -name myshare -Path C:\Users\eve\Shared

# info about file permissions
Get-SmbShareAccess -name myshare

# enable guest access
Grant-SmbShareAccess -name myshare -AccountName Everyone -AccessRight Read

# enforce encryption on the whole server (disables guest access)
Set-SmbServerConfiguration -EncryptData $true

# enforce encryption on a particular share
Set-SmbShare -Name Private -EncryptData $true
```

Command Prompt tool to manage shell is [net share](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/hh750728%28v%3Dws.11%29).

```
# create new share
net share "shared=C:\Users\vagrant\Documents\Shared Folder" /GRANT:Eve,CHANGE /GRANT:Guest,READ

# info about a share
net share
net share shared

# delete a share
net share shared /detele
```

## from File Explorer

Creating a new share from GUI tools on Windows can be a bit tricky.
Open File Explorer, select a folder you want to share, in the context menu
select properties, and go to Sharing. There are two options to share.
Neither of these options enforces encrypted connections.

### "Share..."

This option will share the whole "/Users/" directory, sets CIFS permissions
to "Everyone: Full Control" and then set filesystem permissions to the given
permissions. If you delete the share, the permissions will be reset to the
previous state. Note that with this option, any folder or file which is readable
by Everyone, Guest or Anonymous Logon will be exposed too.

### "Advanced sharing..."

This option lets you share only the selected folder, add a comment, and set CIFS
permissions. This option doesn't set filesystem permissions, you need to do it
separately.

