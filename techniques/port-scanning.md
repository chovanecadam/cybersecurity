# Recon

## nmap

nmap requires root privileges to perform SYN scan, so if you run
nmap with --proxies of through proxychains, don't use -sY flag.

```bash
# only run the script, don't scan ports, use custom dns server
nmap -sn --script dns-nsec-enum example.com --dns-servers 8.8.8.8

# standard scripts, scan version and OS, be fast and output in all formats
nmap -sC -sV -O -t4 -oA $DIR/$HOST --top-ports 100 $HOST

# use only default or safe scripts and not intrusive
nmap --script 'default or safe' scanme.nmap.com

# use any script with starts with smb-
nmap --script 'smb-*' scanme.nmap.com
```

You can view results of nmap scan in a nice interface in browser with
[nmap-bootstrap-xsl][1]:

```bash
nmap --oA scanme --stylesheet https://raw.githubusercontent.com/honze-net/nmap-bootstrap-xsl/master/nmap-bootstrap.xsl scanme.nmap.org scanme2.nmap.org
```

To list top 100 ports scanned with the `--top-ports` flag:

```bash
grep -v '^#' /usr/share/nmap/nmap-services | sort -r -k3 | awk '{ print $2 }' | cut -d/ -f1 | head -n 100 > nmap-100-most-common-ports.txt
```

## axiom

> The dynamic infrastructure framework for everybody! Distribute the
> workload of many different scanning tools with ease, including nmap,
> ffuf, masscan, nuclei, meg and many more! ([source][2])

The tool is still in the early stages of development, so some things don't
work well (or at all). A great example of how to use it can be found [here][4].
Don't forget to use the Digital Ocean invite link and $100 free credit - 
not that you would need it, the price for a droplet is $5/month, so a few hour
scan will cost you just a few cents.

## masscan

> masscan  is  an  Internet-scale  port  scanner,  useful for large 
> scale surveys of the Internet, or of internal networks. While the 
> default transmit rate is only 100 packets/second, it can optional 
> go as fast as 25 million packets/second, a rate sufficient to scan
> the Internet in 3 minutes for one port. ([source][3])

Nmap-like port scanner with its own TCP/IP stack to make things really fast.
Many options are the same as nmap. Supports distributed scanning, resume scan
feature, exclude filters and configuration file.

```bash
masscan 10.0.0.0/8 -p3306 --banners --output-filename mysql-local.xml
masscan 192.168.0.0/24 --ping -p80,8080,3306,21,445,138 -oX scan.xml
```

Default configuration file is in `/etc/masscan/masscan.conf` and is used,
unless different configuration file is specified in `-c` or `-conf`
parameter. It's a good idea to keep one configuration file per project.
Below is example of useful configuration options:

```
rate = 1000
http-user-agent = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_7; da-dk) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1"
read = 3
```

## autorecon

> AutoRecon is a multi-threaded network reconnaissance tool that
> performs automated enumeration of services. ([source][5])

Autorecon first runs several port scans, determines the type of service 
running and then launches many scans for each type of service. The author
explained the usage as well as the configuration in [this YouTube video][6].
The tool can be installed as a Docker container or with pip. Although you
can create different port-scanning profiles and choose them with `--profile`
option, you cannot do the same for service scans.

A few useful options to use:

```
--only-scans-dir            don't create loot, exploit and report directories
--heartbeat 10              display task status message every 10 seconds
--targets                   TODO 
```

```bash
autorecon 127.0.0.1 --profile udp --only-scans-dir 
```


<!-- ------------ links ------------ -->

[1]: https://github.com/honze-net/nmap-bootstrap-xsl
[2]: https://github.com/pry0cc/axiom
[3]: https://github.com/robertdavidgraham/masscan
[4]: https://0x00sec.org/t/advanced-axiom-usage-axiom-scan/24600
[5]: https://github.com/Tib3rius/AutoRecon
[6]: https://youtu.be/m5Onw7XedHc
