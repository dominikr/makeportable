#!/usr/bin/env bash
#
# (c) terreActive AG
#
# $Id: jailfiles.sh 21268 2011-05-12 15:33:27Z dominik $
# $HeadURL: http://zak/svn/taclog/branches/TACLOG-2-10-10-feature-OEMspacemgr/tac/jail/jailfiles.sh $
# Purpose: adds all needed static files to a chroot jail
#
# 3456789A123456789B123456789C123456789D123456789E123456789F123456789G12345678
#

. ./common.sh || echo "FATAL: common.sh not found" >&2

DEST=${1:-''}

checkdir "$DEST" "destination"

while read file; do {
        fn=`echo "${file}"  | sed 's|^/*||'`
        if [ -d $file ]; then
                echo "dir: $fn $file"
                mkdir -p ${DEST}/${fn}
        else
                path=`dirname $file`
                pn=`echo "${path}"  | sed 's|^/*||'`
                echo cp $file ${DEST}/${pn}
                if [ ! -d ${DEST}/${pn} ]; then
                        mkdir -p ${DEST}/${pn}
                fi

                cp $file ${DEST}/${pn}

        fi


} done

end

#
# EOF
#
