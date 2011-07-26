#!/bin/bash

output(){
	name=$1
	mode=$2
	blocks=$3
	num=$4
	reminder=$5
	num2=$(( $num + 1 ))
	foo=$(( $num + 1 + $blocks ))	

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
}

set -e
FILE=$1
export FILE
num=0
#set -o pipefail


while true; do

	tmpf="/tmp/block.$$"
	dd if="${FILE}" count=1 skip=$num of=${tmpf} 2>/dev/null
	
	#name=`dd if=${tmpf} bs=99 count=1 2>/dev/null`
	#options=`dd if=${tmpf} bs=1 skip=100 count=157 2>/dev/null`
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

	#size=$(( 8#$size ))
	#blocks=$(( $size / 512  ))
	#reminder=$(( $size % 512 ))
	#if [ $reminder -gt 0 ]; then
	#	blocks=$(( $blocks + 1 ))
	#fi


	blocks=$(( 8#$fullblock ))

	if [ "x$restblock" != "x000" ]; then
		reminder=$(( 8#$restblock ))
		rest=1
	else
		reminder=0
		rest=0
	fi



	if `echo "$name" | grep '/$' > /dev/null`; then
		mkdir -p $name
	else
		output $name $mode $blocks $num $reminder
	fi

	num=$(( $num + 1 + $blocks + $rest ))
	echo $name

done
