# Network Capcure

## Toolset

Documentation for all wireshark tools can be found 
[here](https://www.wireshark.org/docs/man-pages/) 
(including Berkeley Packet Filter tcpdump and wireshark use 
for packet capture). Wireshark display-filter reference can be found
[here][wireshark-filters].

### pcap capture

| tool          | purpose                               | package   |
| ------------- | ------------------------------------- | --------- |
| tcpdump       | lightweight network capture           | [tcpdump][tcpdump]     |
| tshark        | wireshark in a (nut)shell             | [wireshark][wireshark] |
| wireshark     | best network protocol analyzer        | [wireshark][wireshark] |

### pcap analysis


| tool          | purpose                                      | package   |
| ------------- | -------------------------------------------- | --------- |
| capinfos      | display basic information about capture file | [wireshark][wireshark] |
| termshark     | wireshark-like shell GUI                     | [termshark][termshark] |
| tcpreplay     | replay capture to network                    | [tcpreplay][tcpreplay] |

### pcap manipulation

| tool          | purpose                               | package               |
| ------------- | ------------------------------------- | --------------------- |
| reordercap    | reorder input file by timestamp       | [wireshark][wireshark]|
| mergecap      | merge multiple capture files into one | [wireshark][wireshark]|
| editcap       | edit pcap file                        | [wireshark][wireshark]|
| tcprewrite    | edit pcap file                        | [tcpreplay][tcpreplay]|
| pcapfix       | attempt to fix package                | [pcapfix][pcapfix]    |
| ngrep         | grep on packet payloads               | [ngrep][ngrep]        |     

### automated internet tools

| název                                    | popis                                    |
| ---------------------------------------- | ---------------------------------------- |
| [malware-traffic-analysis.net][mta.net]  | IOCs, packet captures, etc.              |
| [PacketTotal][PtTotal]                   | pcap analysis                            |
| [A-Packets][A-Pkt]                       | pcap analysis                            |

[Chapter](../osint/README.md) about open-source intelligence
contains a list of tools which are very useful for packet capture
analysis (identifying hosts, subdomains, MAC manufacturers, etc.)

## Examples

```bash
# capture tls traffic on interface eth0, rotate every 5 minutes
tcpdump -i eth0 -w capture.pcap -G 600 "port 443"

# capture only packet with SYN and FIN flags set
tcpdump -i eth0 'tcp[tcpflags] & (tcp-syn|tcp-fin) != 0'

# split large capture to one-hour files
editcap -i 3600 capture.pcap capture.pcap
```

[wireshark]: https://wireshark.org/ "wireshark"
[tcpreplay]: https://tcpreplay.appneta.com "tcpreplay"
[pcapfix]: https://github.com/Rup0rt/pcapfix "pcapfix"
[ngrep]: https://github.com/jpr5/ngrep "ngrep"
[tcpdump]: https://www.tcpdump.org/ "tcpdump"
[termshark]: https://termshark.io/

[mta.net]: https://www.malware-traffic-analysis.net
[PtTotal]: https://packettotal.com/
[A-Pkt]: https://apackets.com/

[wireshark-filters]: https://www.wireshark.org/docs/dfref/

