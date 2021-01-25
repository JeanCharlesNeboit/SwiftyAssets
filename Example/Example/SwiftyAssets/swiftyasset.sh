#!/bin/sh

#  swiftyasset.sh
#  Example
#
#  Created by Jean-Charles Neboit on 01/10/2020.
#

# Strings
swiftyassets strings ./Example/SwiftyAssets/strings.yml ./Example/GeneratedAssets

# Fonts
swiftyassets fonts ./Example/SwiftyAssets/Fonts ./Example/GeneratedAssets --plist ./Example/Info.plist

# Images
swiftyassets images ./Example/SwiftyAssets/images.yml ./Example/GeneratedAssets --resources ./Example/SwiftyAssets/Images

# Colors
swiftyassets colors ./Example/SwiftyAssets/colors.yml ./Example/GeneratedAssets
