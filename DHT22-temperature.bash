#!/bin/sh

case $1 in
config)
cat <<‚EOM’
graph_title Temperature
graph_vlabel Celsius
graph_category AM2302
temperature.label Celsius
temperature.label Temperature
temperature.draw AREASTACK
temperature.colour 00FF00
EOM
exit 0;;
esac

printf „temperature.value ”
/opt/lol_dht22/loldht 7 | grep -i „temperature” | cut -d ‚ ‚ -f7