#!/bin/sh

# set -e

which butler

echo "Checking application versions..."
echo "-----------------------------"
cat ~/.local/share/godot/templates/3.3.stable/version.txt
godot --version
butler -V
echo "-----------------------------"

mkdir build/
mkdir build/linux/
mkdir build/osx/
mkdir build/win/

echo "EXPORTING FOR LINUX"
echo "-----------------------------"
godot --export "Linux/X11" build/linux/pack-hunters.x86_64 -v
# echo "EXPORTING FOR OSX"
# echo "-----------------------------"
# godot --export "Mac OSX" build/osx/pack-hunters.dmg -v
echo "EXPORTING FOR WINDOZE"
echo "-----------------------------"
godot --export-debug "Windows Desktop" build/win/pack-hunters.exe -v
echo "-----------------------------"

# echo "CHANGING FILETYPE AND CHMOD EXECUTABLE FOR OSX"
# echo "-----------------------------"
# cd build/osx/
# mv pack-hunters.dmg pack-hunters-osx-alpha.zip
# unzip pack-hunters-osx-alpha.zip
# rm pack-hunters-osx-alpha.zip
# chmod +x pack-hunters.app/Contents/MacOS/pack-hunters
# zip -r pack-hunters-osx-alpha.zip pack-hunters.app
# rm -rf pack-hunters.app
# cd ../../

ls -al
ls -al build/
ls -al build/linux/
ls -al build/osx/
ls -al build/win/

echo "ZIPPING FOR WINDOZE"
echo "-----------------------------"
cd build/win/
zip -r pack-hunters-win-alpha.zip pack-hunters.exe pack-hunters.pck
rm -r pack-hunters.exe pack-hunters.pck
cd ../../

echo "ZIPPING FOR LINUX"
echo "-----------------------------"
cd build/linux/
zip -r pack-hunters-linux-alpha.zip pack-hunters.x86_64 pack-hunters.pck
rm -r pack-hunters.x86_64 pack-hunters.pck
cd ../../

echo "Logging in to Butler"
echo "-----------------------------"
butler login

echo "Pushing builds with Butler"
echo "-----------------------------"
butler push build/linux/ synsugarstudio/uigj-2022:linux-alpha
# butler push build/osx/ synsugarstudio/uigj-2022:osx-alpha
butler push build/win/ synsugarstudio/uigj-2022:win-alpha
