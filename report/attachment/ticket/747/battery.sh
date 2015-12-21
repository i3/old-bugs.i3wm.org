#!/bin/bash
#
# battery status script
#

battery=/proc/acpi/battery/BAT0

remaining_cap=`grep "^remaining capacity" /proc/acpi/battery/BAT0/state | awk '{ print $3 }'`
last_full_cap=`grep "^last full capacity" /proc/acpi/battery/BAT0/info | awk '{ print $4 }'`
design_cap=`grep "^design capacity:" /proc/acpi/battery/BAT0/info | awk '{ print $3 }'`

echo "from last full capacity: $(( $remaining_cap * 100 / $last_full_cap ))%"
echo "from design capacity: $(( $remaining_cap * 100 / $design_cap ))%"

