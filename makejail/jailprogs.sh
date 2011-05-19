#!/usr/bin/env bash
#
# (c) terreActive AG
#
# $Id: jailprogs.sh 21268 2011-05-12 15:33:27Z dominik $
# $HeadURL: http://zak/svn/taclog/branches/TACLOG-2-10-10-feature-OEMspacemgr/tac/jail/jailprogs.sh $
# Purpose: populates a chroot jail with programs
#
# 3456789A123456789B123456789C123456789D123456789E123456789F123456789G12345678
#

. ./common.sh || echo "FATAL: common.sh not found" >&2

DEST=${1:-''}
PATH="/usr/local/bin:/usr/bin:/bin:/usr/lib"

checkdir "$DEST" "destination"

while read file; do {
        fp=`which $file` || die "which \"${file}\" returned an error"
	if [ -z "$fp" ] || [ ! -f "$fp" ]; then
		die "Could not find \"${file}\" command"
	fi
	install_prog $fp
} done

end

#
# EOF
#
