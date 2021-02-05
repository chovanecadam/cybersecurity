#!/bin/bash

umask 0077

DIR='/tmp/keys'
[[ -d "$DIR" ]] || exit 1

for name in server client; do
    openssl req -newkey rsa:2048 -nodes -keyout "$DIR/$name.key" -x509 -days 365 -out "$DIR/$name.crt"
    cat "$DIR/$name.key" "$DIR/$name.crt" > "$DIR/$name.pem"
done
