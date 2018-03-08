#!/bin/sh
# See [OSX for Hackers: Mavericks Edition](https://gist.github.com/brandonb927/3195465)

# Main System
defaults write com.apple.dashboard devmode -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock persistent-others -array-add '{ "tile-data" = { "list-type" = 1; }; "tile-type" = "recents-tile"; }'
defaults write com.apple.LaunchServices LSQuarantine -bool false

# https://discussions.apple.com/docs/DOC-8691
defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool false

# Apps
defaults write com.apple.DiskUtility advanced-image-options -bool true
defaults write com.apple.mail EnableBundles -bool true
defaults write com.apple.MenuBarClock Use24HourClock -bool true     # Keynote
defaults write com.macromates.TextMate.preview allowExpandingLinks -bool YES
defaults write com.macromates.TextMate.preview disableTabReordering -bool YES
defaults write org.shiftitapp.ShiftIt multipleActionsCycleWindowSizes YES

##
## Unused
##
# defaults write com.apple.mail NSPreferredMailCharset "ISO-8859-1"    # "UTF-8"
# defaults write com.apple.x11 enable_stereo -bool true
# defaults write -g ApplePressAndHoldEnabled -bool false

##
## Deprecated
##
# # iCal ≤ 6 (OS X 10.7 Lion)
# defaults write com.apple.iCal IncludeDebugMenu -bool true
# # Safari < 3.1
# defaults write com.apple.Safari IncludeDebugMenu -bool true
# # Safari < 3.0
# defaults write com.apple.Safari WebKitHistoryAgeInDaysLimit 30
# defaults write com.apple.Safari WebKitHistoryItemLimit 10000
