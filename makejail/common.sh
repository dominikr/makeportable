#
# (c) terreActive AG
#
# $Id: common.sh 21268 2011-05-12 15:33:27Z dominik $
# $HeadURL: http://zak/svn/taclog/branches/TACLOG-2-10-10-feature-OEMspacemgr/tac/jail/common.sh $
# Purpose: common functions for the jailbuild tools
#
# 3456789A123456789B123456789C123456789D123456789E123456789F123456789G12345678
#

function die {
	echo "ERROR: $1 (${0}, `date`)" >&2
	trap - EXIT
	exit 1
}

function end {
	trap - EXIT
	exit 0
}

function checkdir {
	name=${1:-''}	
	type=${2}

	if [ -z "$name" ]; then
		die "no ${type} directory specified"
	elif [ ! -d "$name" ]; then
		die "$type directory \"${name}\" does not exist"
	fi
}

function install_prog {
	if [ -z "${JAILBUILD_INSTALL_CMD}" ]; then
        	INSTALL="cp -p"
	else
        	INSTALL="${JAILBUILD_INSTALL_CMD}" 
	fi

	file=$1
        if [ ! -f "$file" ]; then
                die "$file is not a file"
        fi  
        echo "installing $file into ${DEST}"
        cmd="${INSTALL} $file ${DEST}"
        $cmd
        err=$?
        if [ $err -ne 0 ]; then
                die "install for \"$file\" failed with error $err (was \"${cmd}\")"
        fi

}


if [ -z $BASH_VERSION ]; then
	die "This script needs bash to run"
elif [ ${BASH_VERSINFO[0]} -lt 3 ]; then
	die "This script needs Bash v3 or higher"
fi

set -o errexit
set -o pipefail
set -o nounset
trap 'die "killed by signal"' INT TERM HUP
trap 'die "failed command"' ERR
trap 'die "unexpected exit"' EXIT


#
# EOF
#
