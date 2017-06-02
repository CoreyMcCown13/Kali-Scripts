#!/bin/bash 

DATE=`date +%Y-%m-%d:%H:%M:%S`
LOGFILE=/var/log/VPNstatus.log

restartVpn ()
{ 
	echo [$DATE] VPN IS DOWN! >> $LOGFILE
	echo [$DATE] Restarting OpenVPN >> $LOGFILE
	sudo service openvpn restart
	
	ready=false
	while [ "$ready" = false ]; do
		if service openvpn status | grep -q "is running"; then
			if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"; then
				# Service and tunnel back up, ready to continue!
				ready=true
			else
				# Waiting on tunnel...
				sleep 5
			fi
		else
			# Waiting on OpenVPN Service...
			sleep 5
		fi
	done
	echo [$DATE] VPN IS BACK UP! >> $LOGFILE
	
	checkVpn
}

checkVpn()
{
	touch $LOGFILE
	# Checking that tunnel exists...
	if ! /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"; then
			echo [$DATE] Tunnel does not exist! >> $LOGFILE
			restartVpn
			
	else			
		# Testing PING responses...
		count=`ping -c 5 8.8.8.8 | grep -q "received" | awk -F',' '{ print $2 }' | awk '{ print $1 }'`
		if [ "$count" = 0 ]; then
			echo [$DATE] PING response failed! >> $LOGFILE
			restartVpn
		fi
		
		# Testing DNS responses...
		if ! nc -zw1 google.com 443; then
			echo [$DATE] DNS response failure! >> $LOGFILE
			restartVpn
		fi
	fi
}

checkVpn
