#!/bin/bash

# Script for installing ATLauncher on Linux, Version 1.2
# Copyright (C) 2020-2021 DavidoTek

# === README ===
# Looks like you're trying to install ATLauncher.
# Just double-clicking the file may not work in your distribution.
# Try opening a terminal by right-clicking in the folder and choosing "Open Terminal here".
# 1. To make the file exectuable, type:  chmod +x linux-install-atlauncher.sh
# 2. To finally run the installer, type:  ./linux-install-atlauncher.sh
# If that doesn't work, here's more information: https://github.com/DavidoTek/linux-install-atlauncher

echo Trying to install all dependencies...

install_dependencies() {
  if which zypper > /dev/null; then
    echo Detected zypper Trying to install dependencies...
    pkexec zypper install -y java-1_8_0-openjdk unzip zenity
  elif which eopkg > /dev/null; then
    echo Detected eopkg. Trying to install dependencies...
    pkexec eopkg install -y openjdk-8 unzip zenity
  elif which apt > /dev/null; then
    echo Detected apt. Trying to install dependencies...
    pkexec apt -y install openjdk-8-jre wget unzip zenity
  elif which dnf > /dev/null; then
    echo Detected dnf. Trying to install dependencies...
    pkexec dnf -y install java-1.8.0-openjdk wget unzip zenity
  elif which pacman > /dev/null; then
    echo Detected pacman. Trying to install dependencies...
    pkexec pacman -S --noconfirm jre8-openjdk wget unzip zenity
  else
    echo -p "Cannot install dependencies. Make sure they are installed and press [ENTER]. Press Ctrl+C to cancel the installation."
  fi
}

if ! which java > /dev/null || ! which unzip > /dev/null || ! which zenity > /dev/null; then
  install_dependencies
fi

ATLAUNCHER_HOME=$HOME/Applications/ATLauncher
DESKTOP_FILE_PATH=$HOME/.local/share/applications
DESKTOP_FILE=$DESKTOP_FILE_PATH/ATLauncher.desktop
JAVA_PATH=`which java`

get_download_url() {
  curl --silent "https://api.github.com/repos/ATLauncher/ATLauncher/releases/latest" |
  grep '"browser_download_url":' |
  grep jar |
  sed -E 's/.*"([^"]+)".*/\1/'
}

get_version() {
  curl --silent "https://api.github.com/repos/ATLauncher/ATLauncher/releases/latest" |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/'
}


mkdir -p $ATLAUNCHER_HOME/bin

wget `get_download_url` -O $ATLAUNCHER_HOME/bin/ATLauncher.jar

unzip -p $ATLAUNCHER_HOME/bin/ATLauncher.jar assets/image/Icon.png > $ATLAUNCHER_HOME/Icon.png

ATLAUNCHER_VERSION=`get_version`

echo `get_version` > $ATLAUNCHER_HOME/version.txt

cat << EOF > $ATLAUNCHER_HOME/linux-update-atlauncher.sh
#!/bin/bash

# Script for updating ATLauncher on Linux

ATLAUNCHER_HOME=$ATLAUNCHER_HOME
DESKTOP_FILE=$DESKTOP_FILE

# function 'vercomp' to compare version
# Copyright 2010 Dennis Williamson  (https://stackoverflow.com/a/4025065)
# Licensed under CC BY-SA 2.5 (https://creativecommons.org/licenses/by-sa/2.5/)
vercomp () {
    if [[ \$1 == \$2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=(\$1) ver2=(\$2)
    # fill empty fields in ver1 with zeros
    for ((i=\${#ver1[@]}; i<\${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<\${#ver1[@]}; i++))
    do
        if [[ -z \${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#\${ver1[i]} > 10#\${ver2[i]}))
        then
            return 1
        fi
        if ((10#\${ver1[i]} < 10#\${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

get_download_url() {
  curl --silent "https://api.github.com/repos/ATLauncher/ATLauncher/releases/latest" |
  grep '"browser_download_url":' |
  grep jar |
  sed -E 's/.*"([^"]+)".*/\1/'
}

get_version() {
  curl --silent "https://api.github.com/repos/ATLauncher/ATLauncher/releases/latest" |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/'
}

ATLAUNCHER_VERSION=\`get_version\`
CURRENT_AT_VERSION=\`cat $ATLAUNCHER_HOME/version.txt\`

vercomp \$CURRENT_AT_VERSION \$ATLAUNCHER_VERSION

if ((\$? != 2))
then
  echo  \$CURRENT_AT_VERSION" >= "\$ATLAUNCHER_VERSION
  echo "No update available!"
  exit
fi

mkdir -p $ATLAUNCHER_HOME/bin

rm -rf $ATLAUNCHER_HOME/bin/assets
rm -rf $ATLAUNCHER_HOME/bin/cache
rm -rf $ATLAUNCHER_HOME/bin/downloads
rm -rf $ATLAUNCHER_HOME/bin/faileddownloads
rm -rf $ATLAUNCHER_HOME/bin/libraries
rm -rf $ATLAUNCHER_HOME/bin/temp

wget \`get_download_url\` -O $ATLAUNCHER_HOME/bin/ATLauncher.jar

echo \$ATLAUNCHER_VERSION > $ATLAUNCHER_HOME/version.txt

unzip -p $ATLAUNCHER_HOME/bin/ATLauncher.jar assets/image/Icon.png > $ATLAUNCHER_HOME/Icon.png

zenity --notification --text "ATLauncher was updated to \$ATLAUNCHER_VERSION."
EOF


chmod +x $ATLAUNCHER_HOME/linux-update-atlauncher.sh


cat << EOF > $ATLAUNCHER_HOME/linux-uninstall-atlauncher.sh
#!/bin/bash

# Script for uninstalling ATLauncher on Linux

if ! zenity --question --title "Uninstall ATLauncher" --text "Do you wan't to proceed? All your saved data will be deleted!"; then
  exit;
fi

ATLAUNCHER_HOME=$HOME/Applications/ATLauncher
DESKTOP_FILE=$HOME/.local/share/applications/ATLauncher.desktop

rm -rf $ATLAUNCHER_HOME
rm $DESKTOP_FILE

zenity --notification --text "Uninstalled ATLauncher \$ATLAUNCHER_VERSION."
EOF


chmod +x $ATLAUNCHER_HOME/linux-uninstall-atlauncher.sh


cat << EOF > $ATLAUNCHER_HOME/start-atlauncher.sh
#!/bin/bash

# Script for starting ATLauncher
echo Starting ATLauncher...

$JAVA_PATH -jar $ATLAUNCHER_HOME/bin/ATLauncher.jar
EOF


chmod +x $ATLAUNCHER_HOME/start-atlauncher.sh

mkdir -p $DESKTOP_FILE_PATH

cat << EOF > $DESKTOP_FILE
[Desktop Entry]
Name=ATLauncher
Version=$ATLAUNCHER_VERSION
Type=Application
Exec=$ATLAUNCHER_HOME/start-atlauncher.sh
Icon=$ATLAUNCHER_HOME/Icon.png
Categories=Game;
Terminal=false
Actions=Update;Uninstall;

[Desktop Action Update]
Name=Update
Exec=$ATLAUNCHER_HOME/linux-update-atlauncher.sh

[Desktop Action Uninstall]
Name=Uninstall
Exec=$ATLAUNCHER_HOME/linux-uninstall-atlauncher.sh
EOF


echo -e "\nInstalled ATLauncher $ATLAUNCHER_VERSION successful!"
