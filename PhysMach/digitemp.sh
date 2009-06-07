#!/bin/bash
echo "Testmessage"
# this script is used to call digitemp and format the output
# that can be used by PhysMach
# (c) 2008 by Hartmut Eilers
# licensed under the GNU GPL V2

# call digitemp , just take the last 2 sensors, just the temp in C, remove cr lf, remove the decimalpoint
# resulting in a multiplication with 100
# 35.26 degree celsius are returned as 3526
#result=`/usr/bin/digitemp_DS9097  -a| tail -n 3|cut -d " " -f 7|sed 's/^M/ /'|sed 's/\.//' `
#result=" 1700 4700 -103 1700 12 56 17000 -32451"
result=`cat /tmp/analog.dat`
echo $result
