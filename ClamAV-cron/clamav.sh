#!/bin/bash

#Update this variable to be your email address
email_address="youremail@domain.com"

return_code=0

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo "Virus scan: only root can do that" 1>&2
    exit 1
fi

# Display starting message
echo "Starting ClamAV automated scan..." ; echo ""

# Dump old ClamAV log (a permanent one is created if infections are found)
echo "Cleaning old log files..."
clamlog="/var/log/virus-scan.log"
sudo rm -f "$clamlog"
sudo touch "$clamlog"
sudo chmod 640 "$clamlog"

echo "Starting system scan..."
sudo clamscan -r / --log="$clamlog"
return_code=$?

# Echo scan results
if [ $return_code -ne 0 ] && [ $return_code -ne 1 ]; then
    echo "Failed to complete virus scan"
else
    echo ""; echo "";
	echo -n "Virus scan completed successfully, "
	#Determine if any infections were found
    if sudo grep -rl 'Infected files: 0' "$clamlog" > /dev/null 2>&1; then
        echo "No infections detected."; echo ""
    else
		#If detections are found, create a permanent log file and email the results
        echo "INFECTIONS DETECTED!"
		virus_results="/var/log/virus-scan-results_$(date +%F_%R).log"
		sudo touch "$virus_results"
		sudo chmod 640 "$virus_results"
		tail -n 10 "$clamlog" >> "$virus_results"
		echo "" >> "$virus_results"
		grep -i ' FOUND' "$clamlog" >> "$virus_results"
		mail -s 'ClamAV: Infections Detected!' "$email_address" < "$virus_results"
    fi
fi

exit $return_code
