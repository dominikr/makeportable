#!/bin/bash

block(){
	dd if="${FILE}" count=1 skip=$1 2> /dev/null
}


output(){
	name=$1
	mode=$2
	blocks=$3
	num=$4
	reminder=$5
	num2=$(( $num + 1 ))
	b=$(( $blocks - 1 ))
	
	if [ -f $name ]; then
		echo "ERROR: skipping $name, already exists"
		return
	fi

	if [ "x$reminder" = "x0" ]; then
		dd if="${FILE}" count=$blocks skip=$num2 of=$name 2> /dev/null

	else
		if [ $blocks -gt 1 ]; then
			dd if="${FILE}" count=$b skip=$num2 of=$name 2> /dev/null
			#echo dd if="${FILE}" count=$b skip=$num2 of=$name
		fi
		
		skip2=$(( $num2 + $b ))
		dd if="${FILE}" count=$blocks skip=$skip2 2> /dev/null | dd bs=1 count=$reminder 2> /dev/null >> $name
		#echo "dd if=${FILE} count=$blocks skip=$skip2 2> /dev/null | dd bs=1 count=$reminder 2> /dev/null >> $name"
	fi
	chmod $mode $name
	#echo "OUTPUT $name $block $reminder"
}

set -e
PATH="/usr/xpg4/bin:$PATH"
export PATH
FILE=$1
export FILE
num=0

while true; do

	data=`block $num | tr -s '\0' ' '`

	name=`echo $data | awk '{ print $1 }'`
	size=`echo $data | awk '{ print $5 }'`
	mode=`echo $data | awk '{ print $2 }' | sed 's/^...//'`
	size=$(( 8#$size ))
	blocks=$(( $size / 512  ))
	reminder=$(( $size % 512 ))
	if [ $reminder -gt 0 ]; then
		blocks=$(( $blocks + 1 ))
	fi

	if [ -z $name ]; then
		echo "zero-size name, EOF?"
		exit 0
	fi


	if `echo "$name" | grep '/$' > /dev/null`; then
		mkdir -p $name
	else
		output $name $mode $blocks $num $reminder
	fi


	num=$(( $num + 1 + $blocks ))
	#echo FILE $name $size $blocks $mode
	echo $name

	#echo -e "\t$data"
done
