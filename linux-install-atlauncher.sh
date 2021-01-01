#!/bin/bash

# Script for installing ATLauncher on Linux, Version 0.1
# Copyright (C) 2020 DavidoTek

echo Trying to install all dependencies...

if which zypper > /dev/null; then
  echo Detected zypper Trying to install dependencies...
  pkexec zypper install -y java-1_8_0-openjdk unzip zenity
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



cat << EOF > $ATLAUNCHER_HOME/linux-update-atlauncher.sh
#!/bin/bash

# Script for updating ATLauncher on Linux

ATLAUNCHER_HOME=$ATLAUNCHER_HOME
DESKTOP_FILE=$DESKTOP_FILE

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

ATLAUNCHER_VERSION=`get_version`

mkdir -p $ATLAUNCHER_HOME/bin

rm -rf $ATLAUNCHER_HOME/bin/assets
rm -rf $ATLAUNCHER_HOME/bin/cache
rm -rf $ATLAUNCHER_HOME/bin/downloads
rm -rf $ATLAUNCHER_HOME/bin/faileddownloads
rm -rf $ATLAUNCHER_HOME/bin/libraries
rm -rf $ATLAUNCHER_HOME/bin/temp

wget `get_download_url` -O $ATLAUNCHER_HOME/bin/ATLauncher.jar

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

mkdir -p $DESKTOP_FILE_PATH

cat << EOF > $DESKTOP_FILE
[Desktop Entry]
Name=ATLauncher
Version=$ATLAUNCHER_VERSION
Type=Application
Exec=$JAVA_PATH -jar $HOME/Applications/ATLauncher/bin/ATLauncher.jar
Icon=$HOME/Applications/ATLauncher/Icon.png
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
