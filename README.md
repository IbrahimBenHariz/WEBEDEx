<h1 align="center"><b><i>WEBEDEx</i></b></h1>

WEBEDEx, it's a versatile web enumeration tool designed to simplify the process of discovering subdomains and directories on a target website. Designed to be lightweight it only has to run a bash script.

<img src="https://github.com/IbrahimBenHariz/WEBEDEx/blob/main/Ressources/LogoWEBEDEx.png" align="center" width="250"/>

## Version
- **VERSION 1.0**

## Features
- Lightweight, designed to run a simple bash script.
- Directory and Subdomain Enumeration, discover directories, files or subdomains on the target website and assess its structure.
- User-Friendly, easy-to-use command-line interface with clear instructions and feedback.

## Installation
Simply copy-paste the script in the file WEBEDEx.sh

OR

```yaml
wget https://raw.githubusercontent.com/IbrahimBenHariz/WEBEDEx/main/WEBEDEx.sh
```

## Usage
```yaml
.\WEBEDEx.sh -h
```

```console
█   █ █████ ████  █████ ████  █████
█   █ █     █  █  █     █   █ █     █  █
█ █ █ ███   █████ ███   █   █ ███    ██
█ █ █ █     █   █ █     █   █ █      ██
█████ █████ █████ █████ ████  █████ █  █


               ████████
             ████████████
           ██████    ██████
          ██████      ██████
                  ██
                  ██
          ██████      ██████
           ██████    ██████
             ████████████
               ████████


WEBEDEx Help Menu

Modes :
        dir     directory & file enumeration
        dns     DNS subdomain enumeration

Flags :
        dir mode : ./WEBEDEx.sh dir -u <TARGET URL> -w <WORDLIST> ...
        dns mode : ./WEBEDEx.sh dns -u <DOMAIN NAME> -w <WORDLIST> ...

        -u      Specify the target URL or DOMAIN NAME
        -w      Specify the wordlist file or a directory path
        -s      Search for a specific wordlist that matches an input
                Note : the -w flag must be specified with a directory path
        -H      Change the HTTP header of the request for the enumeration
        -v      Verbose mode
        -h      Help menu about the tool
        -V      Show the version

Examples :
        ./WEBEDEx.sh dir -w /usr/share/wordlist/apache.txt -u https://example.com

        ./WEBEDEx.sh dns -w /usr/share/wordlist/dns.txt -u example.com

        ./WEBEDEx.sh dns -w /usr/share/wordlist/ -u example.com -s apache

        ./WEBEDEx.sh dir -w /usr/share/wordlist/spring.txt -u https://example.com -H "User-Agent: MyCustomUserAgent, Content-Type: application/json"

        ./WEBEDEx.sh dir -w /usr/share/wordlist/dns/ -u https://example.com -v
```

## Reach Out To Me <img alt="Contact Icon" width="40px" src="https://github.com/IbrahimBenHariz/IbrahimBenHariz/blob/main/PortfolioResources/ReachOutToMe.png"/>

[<img alt="LinkedIn" align="left" width="45px" src="https://github.com/IbrahimBenHariz/IbrahimBenHariz/blob/main/PortfolioResources/LinkedInIcon.svg"/>][linkedin]
[<img alt="Outlook" align="left" width="48px" src="https://github.com/IbrahimBenHariz/IbrahimBenHariz/blob/main/PortfolioResources/OutlookIcon.svg"/>][outlook]
[<img alt="Discord" align="left" width="47px" src="https://github.com/IbrahimBenHariz/IbrahimBenHariz/blob/main/PortfolioResources/DiscordIcon.svg"/>][discord]
[<img alt="Reddit" align="left" width="48px" src="https://github.com/IbrahimBenHariz/IbrahimBenHariz/blob/main/PortfolioResources/RedditIcon.png"/>][reddit]
[<img alt="Hack The Box" align="left" width="48px" src="https://github.com/IbrahimBenHariz/IbrahimBenHariz/blob/main/PortfolioResources/HackTheBoxIcon.svg"/>][hackthebox]
[<img alt="Try Hack Me" align="left" width="50px" src="https://github.com/IbrahimBenHariz/IbrahimBenHariz/blob/main/PortfolioResources/TryHackMeIcon.png"/>][tryhackme]
[<img alt="Credly" align="left" width="48px" src="https://github.com/IbrahimBenHariz/IbrahimBenHariz/blob/main/PortfolioResources/CredlyIcon.svg"/>][credly]


[linkedin]: https://www.linkedin.com/in/ibrahim-benhariz
[outlook]: mailto:ibrahim.benhariz@outlook.com
[discord]: https://discord.com/users/1111590525066297464
[reddit]: https://www.reddit.com/user/IbrahimBenHariz
[hackthebox]: https://app.hackthebox.com/profile/1525863
[tryhackme]: https://tryhackme.com/p/IbrahimBenHariz
[credly]: https://www.credly.com/users/ibrahim-ben-hariz
