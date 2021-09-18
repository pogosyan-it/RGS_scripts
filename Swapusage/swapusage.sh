#!/bin/sh 
#
# Get current swap usage for all running processes

	_o=/tmp/`basename $0`
	_s=0
	_a=0

 echo '   pid          KB      prog'
 echo '----------------------------'

for _d in `find /proc/ -maxdepth 1 -type d -regex "^/proc/[0-9]+"`
 do
    for _x in `grep VmSwap $_d/status 2>/dev/null | awk '{ print $2 }'`
     do
	   _s=$(( _s + _x ))
     done
									_p=`echo $_d | cut -d / -f 3`
	 [ $_s -gt 0 ] && printf '%6d\t%10d\t%s\n' $_p $_s "`ps -p $_p -o comm --no-headers`"

    _a=$(( _a + _s ))
		_s=0
 done
 printf '%s\t%10d\t%s\n' '------' $_a '----'
