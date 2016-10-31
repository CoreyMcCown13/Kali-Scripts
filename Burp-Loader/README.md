# Burp Suite Loader
This script is designed to replace the free Burp Suite that comes out of the box with Kali Linux, and create a loader script that will check a given directory for the latest version of Burp Suite. This is beneficial primarily for Pro users. If the Burp Suite Java file is updated, it will make the new file executable and automatically start it.

## Usage
1. Remove or rename "burpsuite" in the `/usr/bin` directory.
2. Place the burpsuite.sh script in the `/usr/bin` directory.
3. Edit the 5th line of the script to reflect where you will be storing Burp Suite. By default it checks `/root/Documents/Burp/`. Be sure to include the tailing `/` in the directory.
4. Remove the extension of the script (ie: `mv burpsuite.sh burpsuite`).
5. Make the script executable (ie: `chmod +x`).

You can now  launch the original Burp Suite application from the applications list in Kali, and it will launch the latest version stored in your directory.

Tested on Kali Linux 2016.2
