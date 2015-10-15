#!/bin/bash

#  Created by Alex Karahalios on 6/12/11
#  Edited by Brian Reinhart on 08/02/2012 .
#  Last edited 8/02/2012
#
# Updates Xcode and to support LUA language for editing
#

# Path were this script is located
#
SCRIPT_PATH="$(dirname "$BASH_SOURCE")"

# Set up path for PlistBuddy helper application which can add elements to Plist files
#
PLISTBUDDY=/usr/libexec/PlistBuddy

# Xcode Contents Path
#
XCODE_CONTENTS_PATH="$(dirname "`xcode-select -p`")"

# This framework is found withing the Xcode.app package and is used when Xcode is a monolithic
# install (all contained in Xcode.app)
#
DVTFOUNDATION_PATH="$XCODE_CONTENTS_PATH/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/"

# Wait for user confirmation
#
echo "*** IMPORTANT! This package does not yet actually include the correct Haml syntax highlighting yet ***"
echo "About to patch: $DVTFOUNDATION_PATH"
read -p "Press [Enter] to continue"

# Now merge in the additonal languages to DVTFoundation.xcplugindata
#
$PLISTBUDDY "$DVTFOUNDATION_PATH/DVTFoundation.xcplugindata"  -c 'Merge Haml.plist plug-in:extensions'
$PLISTBUDDY "$DVTFOUNDATION_PATH/DVTFoundation.xcplugindata"  -c 'Merge CoffeeScript.plist plug-in:extensions'
$PLISTBUDDY "$DVTFOUNDATION_PATH/DVTFoundation.xcplugindata"  -c 'Merge erb.plist plug-in:extensions'
$PLISTBUDDY "$DVTFOUNDATION_PATH/DVTFoundation.xcplugindata"  -c 'Merge Go.plist plug-in:extensions'

# Copy in the xclangspecs for the languages (assumes in same directory as this shell script)
#
cp "$SCRIPT_PATH/Haml.xclangspec" "$DVTFOUNDATION_PATH"
cp "$SCRIPT_PATH/CoffeeScript.xclangspec" "$DVTFOUNDATION_PATH"
cp "$SCRIPT_PATH/erb.xclangspec" "$DVTFOUNDATION_PATH"
cp "$SCRIPT_PATH/Go.xclangspec" "$DVTFOUNDATION_PATH"

# Remove any cached Xcode plugins
#
rm -f /private/var/folders/*/*/*/com.apple.DeveloperTools/*/Xcode/PlugInCache*.xcplugincache
