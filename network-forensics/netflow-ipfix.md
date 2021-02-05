# Netflow and IPFIX

A network flow is defined as *"a set of IP packets passing an 
observation point in the network during a certain time 
interval, such that all packets belonging to a particular
flow have a set of common properties"* [RFC 7011](https://tools.ietf.org/html/rfc7011)

Flow record is a set of source/dest IP, source/dst ports,
protocol, start/end times, number of packets, number of bytes
and flags.

## Collectors

Increase UPD buffers before starting a collector to prevent dropping
packets. You can either change buffer size temporarily:

```bash
sudo sysctl -w net.core.rmem_max=33554432
sudo sysctl -w net.core.rmem_default=33554432
```

Or change the configuration file to change buffer
size permanently. You can reload sysctl with `sysctl -p`.

```
# /etc/sysctl.conf

net.core.rmem_max     = 33554432
net.core.rmem_default = 33554432
```

### nfcapd

> [nfcapd](http://manpages.ubuntu.com/manpages/focal/man1/nfcapd.1.html) 
> is the netflow capture daemon of the [nfdump](https://github.com/phaag/nfdump) tools

```
nfcapd -p 9995 -b 10.10.10.2 -l /var/log/netflow/ -t 60 -wy
nfcapd 
    -p  port to listen on
    -b  bind on interface
    -l  directory to store files
    -t  rotate files every n seconds
    -w  align file rotation with next n minute
    -y  compress files

    -R  send all incoming packets to this address
    -n  specify multiple sources (cannot be mixed with -l)
    -M  dynamic ad new netflow sources and save each to its own dir
```

## Exporters

### softflowd

```
softflowd -i ens4 -m 300000 -v 9 -n 192.168.0.3:4739 -P udp -A milli -t general=10s -t maxlife=30s -t tcp=20 -t tcp.rst=15 -t tcp.fin=10 -d
softflowd
    -i  interface to bind on
    -m  max flows to track, if is exceeded, flows with least recently seen traffic are forcibly expired
    -v  netflow version (10 is IPFIX, default is 5)
    -n  host and port to send accounting datagrams, use comma to define more
    -P  tcp, udp, sctp
    -A  time format for exporting packets
    -t  various timeouts
    -d  don't daemonise, run in foreground
```

## Analysis

### nfdump

> nfdump - netflow display and analyze program

```
nfdump [options] [filter]

# which hosts used RDP?
nfdump -r capture.nfcapd -A srcip -o 'fmt:%ts , %te , %sa' -q "dst port 3389"

nfdump
    -r read from file
    -A aggregate by source ip
    -o use custom format: first packet seen, last packet seen and ip
    -q don't print additional information
    "dst port 3389" filter

# which hosts requested which dns servers?
nfdump -r capture.nfcapd -A srcip,dstip -o line "dst port 53"
```

# Sidenotes

## How to generate netflow records from pcap capture

[nfdump](https://github.com/phaag/nfdump) package also provides a very handy
nfpcapd tool created for this purpose. The tool doesn't offer an option to
choose netflow version of the records though. Another option is to replay
captured traffic and generate new netflow records on the wire. This can be done with
[tcpreplay](http://manpages.ubuntu.com/manpages/hirsute/man1/tcpreplay.1.html)
tool.
