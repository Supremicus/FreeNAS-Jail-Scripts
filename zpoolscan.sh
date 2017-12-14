#!/usr/local/bin/bash
#
# zpoolscan.sh Scans a pool and activates led of failed drive(s).
# Tested on Supermicro SAS2 Backplane, use at own risk.
#
# Usage: zpoolscan.sh poolname
#
# Change basedir to a suitable storage location.
basedir="/mnt/tank/scripts/zpoolscan"

if [ ! "$1" ]; then
    echo "Usage: zpoolscan.sh poolname"
    echo "Scan a pool, activates led of failed drive(s)."
    exit
fi

pool="$1"
drivesfile="$basedir/drives-$pool"
locationsfile="$basedir/locations-$pool"

if [ ! -d "$basedir" ]; then
    mkdir -p "$basedir"
fi

if [ ! -f "$drivesfile" ]; then
    touch "$drivesfile"
fi

if [ ! -f "$locationsfile" ]; then
    touch "$locationsfile"
fi

# Create a drivemap per pool. If a drive becomes degraded etc with a
# shared list the mapping will be missing if other pool is ok.
if [ ! -f "$basedir/drivemap-$pool" ]; then
    echo "Creating drive map."
    glabel status | awk '{print "s|"$1"|"$3"|g"}' > "$basedir/drivemap-$pool"
fi

condition=$(zpool status "$pool" | grep -E '(DEGRADED|FAULTED|OFFLINE|UNAVAIL|REMOVED|FAIL|DESTROYED|corrupt|cannot|unrecover)')
if [ "${condition}" ]; then
    drivelist=$(zpool status "$pool" | sed -f "$basedir/drivemap-$pool" | sed 's/p[0-9]//' | grep -E "(DEGRADED|FAULTED|OFFLINE|UNAVAIL|REMOVED|FAIL|DESTROYED)" | grep -vE "^\\W+($pool|NAME|mirror|raidz|stripe|logs|spares|state)" | sed -E 's/.*was[[:space:]]\/dev\/([0-9a-z]+)/\1/')
    echo "Locating failed drives."
    for drive in $drivelist; do
        record=$(grep -E "$drive" "$drivesfile")
        location=$(echo "$record" | cut -f 3 -d " ")
        echo Locating: "$record"
        sas2ircu 0 locate "$location" ON
        if [ ! "$(grep -q "$location" "$locationsfile")" ]; then
            echo "$location" >> "$locationsfile"
        fi
    done
    exit 1
else
    echo "Updating drive map."
    glabel status | awk '{print "s|"$1"|"$3"|g"}' > "$basedir/drivemap-$pool"
    drivelist=$(zpool status "$pool" | sed -f "$basedir/drivemap-$pool" | sed 's/p[0-9]//' | grep -E "^[[:space:]]{4}" | sed -E 's/[[:space:]]+//;s/([a-z0-9]+).*/\1/')
    saslist=$(sas2ircu 0 display)
    printf "" > "$drivesfile"
    for drive in $drivelist; do
        sasaddr=$(sg_vpd -i -q "$drive" 2>/dev/null | sed -E '2!d;s/,.*//;s/  0x//;s/([0-9a-f]{7})([0-9a-f])([0-9a-f]{4})([0-9a-f]{4})/\1-\2-\3-\4/')
        encaddr=$(echo "$saslist" | grep "$sasaddr" -B 2 | sed -E 'N;s/^.*: ([0-9]+)\n.*: ([0-9]+)/\1:\2/')
        echo "$drive" "$sasaddr" "$encaddr" >> "$drivesfile"
    done

    if [[ -s "$locationsfile" ]]; then
        for loc in $(cat "$locationsfile"); do
            sas2ircu 0 locate "$loc" OFF
        done
        printf "" > "$locationsfile"
    fi
fi
