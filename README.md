# rootshell-NOMW
root shell - Not On My Watch

## Rationale
In a shared *persistant* lab environment of exploitable machines, some users may create a backdoor with tools like metasploit. 
Many users may leave these shells open for other unauthenticated users

Appends a message to every interactive bash shell; telnet, netcat, ect

This script;
  1. scans the subnet for active root shells
  2. creates a psudo-terminal socket connection
  3. checks if theres an existing message
  4. If no existing message: append an echo message to the shell users .bashrc 
  
  
## Prerequisites
-nmap
-make script executable:
  `chmod +x nomw.sh`

## usage
(Update the Network and Port variable, default port will work for Ingres services)
`./nomw.sh`

Usage with a loop, running every 10 minutes:
  `watch -n 600 ./nmap.sh`
