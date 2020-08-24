# CREM Script
## Overview

## Plan
1. Determine the last time the audit script was run (this should be everyday, so it 
really should not be an issue.)  But current script is currently using  
    ```
    olddate=$(/bin/ls -lr | tail -2 | head -1 | grep -e '[[:digit:]]{8}' | awk '{ print $9 }')
    ```
to get the last folder created (which should have been last week for audting).  I would like
to get this transfered into the file name, since this would be running every day, we could find
the last modified file and use 
    ```
    sed
    ```
    to get the first eight (8) digits which is the date based on my audit script format.
1. Compare the $olddate to the $yesterday date.  If they match, then the script can proceed, 
else it should log an derror.  Error logging, actual, is way outside my coding experience.
1. Check to see if the DriveInventory report exists.  Set drive inventory flag to Yes.
1. Check to see if the NetApp report exists.  Set netapp flag to yes.
1. Check to see if the CREM report exists.  Set CREM flag to yes.

    **NOTE:** These are all for yesterday.  The date format on these might be different, or could use
    the last modified of the file name to accomplish this same thing.

1. If all the Flags='Yes' then the script will proceed.
1. Comparison uses diff to compare the old file with the new file and will output the results
in the audit file for same date.
    ```
    >> $yesterday-audit.report
    ```
1. If any section of the diff comparison is blank, that will be logged as well.
