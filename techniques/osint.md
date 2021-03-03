# OSINT

The purpose of this page is just to list basic tools. The most detailed collection
of tools is [Open Source Intelligence Techniques](https://inteltechniques.com/book1.html)
written by [Michael Bazzell](https://inteltechniques.com/index.html).

## whois

> WHOIS (pronounced as the phrase "who is") is a query and response
> protocol that is widely used for querying databases that store the
> registered users or assignees of an Internet resource, such as
> a domain name, an IP address block or an autonomous system.
> ([wikipedia](https://en.wikipedia.org/wiki/WHOIS))

There's a very handy `whois` client for Linux, which lets you
browse the whois database from the terminal. Authoritative whois
registry for .cz domain is [nic.cz/whois/](https://www.nic.cz/whois/).

## Google hacking

Google search provides several useful operators that allow more advanced
search techniques. [Google Hacking Database](https://www.exploit-db.com/google-dorks/)
from Offensive Security provides countless examples sorted into 14 categories.

```
"word"                              exact match
@twitter                            search on social media
site:example.com                    search on site
cache:example.com/deleted.html      view cached site
info:example.com                    info about the website
filetype:php                        only files with given extension
ext:php                             only files with given extension

[all]intitle:"Index of"             pages with string in the title
[all]inurl:/wp/                     pages with string in url (wordpress sites)
[all]intext:"Control Panel"         pages with string in text

before:YYYY-MM-DD                   pages indexed before or after
before:YYYY                          a given date or year
```

If you specify multiple operators, results satisfying all of them will be 
shown. Minus sign negates the operator. Parentheses, `OR`, or `|` can be used
to specify more complicated queries. Some operators support asterisk operator.
Google also understands range operator `..` (`1..50` will match numbers from 1
to 50).

```
# pdf files on ftp servers
inurl:ftp -inurl:(http|https) filetype:pdf "confidential"

# sites with "Blue kitty" in the title
intitle:"Blue kitty"

# sites with "blue" and "kitty" in title (regardless of the order)
allintitle:Blue kitty

# Microsoft Document files
ext:doc OR ext:docx
```

Running automated tools is against Google's TOS and can get you shunned by Google.
Don't risk getting your IP blocked from using any Google services. I had to solve
CAPTCHA after just a few queries I tried from the database, so the risk of getting
banned is very real.

The most recent cached version can be viewed by visiting 
`https://webcache.googleusercontent.com/search?q=cache:example.com`.

- [Advanced Search](https://google.com/advanced_search)
- [Advanced Image Search](https://google.com/advanced_image_search)
- [Google Alerts](https://www.google.com/alerts)

### Custom Search Engine

Google allows you to create a custom search engine, which will allow you to easily search
selected sites (only social media for example), exclude sites from your search, or 
use several search operators. Only the top 100 results are shown. Google also offers JSON API.
You can create a custom search engine on [google.com/cse](https://google.com/cse).

### examples

```
# identify subdomains
site:"example.com" -site:"www.example.com"

# examples from exploit-db
ext:(doc | pdf | xls | txt) intext:confidential salary inurl:confidential
site:p2.*.* intitle:"login"
inurl:".php?id=" "You have an error in your SQL syntax"
inurl:scgi-bin intitle:"NETGEAR ProSafe"
```

## various free internet tools

| name                     | description                        | url       |
| ------------------------ | ---------------------------------- | --------- |
| sitereport.netcraft.com  | various information about domain   | [url][1]  |
| searchdns.netcraft.com   | subdomains search                  | [url][2]  |
| passivedns               | subdomains, search by ip or domain name | [url][3] |
| macvendorlookup          | MAC Lookup                         | [url][4]  |
| macvendors               | MAC Lookup                         | [url][5]  |
| NERD CESNET              | reputational database              | [url][6]  |
| AbuseIPDB                | reputational database              | [url][7]  |
| Wappalyzer			   | find out what are sites build with | [url][8]  |
| Security Headers 		   | analyzes HTTP headers			    | [url][9]  |
| Qualys SSL Labs		   | analyzes SSL configuration		    | [url][10] |
| ViewDNS.info             | collection of many online tools    | [url][11] |
| domainIQ                 | collection of many online tools    | [url][21] |
| google.com/imghp         | visual image search                | [url][14] | 
| TinEye                   | visual image search                | [url][15] | 
| Bing visual search       | visual image search                | [url][16] | 
| eTools.ch                | search engine aggregator           | [url][17] |
| Startpage.com            | search engine aggregator           | [url][18] |
| Carbon Dating            | aggregator for several archiving web tools | [url][19] |
| Hurricane Electric Internet Services | whois, reverse DNS     | [url][24] |

Wappalyzer also offers great free [browser extensions](https://www.wappalyzer.com/download/)
which lets you quickly fingerprint technologies used in sites, their versions,
server version, etc.

ViewDNS offers premium API plans, but also allows you to query the site via static URL: 
`https://viewdns.info/reversewhois/?q=example.com`.

Startpage.com also supports several [search operators](https://support.startpage.com/index.php?/en/Knowledgebase/Article/View/989/34/advanced-search-which-search-operators-are-supported-by-startpage), although less than Google.

Carbon Dating can be also run locally in a [Docker container](https://hub.docker.com/r/oduwsdl/carbondate/dockerfile/).

## premium tools

| name                  | url       |
| --------------------- | --------- |
| whoxy                 | [url][12] |
| whoisology            | [url][13] |
| Spyse                 | [url][20] |
| Pentest Tools         | [url][22] |
| Hunter.io             | [url][23] |

## other sources

- [The Art of Subdomain Enumeration][25]

[1]: https://sitereport.netcraft.com
[2]: https://searchdns.netcraft.com/
[3]: https://passivedns.mnemonic.no/
[4]: https://www.macvendorlookup.com/
[5]: https://macvendors.com/
[6]: https://nerd.cesnet.cz/nerd/ips
[7]: https://www.abuseipdb.com
[8]: https://www.wappalyzer.com/lookup/
[9]: https://securityheaders.com
[10]: https://www.ssllabs.com/ssltest/
[11]: https://viewdns.info/
[12]: https://www.whoxy.com
[13]: https://whoisology.com
[14]: https://google.com/imghp 
[15]: https://tineye.com/
[16]: https://www.bing.com/visualsearch
[17]: https://etools.ch/
[18]: https://startpage.com/
[19]: http://carbondate.cs.odu.edu/
[20]: https://spyse.com/tools
[21]: https://www.domainiq.com/
[22]: https://pentest-tools.com
[23]: https://hunter.io
[24]: https://bgp.he.net/ip/192.168.0.1
[25]: https://appsecco.com/books/subdomain-enumeration/
