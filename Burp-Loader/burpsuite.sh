#!/bin/bash

# Provide the directory that you are storing Burp Suite in.
# Include the tailing `/`
burpDirectory="/root/Documents/Burp/"

echo "Finding latest version of Burp Suite..."
burpVersion=$(ls $burpDirectory*.jar -Art | tail -n 1)
echo "Found: $burpVersion!"
if [[ -x "$burpVersion" ]]
then
	echo "$burpVersion is executable, continuing..."
else
	echo "$burpVersion is not executable, attempting to correct permissions..."
	{
		chmod +x $burpVersion
		echo "Permission repaired, continuing..."
	} || {
		echo "Failed to correct permissions, perhaps run as root?"
		exit
	}
fi
$burpVersion
