## Scripts for Red Hat flavors of Linux for auditing and inventory control

# linux_scripts overview

Linux auditing and other scripts primarily for HAIL system.  Can be adapted for other uses.

# audit.test.sh

audit.test.sh script is used to test the individual line outputs of the "aureport" function and then to find/parse that output from the

/var/log/secure
/var/log/messages

files that are in the Linux /var/log folder.  This will allow all the scripts to run without sudo or root access.

# audit.sh

This is the compiled audit file that will run without root access.

# drives.sh

This script compares the inventory information for HAIL system drives.  Will be combined with NetApp in the furture.

# drives_full.sh

This displays a complete listing of the drives inventory for either manual or other comparrison.

# netapp.sh

This will eventually be combined with drives.sh to consolidate auditing scripts.  Currently it compares the NetApp drive inventory.

# rkhunter.sh

This script is designed to compare the outputs of rkhunter runs to track any changes.
