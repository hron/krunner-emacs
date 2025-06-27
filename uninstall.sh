#!/bin/bash

# Exit if something fails
set -e

prefix="${XDG_DATA_HOME:-$HOME/.local/share}"
krunner_dbusdir="$prefix/krunner/dbusplugins"

rm $prefix/dbus-1/services/org.kde.krunner_emacs.service
rm $krunner_dbusdir/krunner_emacs.desktop
kquitapp6 krunner
