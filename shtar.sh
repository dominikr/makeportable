#!/bin/bash
#
#works with bash, mksh, ksh93 at the moment


set -e
FILE=$1
export FILE
num=0
#set -o pipefail


while true; do

	tmpf="/tmp/block.$$"
	dd if="${FILE}" count=1 skip=$num of=${tmpf} 2>/dev/null
	
	name=`dd if=${tmpf} bs=99 count=1 2>/dev/null | tr -d '\0'`
 	options=`dd if=${tmpf} bs=1 skip=103 count=157 2>/dev/null | tr -d '\0'`
	mode=${options:0:4}
	fullblock=${options:17:9}
	restblock=${options:26:3}
	echo "SIZE: $fullblock $restblock"

	if [ -z "$name" ]; then
		echo "zero-size name, EOF?"
		rm $tmpf
		exit 0
	fi

	blocks=$(( 8#$fullblock ))
	
	num2=$(( $num + 1 ))
	foo=$(( $num2 + $blocks ))	


	if [ "x$restblock" != "x000" ]; then
		reminder=$(( 8#$restblock ))
		num=$(( $foo + 1 ))
	else
		reminder=0
		num=$foo
	fi

	if [ "x${name: -1}" = "x/" ]; then
		mkdir -p $name
	else

		if [ -f $name ]; then
			echo "ERROR: skipping $name, already exists"
			return
		fi

		dd if=${FILE} count=$blocks skip=$num2 of=$name 2>/dev/null
		echo "blocks $blocks skip $num2"

		if [ "x$reminder" != "x0" ]; then
			dd if="${FILE}" count=1 skip=$foo 2>/dev/null | dd bs=1 count=$reminder 2>/dev/null >> $name
		fi

		chmod $mode $name

	fi

	echo $name

done
