# SSH

This technique only works when ssh connections are allowed. All data are encrypted with ssh.

## SSH Local Port Forwarding

```
-L [bind_address:]port:host:hostport
-L [bind_address:]port:remote_socket
-L local_socket:host:hostport
-L local_socket:remote_socket
```

### Usage:

```
1) ssh -NL 127.0.0.1:8080:127.0.0.1:80      alice@alice
2) ssh -NL 127.0.0.1:8080:192.168.0.3:80    alice@alice
```

Any traffic to 127.0.0.1:8080 will be forwarded to 127.0.0.1:80 on Alice's localhost's (or 192.168.0.3:80 in the second example).

## SSH Remote Port Forwarding

```
-R [bind_address:]port:host:hostport
-R [bind_address:]port:local_socket
-R remote_socket:host:hostport
-R remote_socket:local_socket
-R [bind_address:]port
```

### Usage:

```
1) ssh -NR 3307:127.0.0.1:3306 eve@eve
2) ssh -NR alice:3307:127.0.0.1:3306 alice@alice
```

This command will open a new listening port on the destination, which we ssh to. Any connection to this port will be forwarded back to the client, from which we started the connection. Hence the name *remote* port forwarding.

In the first example, we initiate the connection from a host back to our machine. This can be useful if the firewall blocks inbound ssh traffic, but allows outbound ssh traffic. We can then access Eve's port 3306 accessible only from her localhost from 127.0.0.1:3307 on our machine.

In the second example, we start the connection from our machine and forward any connection made to 3307 to Alice's localhost 3306 - this can be useful if we want to publicly expose a port that is otherwise blocked by the firewall. This isn't possible in the default configuration, but can be changed:

```
# /etc/ssh/sshd_config

GatewayPorts yes
```

## SSH Dynamic Port Forwarding

```
-D [bind_address:]port
```

Usage:

```
ssh -ND 9050 alice@alice
```

This opens port 9050 on our machine, which acts as a SOCKS proxy server. Tools that don't support proxy settings can be made to work with proxy using proxychains. Make sure that proxychains is configured to use the same port as in ssh:

```
# /etc/proxychains.conf

...

[ProxyList]
socks4  127.0.0.1 8050
```

```
proxychains nmap bob
```

## Sidenote: X11 forwarding

We can also use ssh to access graphical applications using X11 forwarding.

```
# /etc/ssh/sshd_config on the server side

X11Forwarding yes
X11UseLocalhost no
```

The server also needs to be running an X11 server.

```
ssh -f -X bob
ssh -f -Y bob
```

The first option using `-X` flag is safer, the second is not. It's not a good idea to forward X11 sessions, because if the server is nasty, it can do bad stuff (dispaly windows, insert keystrokes, screenshot, spy on other windows, ask for passwords, etc.) So use with caution. The `-f` flag is used to fork ssh to the background.

# HTTP Tunneling

Tunnels any protocol through http. The connection isn't encrypted, but can bypass (simple) deep packet inspection. 

## httptunnel


The tool is quite old (last commit 9 years), but functional and part of kali toolset. [Link to the github page.](www.gnu.org/software/httptunnel/).

```
sudo apt install httptunnel

# Server
hts -w -F bob:8080 1234

# Client
htc -w -F 8080 alice:1234 
```

Now any connection to client's port 8080 will be tunneled through http to alice:1234 and then forwarded to bob:8080.
