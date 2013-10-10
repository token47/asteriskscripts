#!/bin/bash

# Nov/2011 Andre Ruiz <andre (dot) ruiz (at) gmail (dot) com>
#
# Do not run this while in production!!!
# Download all the codecs you want in one dir, put this script
# in the same dir and run it like "test_codecs.sh | tee output.log"
# Then inspect the log to see where the best numbers are

set -u

target="/usr/lib64/asterisk/modules/codec_g729.so"

[ -f "${target}" ] && mv -f "${target}"{,_orig}

for codecfile in codec_g729*.so; do
	echo; echo; echo
	echo "===================== Module: $codecfile ==========================="
	cp -fv "$codecfile" "${target}"
	chown root.root "${target}"
	chmod +rx "${target}"
	service asterisk restart
	sleep 3
	echo
	echo "====> Did it load?"
	rasterisk -x "module show like 729"
	echo
	echo "====> How is performance?"
	for x in 1 2 3; do
		echo
		echo "Take $x"
		rasterisk -x "core show translation recalc 50"
		sleep 2
	done
done

rm -f "${target}"
[ -f "${target}_orig" ] && mv -f "${target}"{_orig,}
service asterisk restart
echo
echo "Finished."

