#!/usr/bin/env sh

set -e

prefix="${XDG_DATA_HOME:-$HOME/.local/share}"
krunner_dir="$prefix/krunner"
krunner_dbusdir="$krunner_dir/dbusplugins"

rm $prefix/dbus-1/services/org.kde.krunner_emacs.service
rm $krunner_dbusdir/krunner_emacs.desktop
rm $krunner_dir/krunner_emacs.el

kquitapp6 krunner
