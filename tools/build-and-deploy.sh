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
godot --export "Linux/X11" build/linux/uigj-2022.x86_64 -v
# echo "EXPORTING FOR OSX"
# echo "-----------------------------"
# godot --export "Mac OSX" build/osx/uigj-2022.dmg -v
echo "EXPORTING FOR WINDOZE"
echo "-----------------------------"
godot --export-debug "Windows Desktop" build/win/uigj-2022.exe -v
echo "-----------------------------"

# echo "CHANGING FILETYPE AND CHMOD EXECUTABLE FOR OSX"
# echo "-----------------------------"
# cd build/osx/
# mv uigj-2022.dmg uigj-2022-osx-alpha.zip
# unzip uigj-2022-osx-alpha.zip
# rm uigj-2022-osx-alpha.zip
# chmod +x uigj-2022.app/Contents/MacOS/uigj-2022
# zip -r uigj-2022-osx-alpha.zip uigj-2022.app
# rm -rf uigj-2022.app
# cd ../../

ls -al
ls -al build/
ls -al build/linux/
ls -al build/osx/
ls -al build/win/

echo "ZIPPING FOR WINDOZE"
echo "-----------------------------"
cd build/win/
zip -r uigj-2022-win-alpha.zip uigj-2022.exe uigj-2022.pck
rm -r uigj-2022.exe uigj-2022.pck
cd ../../

echo "ZIPPING FOR LINUX"
echo "-----------------------------"
cd build/linux/
zip -r uigj-2022-linux-alpha.zip uigj-2022.x86_64 uigj-2022.pck
rm -r uigj-2022.x86_64 uigj-2022.pck
cd ../../

echo "Logging in to Butler"
echo "-----------------------------"
butler login

echo "Pushing builds with Butler"
echo "-----------------------------"
butler push build/linux/ synsugarstudio/uigj-2022:linux-alpha
# butler push build/osx/ synsugarstudio/uigj-2022:osx-alpha
butler push build/win/ synsugarstudio/uigj-2022:win-alpha
