# Bash scripting cheat sheet
This is a compilatiton of Bash scripts that I have collected in my bash research.
In no particular order, they are listed.  Simple 'tested' or negative will inform
if the script has been tested or awaiting implementation.

## Log Out (no)
The following code will generate the log output in the console and in a log file
```bash
#!/bin/bash
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>log.out 2>&1
# Everything below will go to the file 'log.out':
```
## IF type operators
### Variable Null Test  (yes)
This if test will determine if the variable listed is NULL to determine if something
needs to happen or proceed to the next step.
```bash
if test -z "$var"
then
    echo "Do something here if null"
else
    echo "Do something here if not null"
fi
```
### IF test for file (yes)
``` IF [ -e $name ] FI
```
### IF test for directory (yes)
``` IF [ -d $name ] FI
```
### IF test not directory/system file (no)
``` IF [ -f $name ] FI
```
### IF test not zero size (no)
``` IF [ -s $name ] FI
```
Other IF operators are located [here](https://tldp.org/LDP/abs/html/fto.html).
## Latest file / folder name (yes)
## File name matches string (no)
## Loop
