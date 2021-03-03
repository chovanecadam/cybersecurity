# DNS

- [What is DNS?][8]

## Tools

| Name          | Description                            | url       |
| ------------- | -------------------------------------- | --------- |
| dig           | manual tool                            | [url][1]  |
| host          | manual tool                            | [url][2]  |
| dog           | manual tool, great for interactive use | [url][3]  |
| dnsrecon      | automates zone-transfer, getting all records, recursive searches, etc. | [url][4] |
| dnscan        | subdomains bruteforce                  | [url][5]  |
| dnsmap        | subdomains bruteforce                  | [url][6]  |
| dnsx          | multiple DNS queries, part of [projectdiscovery.io][13] tools suite | [url][12] |

In addition to these, multiple online tools can help in
enumerating subdomains, past DNS records, etc. Some of them are listed
in the chapter about [OSINT](../osint/README.md). Also check out
the article: [The Art of Subdomain Enumeration](https://appsecco.com/books/subdomain-enumeration/).

### dig

The `+short` option is useful for scripting. You can save the default
options in `${HOME}/.digrc`.

```bash
dig +short example.com
# 93.184.216.34

dig +noall +answer example.com
# example.com.            7118    IN      A       93.184.216.34

dig +short NS example.com
# b.iana-servers.net.
# a.iana-servers.net.

echo +noall +answer > ~/.digrc
dig example.com
# example.com.            7118    IN      A       93.184.216.34

dig +tcp +short example.com
# 93.184.216.34

dig -x +short 8.8.8.8
# dns.google.
```

You can also specify custom nameserver and port:

```bash
dig +short adminsite.local @192.168.0.1 -p 5533
# 192.168.0.10
```

## Zone Transfer

- [What Are DNS Zone Transfers (AXFR)?][7]

> DNS zone transfer, also sometimes known by the inducing DNS query 
> type AXFR, is a type of DNS transaction. It is one of the many 
> mechanisms available for administrators to replicate DNS databases 
> across a set of DNS servers. [source](https://en.wikipedia.org/wiki/DNS_zone_transfer)

```bash
dig AXFR example.com @ns2.example.com
```

## Zone Walking

NSEC records allow enumerating all domains in the zone without the need
of brute-forcing.

> An important capability of DNSSEC is the ability to authoritatively 
> assert that a given domain name does NOT exist, as per Authenticated
> Denial of Existence in the DNS.
>
> Originally this was done by leveraging NSEC records. However, as noted 
> in section 3.4 of [RFC 7129](https://tools.ietf.org/html/rfc7129):
>
> > There were two issues with NSEC (and NXT). The first is that it allows 
> > for zone walking. NSEC records point from one name to another; in our 
> > example: "example.org" points to "a.example.org", which points to 
> > "d.example.org", which points back to "example.org". So, we can 
> > reconstruct the entire "example.org" zone, thus defeating attempts to 
> > administratively block zone transfers ([RFC2065], Section 5.5).
>
> > The second issue is that when a large, delegation-centric 
> > ([RFC5155], Section 1.1) zone deploys DNSSEC, every name in the zone 
> > gets an NSEC plus RRSIG. [continues]
>
> [source](https://www.farsightsecurity.com/blog/txt-record/zone-walking-20170901/)

Several tools are available:

```bash
dnsrecon -t zonewalk -d example.com
ldns-walk @8.8.8.8 example.com
```

NSEC3 provides better security as it uses hashes of domain names, not 
domain names itself.

## DNS over HTTPS, TLS

Great lecture about security and privacy implications of DNS over HTTPS and 
DNS over TLS: [DNS New World Order -- QuadX! DoH! DoT!][9]. Google provides
free DoH on [dns.gooogle.com](https://dns.google.com/). You can find more 
examples in the [documentation][10]. Other providers can be found [here][11].

```bash
curl -s -H 'accept: application/dns+json' \
'https://dns.google.com/resolve?name=www.example.com&type=NSEC' | jq
```

Unix tool [dog][3] supports DoH as well as HoT and can emit JSON.

```bash
dog --https -n "https://dns.google/dns-query" example.com A AAAA
# A    example.com. 5h05m19s   93.184.216.34
# AAAA example.com. 5h59m00s   2606:2800:220:1:248:1893:25c8:1946
```

<!-- LINKS -->

[1]: http://manpages.ubuntu.com/manpages/focal/man1/dig.1.html
[2]: http://manpages.ubuntu.com/manpages/focal/man1/host.1.html
[3]: https://github.com/ogham/dog
[4]: https://tools.kali.org/information-gathering/dnsrecon
[5]: https://github.com/rbsec/dnscan
[6]: https://tools.kali.org/information-gathering/dnsmap
[7]: https://www.acunetix.com/blog/articles/dns-zone-transfers-axfr/
[8]: https://www.cloudflare.com/learning/dns/what-is-dns
[9]: https://mtug.org/mtug-events/2020-05-27-webinar-9-dns-new-world-order-quadx-doh-dot
[10]: https://developers.google.com/speed/public-dns/docs/secure-transports
[11]: https://dnscrypt.info/public-servers
[12]: https://github.com/projectdiscovery/dnsx
[13]: https://github.com/projectdiscovery
