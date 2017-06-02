# OpenVPN Kill Switch & Automatic Restart
This configuration is used for checking if your connection is being tunneled over OpenVPN. If the script detects the tunnel is down or the DNS and/or PING are not responding, it will establish a new connection. Using the iptables rules below, you can ensure that all traffic is routed through OpenVPN.
This setup is running on my Ubuntu 14.04 server, but should work on most Linux distributions, especially Debian based.
## tl;dr
This script keeps your OpenVPN connection active and ensures you elimates connection leakage.
## Script
Bash script is [located here](https://github.com/CoreyMcCown13/Shell-Scripts/blob/master/OpenVPN-KillSwitch/killswitch.sh).
Make this a cron job that runs as frequently as you want. Mine runs every minute using this:
```
* * * * * /path/to/killswitch.sh
```
## iptables Rules
These iptable rules will block outbound traffic so that only the VPN and related services are allowed. Make these persistent.
Credit: [superjamie](https://gist.github.com/superjamie/ac55b6d2c080582a3e64).
```
sudo iptables -A OUTPUT -o tun0 -m comment --comment "vpn" -j ACCEPT
sudo iptables -A OUTPUT -o eth0 -p icmp -m comment --comment "icmp" -j ACCEPT
sudo iptables -A OUTPUT -d 192.168.1.0/24 -o eth0 -m comment --comment "lan" -j ACCEPT
sudo iptables -A OUTPUT -o eth0 -p udp -m udp --dport 1198 -m comment --comment "openvpn" -j ACCEPT
sudo iptables -A OUTPUT -o eth0 -p udp -m udp --dport 53 -m comment --comment "dns" -j ACCEPT
sudo iptables -A OUTPUT -o eth0 -p tcp -m tcp --dport 53 -m comment --comment "dns" -j ACCEPT
sudo iptables -A OUTPUT -o eth0 -j DROP
```
