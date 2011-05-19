#!/usr/bin/env bash

 truss -f -t open -o tracer "$@"
 echo "----------- files ---------------"
grep -v "ENOENT$" tracer | awk '{ print $2 }' |grep ^open|sed 's/^open[0-9]*("//; s/",$//' |sort|uniq |grep -v "^/proc/" |grep -v "/lib.*\.so.*" | grep -v "^/dev/"
 echo "----------- libs ---------------"
grep -v "ENOENT$" tracer | awk '{ print $2 }' |grep ^open|sed 's/^open[0-9]*("//; s/",$//' |sort|uniq |grep -v "^/proc/" |grep "/lib.*\.so.*" | grep -v "^/dev/"

 echo "----------- proc ---------------"

awk '{ print $2 }' tracer |grep ^open|sed 's/^open[0-9]*("//; s/",$//' |grep "/proc"

 echo "----------- devices ---------------"
grep -v "ENOENT$" tracer | awk '{ print $2 }' |grep ^open|sed 's/^open[0-9]*("//; s/",$//' |sort|uniq |grep -v "^/proc/" |grep "/lib.*\.so.*" | grep "^/dev/"
err=$?

#if [ $err -eq "0" ]; then
#	echo "NOTE: program uses /proc filesystem"
#fi

