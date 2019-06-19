#!/bin/sh -e

if [ $# -gt 2 ]; then
	IN=$2
	OUT=$3
else
	IN=/tmp/pcl.in
	OUT=/tmp/pcl.out
fi

rm "$IN" "$OUT" | true
mkfifo "$IN"
mkfifo "$OUT"
sbcl --script pipe-cl.lisp "$IN" "$OUT"
rm "$IN"
rm "$OUT"
