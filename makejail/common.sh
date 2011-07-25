#
# (c) terreActive AG
#
# $Id: common.sh 21970 2011-07-14 15:14:12Z dominik $
# $HeadURL: http://zak/svn/taclog/branches/TACLOG-2-10-10-feature-OEMspacemgr/tac/jail/common.sh $
# Purpose: common functions for the jailbuild tools
#
# 3456789A123456789B123456789C123456789D123456789E123456789F123456789G12345678
#

# early check for bash
if test -z "$BASH_VERSION"
then
	echo "FATAL: This script needs bash to run" >&2
	exit 2
fi

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


if [ ${BASH_VERSINFO[0]} -lt 3 ]; then
	die "This script needs Bash v3 or higher"
fi

set -o errexit
set -o pipefail
set -o nounset

#NOTE: we have to include $LINENO here and not in the die command
#it would else show the line in the die function...
trap 'die "killed by signal, line $LINENO"' INT TERM HUP
trap 'die "failed command, line $LINENO"' ERR
trap 'die "unexpected exit, line $LINENO"' EXIT

#
# EOF
#