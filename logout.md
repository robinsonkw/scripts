# Bash scripting cheat sheet
This is a compilatiton of Bash scripts that I have collected in my bash research.
In no particular order, they are listed.

## Log Out 
The following code will generate the log output in the console and in a log file
```bash
#!/bin/bash
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>log.out 2>&1
# Everything below will go to the file 'log.out':
```
 ## Variable Null Test
```bash
if test -z "$var"
```
