#!/bin/sh

case $1 in
config)
cat <<‚EOM’
graph_title Relative humidity
graph_vlabel Percent
graph_category AM2302
humidity.label RH
humidity.draw AREASTACK
humidity.colour 3E9BFB
EOM
exit 0;;
esac

printf „humidity.value ”
/opt/lol_dht22/loldht 7 | grep -i „humidity” | cut -d ‚ ‚ -f3

