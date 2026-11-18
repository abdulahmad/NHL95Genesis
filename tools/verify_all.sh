#!/bin/bash
# verify_all.sh: the ROM under wine. Usage: tools/verify_all.sh [-q|--quiet]
# -q: print only failures and the final ALL MATCH / VERIFY FAILED line.
quiet=0; case "$1" in -q|--quiet) quiet=1;; esac
set -- "$(cd "$(dirname "$0")/.." && pwd)" build95.bat nhl95 retail
export WINEDEBUG=-all
cd "$1"; bat=$2; top=$3; ref=$4
# tools/prebuild.js runs here with Linux node (fresh extract, ROM check); the .bat files skip it (no node under wine).
export NHL_PREBUILD_DONE=1
rm -rf Extracted; node tools/prebuild.js retail >/tmp/x95.log 2>&1 || { echo "PREBUILD FAIL"; cat /tmp/x95.log; exit 1; }
rm -f output/obj/$top.bin output/obj/modified_$top.bin output/modified_$top.bin
wine cmd /c "set checksum=1&& $bat" >/tmp/top.log 2>&1
log=$(ls -t output/obj/Build*.log | head -1)
grep -qP '^[1-9]\d* error' "$log" && echo "TOP ERRORS in $log"
[ -s output/obj/$top.bin ] || echo "TOP NO BIN"
fail=0
node tools/fixopcodes.js "output/obj/$top .lst" output/obj/$top.bin >/dev/null 2>&1
mv -f output/obj/modified_$top.bin output/ 2>/dev/null
node tools/fixrom.js output/modified_$top.bin || fail=1
topmatch=$(node tools/verifyRom.js output/modified_$top.bin $ref 2>&1 | grep -iE 'match|differ' | head -2)
{ [ $quiet = 1 ] && printf '%s\n' "$topmatch" | grep -q '^MATCH:'; } || printf '%s\n' "$topmatch"
printf '%s\n' "$topmatch" | grep -q '^MATCH:' || fail=1
grep -qP '^[1-9]\d* error' "$log" && fail=1
[ -s output/obj/$top.bin ] || fail=1
if [ "$fail" = 0 ]; then
  echo ALL MATCH
else
  echo VERIFY FAILED
  exit 1
fi
