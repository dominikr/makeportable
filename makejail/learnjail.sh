#!/usr/bin/env bash
#
# (c) terreActive AG
#
# $Id: learnjail.sh 21970 2011-07-14 15:14:12Z dominik $
# $HeadURL: http://zak/svn/taclog/branches/TACLOG-2-10-10-feature-OEMspacemgr/tac/jail/learnjail.sh $
# Purpose: automatically gather which files are needed by an executable
#
# 3456789A123456789B123456789C123456789D123456789E123456789F123456789G12345678
#

. ./common.sh || { echo "FATAL: common.sh not found" >&2; exit 2; }

truss -f -t open -o tracer "$@"

echo "----------- files ---------------"
grep -v "ENOENT$" tracer | awk '{ print $2 }' |grep ^open|sed 's/^open[0-9]*("//; s/",$//' |sort|uniq |grep -v "^/proc/" |grep -v "/lib.*\.so.*" | grep -v "^/dev/" || true

echo "----------- libs ----------------"
grep -v "ENOENT$" tracer | awk '{ print $2 }' |grep ^open|sed 's/^open[0-9]*("//; s/",$//' |sort|uniq |grep -v "^/proc/" |grep "/lib.*\.so.*" | grep -v "^/dev/" || true

echo "----------- proc ----------------"
awk '{ print $2 }' tracer |grep ^open|sed 's/^open[0-9]*("//; s/",$//' |grep "/proc" || true

echo "----------- devices -------------"
grep -v "ENOENT$" tracer | awk '{ print $2 }' |grep ^open|sed 's/^open[0-9]*("//; s/",$//' |sort|uniq |grep -v "^/proc/" |grep "/lib.*\.so.*" | grep "^/dev/" || true

end

#
# EOF
#