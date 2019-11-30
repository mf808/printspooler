#!/bin/bash

# turn on bash's job control
set -m

#start cupsd
/usr/sbin/cupsd -f &

# start iwatch to mopnitor direcotry
iwatch -c "lp %f; sleep 5;rm %f" -e close_write -X ".zxy" /underwatch &

fg %1
