#!/bin/sh

#  swiftyasset.sh
#  Example
#
#  Created by Jean-Charles Neboit on 01/10/2020.
#

# Strings
swiftyassets strings ./Example/SwiftyAssets/strings.yaml ./Example/GeneratedAssets

# Fonts
swiftyassets fonts ./Example/SwiftyAssets/Fonts ./Example/GeneratedAssets --plist ./Example/Info.plist
