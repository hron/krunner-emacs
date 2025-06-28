#!/usr/bin/env sh

set -e

prefix="${XDG_DATA_HOME:-$HOME/.local/share}"
krunner_dir="$prefix/krunner"
krunner_dbusdir="$krunner_dir/dbusplugins"
services_dir="$prefix/dbus-1/services/"

mkdir -p $krunner_dbusdir
mkdir -p $services_dir

cp krunner_emacs.el $krunner_dir
cp krunner_emacs.desktop $krunner_dbusdir
cat <<EOF > $services_dir/org.kde.krunner_emacs.service
[D-BUS Service]
Name=org.kde.krunner_emacs
Exec=emacs -Q --debug-init --fg-daemon=krunner_emacs --load $krunner_dir/krunner_emacs.el
Type=Application
EOF

kquitapp6 krunner
