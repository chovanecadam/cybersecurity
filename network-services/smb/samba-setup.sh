#!/bin/bash

PASS= # ADD PASSWORD HERE

if [[ -z "$PASS" || `id -u` > 0 ]]
then
    echo You aren\'t root or you haven\'t changed the password variable >&2
    exit 1
fi

apt-get install samba -y

adduser --disabled-password --gecos "" --no-create-home \
  --shell "/sbin/nologin" sambauser

printf "$PASS\n$PASS" | smbpasswd -sa sambauser

groupadd sambagroup
usermod -aG sambagroup sambauser

mkdir -p /srv/smb/guest/
mkdir -p /srv/smb/auth/

chgrp -R sambagroup /srv/smb/guest/
chgrp -R sambagroup /srv/smb/auth/

chmod -R 2775 /srv/smb/guest/
chmod -R 2770 /srv/smb/auth/

if [[ -r ./smb.conf ]]
then
    cp ./smb.conf /etc/samba/smb.conf
else
    echo "Please copy smb.conf file to /etc/samba/smb.conf" >&2
    exit 1
fi

service smbd restart
