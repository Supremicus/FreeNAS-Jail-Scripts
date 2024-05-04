#!/bin/sh
#
# SABnzbd update script
# Usage: ./updatesab.sh
#
# Change PARENTPATH to directory where sabnzbd directory is located.

VERSION="0.2"
SCRIPTNAME=$(echo $0 | sed "s|^\./||")
PARENTPATH="/usr/local/share"

splash() {
clear
printf "[m
[49m   [38;2;8;6;2;48;2;0;0;0m▄[38;2;239;201;65;48;2;0;0;0m▄[38;2;240;202;65;48;2;0;0;0m▄▄▄▄▄▄▄▄▄▄[38;2;221;172;45;48;2;0;0;0m▄[m
[49m   [48;2;8;6;2m [38;2;235;180;48;48;2;237;190;56m▄[48;2;240;202;65m         [38;2;240;202;66;48;2;240;202;65m▄[38;2;222;172;45;48;2;222;173;45m▄[49m        [48;2;255;255;255m   [48;2;0;0;0m [49m                    [48;2;0;0;0m [48;2;255;255;255m   [49m        [48;2;0;0;0m [48;2;255;255;255m   [m
[49m   [48;2;8;6;2m [48;2;235;180;48m [38;2;0;0;0;48;2;5;1;0m▄[38;2;255;255;255;48;2;0;0;0m▄▄▄▄▄▄▄▄[48;2;0;0;0m [38;2;255;255;255;48;2;0;0;0m▄▄▄▄▄▄▄▄[38;2;0;0;0;48;2;0;0;0m▄[48;2;255;255;255m  [38;2;255;255;255;48;2;255;255;255m▄[38;2;255;255;255;48;2;0;0;0m▄▄▄▄[38;2;0;0;0;48;2;0;0;0m▄[38;2;0;0;0;48;2;0;0;0m[38;2;255;255;255;48;2;0;0;0m▄▄▄▄▄▄▄[48;2;0;0;0m [38;2;255;255;255;48;2;0;0;0m▄▄▄▄▄▄▄▄[48;2;0;0;0m [48;2;255;255;255m   [38;2;255;255;255;48;2;0;0;0m▄▄▄▄[48;2;0;0;0m [38;2;255;255;255;48;2;0;0;0m▄▄▄▄[48;2;255;255;255m   [m
[49m   [48;2;8;6;2m [48;2;235;180;48m [48;2;0;0;0m [48;2;255;255;255m   [48;2;0;0;0m           [48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m   [38;2;0;0;0;48;2;0;0;0m▄[48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m   [38;2;0;0;0;48;2;0;0;0m▄[48;2;255;255;255m   [48;2;0;0;0m  [38;2;0;0;0m▄▄▄[48;2;255;255;255m  [38;2;255;255;255;48;2;255;255;255m▄[48;2;255;255;255m [48;2;0;0;0m [48;2;255;255;255m   [38;2;0;0;0;48;2;0;0;0m▄[48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m   [38;2;0;0;0;48;2;0;0;0m▄[48;2;255;255;255m   [m
[48;2;0;0;0m [38;2;233;179;47;48;2;0;0;0m▄[38;2;235;180;48;48;2;0;0;0m▄[38;2;235;180;48;48;2;8;6;2m▄[48;2;235;180;48m [48;2;0;0;0m [38;2;0;0;0;48;2;255;255;255m▄▄▄▄[38;2;0;0;0;48;2;255;255;255m▄[48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m [48;2;255;255;255m  [38;2;0;0;0;48;2;255;255;255m▄[38;2;0;0;0;48;2;255;255;255m▄[48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m  [48;2;255;255;255m [48;2;0;0;0m [48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m   [48;2;0;0;0m [38;2;255;255;255;48;2;0;0;0m▄▄[48;2;255;255;255m  [38;2;0;0;0;48;2;255;255;255m▄▄[38;2;0;0;0;48;2;255;255;255m[48;2;0;0;0m   [48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m   [m
[49m [49;38;2;2;1;0m▀[38;2;0;0;0;48;2;233;179;47m▄[38;2;234;179;47;48;2;235;180;48m▄[48;2;235;180;48m [48;2;0;0;0m [38;2;255;255;255;48;2;0;0;0m▄▄▄▄▄[48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m   [38;2;255;255;255;48;2;0;0;0m▄▄[48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m  [38;2;255;255;255;48;2;255;255;255m▄[38;2;255;255;255;48;2;0;0;0m▄[38;2;255;255;255;48;2;255;255;255m▄[48;2;255;255;255m  [48;2;0;0;0m [48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m [48;2;255;255;255m  [48;2;0;0;0m [48;2;255;255;255m   [38;2;255;255;255;48;2;255;255;255m▄[38;2;255;255;255;48;2;0;0;0m▄▄▄▄[48;2;0;0;0m [48;2;255;255;255m   [38;2;255;255;255;48;2;0;0;0m▄[48;2;255;255;255m   [48;2;0;0;0m [48;2;255;255;255m  [38;2;255;255;255;48;2;255;255;255m▄[38;2;255;255;255;48;2;0;0;0m▄[48;2;255;255;255m   [m
[49m   [49;38;2;1;0;0m▀[38;2;6;5;0;48;2;234;179;48m▄[38;2;234;180;48;48;2;66;50;13m▄[38;2;235;180;48;48;2;31;29;25m▄▄[38;2;239;201;65;48;2;31;30;25m▄[38;2;240;202;65;48;2;31;30;25m▄▄[38;2;234;179;47;48;2;31;30;25m▄[38;2;235;180;48;48;2;31;29;25m▄[38;2;235;180;48;48;2;31;29;24m▄[38;2;33;25;7;48;2;10;8;2m▄[m
[49m     [49;38;2;0;0;0m▀[38;2;4;4;0;48;2;235;180;48m▄[48;2;235;180;48m [38;2;235;180;48;48;2;237;191;56m▄[48;2;240;202;65m  [48;2;235;180;48m [38;2;91;70;18;48;2;235;180;48m▄[38;2;0;0;0;48;2;83;63;17m▄[49;38;2;0;0;0m▀[38;2;255;255;255m                                    Update Script[m
[49m       [49;38;2;3;1;0m▀[38;2;3;2;0;48;2;235;180;48m▄[38;2;237;192;58;48;2;240;202;65m▄[38;2;147;113;30;48;2;234;179;48m▄[38;2;0;0;0;48;2;124;95;25m▄[49;38;2;0;0;0m▀[1;32m                                              v[38;2;255;255;255m ${VERSION}[m
[49m         [49;38;2;0;0;0m▀▀[m
";
}

check_internet() {
    # Check if theres an internet connection, if not exit.
    echo -n "[[1m$SCRIPTNAME[0m] [1;32m:[0m Checking for Internet Connection[0m..." & progress
    INTERNET=$(ping -c1 google.com 2>&1 | grep unknown)
    if [ ! "$INTERNET" = "" ]; then
        echo " [1;31mNot Available[0m."
        echo "[[1m$SCRIPTNAME[0m] [1;32m:[0m Exiting[0m..."
        exit 0
    else
        echo " [1;32mAvailable[0m."
    fi
}

progress()
{   local pid=$!
    local spinstr='/-\|'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [[1;32m%c[0m]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep 0.5
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

update_sab() {
    if [ -d $PARENTPATH/sabnzbd ]; then
        if [ ! -f $PARENTPATH/sabnzbd/sabnzbd/version.py ]; then
            echo -n "[[1m$SCRIPTNAME[0m] [1;32m:[0m Unable to determine SABnzbd version, please upgrade manually..."
            echo " [1;31mExiting[0m."
            echo
            exit 0
        fi

        check_internet

        CURRENT_VERSION=$(cat /usr/local/share/sabnzbd/sabnzbd/version.py | grep '__version__ = ' | sed 's/__version__ = "\(.*\)"/\1/g')
        LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/sabnzbd/sabnzbd/releases/latest)
        LATEST_VERSION=$(echo $LATEST_RELEASE | sed 's/.*"tag_name":[^"]*"\([^"]*\)".*/\1/')

        if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
            echo -n "[[1m$SCRIPTNAME[0m] [1;32m:[0m Already running latest version..."
            echo " [1;31mExiting[0m."
            echo
            exit 0
        fi

        echo "[[1m$SCRIPTNAME[0m] [1;32m:[0m Update found."
        echo -n "[[1m$SCRIPTNAME[0m] [1;32m:[0m Downloading [1mSABnzbd-$LATEST_VERSION[0m..."
        SOURCE_URL=https://github.com/sabnzbd/sabnzbd/releases/download/$LATEST_VERSION/SABnzbd-$LATEST_VERSION-src.tar.gz
        fetch -o $PARENTPATH/SABnzbd-$LATEST_VERSION.tar.gz $SOURCE_URL >/dev/null 2>&1 & progress
        if [ $? -ne 0 ]; then
            echo " [1;31mFailed[0m."
            echo
            exit 0
        else
            echo " [1;32mDone[0m."
        fi

        if [ -d $PARENTPATH/sabnzbd.bak ]; then
            echo -n "[[1m$SCRIPTNAME[0m] [1;32m:[0m Removing previous SABnzbd backup..."
            rm -rf $PARENTPATH/sabnzbd.bak 2>&1
            echo " [1;32mDone[0m."
        fi

        echo -n "[[1m$SCRIPTNAME[0m] [1;32m:[0m Stopping SABnzbd..."
        service sabnzbd stop >/dev/null
        echo " [1;32mDone[0m."

        echo -n "[[1m$SCRIPTNAME[0m] [1;32m:[0m Moving current SABnzbd installation to backup location..."
        mv $PARENTPATH/sabnzbd/ $PARENTPATH/sabnzbd.bak/ 2>&1
        echo " [1;32mDone[0m."

        echo -n "[[1m$SCRIPTNAME[0m] [1;32m:[0m Updating SABnzbd from [1m$CURRENT_VERSION[0m to [1m$LATEST_VERSION[0m..."
        mkdir $PARENTPATH/sabnzbd/ 2>&1
        tar -xz --strip-components 1 --file $PARENTPATH/SABnzbd-$LATEST_VERSION.tar.gz --directory $PARENTPATH/sabnzbd/ >/dev/null 2>&1 & progress
        if [ $? -ne 0 ]; then
            echo " [1;31mFailed[0m."
            echo -n "[[1m$SCRIPTNAME[0m] [1;32m:[0m Error extracting SABnzbd-$LATEST_VERSION.tar.gz, Rolling back to previous version..."
            rm -rf $PARENTPATH/sabnzbd/ 2>&1
            mv $PARENTPATH/sabnzbd.bak/ $PARENTPATH/sabnzbd/ 2>&1
            echo " [1;32mDone[0m."
        else
            echo " [1;32mDone[0m."
        fi
        rm $PARENTPATH/SABnzbd-$LATEST_VERSION.tar.gz

        echo -n "[[1m$SCRIPTNAME[0m] [1;32m:[0m Starting SABnzbd..."
        service sabnzbd start >/dev/null
        echo " [1;32mDone[0m."

    else
        echo -n "[[1m$SCRIPTNAME[0m] [1;32m:[0m SABnzbd path '[96m$SABNZBDPATH[0m' not found, please check path..."
        echo " [1;31mExiting[0m."
    fi
}

# Run all the things.
splash
update_sab

echo
