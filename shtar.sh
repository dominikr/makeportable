#!/bin/sh
#
#this version should work with pretty much any shell
#
#used tools:
# dd, tr, cut, [, echo, rm, expr, mkdir, chmod, dc, grep
#
#todo: 
# -replace 'mkdir -p' with own version
# -try to use bc if dc doesn't exist
# -use shell arithmetic if available
#
add(){
	expr $1 + $2
}

oct2dec(){
	echo 8i${1}p | dc
}


fn_output() {

	if [ -f $name ]; then
		echo "ERROR: skipping $name, already exists"
		exit 1
	fi

	if [ "x$fullblock" != "x000000000" ]; then
		blocks=`oct2dec $fullblock`
		dd if=${FILE} count=$blocks skip=$num of=$name 2>/dev/null
		num=`add $num $blocks`
	fi

	if [ "x$restblock" != "x000" ]; then
		reminder=`oct2dec $restblock`
		dd if="${FILE}" count=1 skip=$num 2>/dev/null | dd bs=1 count=$reminder 2>/dev/null >> $name
		num=`add $num 1`
	fi

}



set -e
FILE=$1
export FILE
num=0


while :; do

	tmpf="/tmp/block.$$"
	dd if="${FILE}" count=1 skip=$num of=${tmpf} 2>/dev/null
	
	name=`dd if=${tmpf} bs=99 count=1 2>/dev/null | tr -d '\0'`
 	taroptions=`dd if=${tmpf} bs=1 skip=103 count=157 2>/dev/null | tr -d '\0'`
	mode=`echo $taroptions | cut -b1-4`
	fullblock=`echo $taroptions | cut -b18-26`
	restblock=`echo $taroptions | cut -b 27-29`

	if [ -z "$name" ]; then
		echo "EOF"
		rm $tmpf
		exit 0
	fi

	num=`add $num 1`

	if ( echo $name | grep '/$' >/dev/null ); then
		mkdir -p $name
	else
		fn_output

	fi

	chmod $mode $name 2> /dev/null
	echo $name

done
