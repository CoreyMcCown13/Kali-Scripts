#ClamAV On-Demand Scan/Cron Script
This script will run an on-demand scan of your entire system and send an email report to a designated email address if an infection is found. If an infection is found, a log will be created at `/var/log/virus-scan-results_{DATE}.txt`.
##Email Report
The email report will provide the ClamAV Summary, as well as a list of infected files. It will look something like this:

    ----------- SCAN SUMMARY -----------
    Known viruses: 5192893
    Engine version: 0.99.2
    Scanned directories: 19333
    Scanned files: 48454
    Infected files: 1
    Total errors: 15876
    Data scanned: 3057.39 MB
    Data read: 3680.09 MB (ratio 0.83:1)
    Time: 321.381 sec (5 m 21 s)
    
    /home/corey/EICAR: Eicar-Test-Signature FOUND
