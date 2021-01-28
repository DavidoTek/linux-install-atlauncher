# Unofficial ATLauncher installer for Linux
Unofficial installer for the [ATLauncher](https://atlauncher.com/) Minecraft Launcher for distros like Ubuntu, Fedora Manjaro, openSUSE and Solus.

## Usage
Open a Terminal and type following commands:  
`wget https://raw.githubusercontent.com/DavidoTek/linux-install-atlauncher/master/linux-install-atlauncher.sh`

`chmod +x linux-install-atlauncher.sh`

`./linux-install-atlauncher.sh`

ATLauncher should be installed automatically in `~/Applications/ATLauncher/`.

### Update / Uninstall
To update/uninstall ATLauncher, right click on ATLauncher and select update or uninstall. ATLauncher will be removed including all saves (worlds, screenshots, texturepacks, ...).

## Dependencies
Dependencies are **Java 8**, `wget`, `unzip` and `zenity`. They should be preinstalled on most modern Linux distributions. If not, the installer tries to install them automatically.  
Note: If you have multiple Java versions installed, you might need to change the Java Path to Java 8 in the ATLauncher settings.

## Troubleshooting / FAQ

### "Cannot install dependencies. Make sure they are installed and press [ENTER]"
The installer failed installing all dependencies. This may be the case on distribution other than Ubuntu, Fedora or Manjaro.  
Try to install them manually.

### How to reinstall without loosing data
To reinstall `ATLauncher.jar`, right click ATLauncher and choose `update`.  
If this isn't working, go to `~/Applications/ATLauncher/bin` and delete all files/folders **except** `backups`, `instances` and `servers`. Then right click ATLauncher and choose `update`.

## LICENSE
Copyright (c) 2020 DavidoTek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

'vercomp' function by Dennis Williamson licesensed under CC BY-SA 3.0 (Copyright 2010).
Link: https://stackoverflow.com/a/4025065 (License: https://creativecommons.org/licenses/by-sa/3.0/)
