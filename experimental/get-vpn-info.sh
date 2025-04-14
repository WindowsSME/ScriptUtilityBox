#!/bin/bash

# Get VPN connection status
STATUS_OUTPUT=$(/Applications/GlobalProtect.app/Contents/MacOS/globalprotect show --status 2>/dev/null)
CONNECTED=$(echo "$STATUS_OUTPUT" | grep -i "Connected:" | awk '{print $2}')

# Get version
APPLICATION="/Applications/GlobalProtect.app"
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$APPLICATION/Contents/Info.plist" 2>/dev/null)

# Output one-line result
if [[ "$CONNECTED" == "yes" ]]; then
    echo "VPN is connected. GlobalProtect version: $VERSION"
else
    echo "VPN is NOT connected. GlobalProtect version: $VERSION"
fi
