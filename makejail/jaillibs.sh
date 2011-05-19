#!/usr/bin/env bash
#
# (c) terreActive AG
#
# $Id: jaillibs.sh 21268 2011-05-12 15:33:27Z dominik $
# $HeadURL: http://zak/svn/taclog/branches/TACLOG-2-10-10-feature-OEMspacemgr/tac/jail/jaillibs.sh $
# Purpose: automatically adds all needed libraries to a chroot jail
#
# 3456789A123456789B123456789C123456789D123456789E123456789F123456789G12345678
#

. ./common.sh || echo "FATAL: common.sh not found" >&2

SRC=${1:-''}
DEST=${2:-''}

PATH="/usr/local/bin:/usr/bin:/bin"

checkdir "$SRC" "source"
checkdir "$DEST" "destination"

file --help 2> /dev/null > /dev/null
err=$?
if [ $err -ne 0 ]; then
	die "You need GNU file, Solaris file is buggy"
fi

find ${SRC} -xdev -type f -exec file {} \; \
| grep ELF \
| awk -F: '{ print $1 }' \
| while read file; do {
	ldd ${file} 
}
done \
| awk '{ print $3 }' \
| sed 's|//*|/|' \
| sort \
| uniq \
| grep "/" \
| while read file; do {
	install_prog $file
} done

end

#
# EOF
#
