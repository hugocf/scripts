#!/bin/sh

defaults write com.apple.mail UserHeaders '{"Disposition-Notification-To" = "hugo@ferreira.net"; }'
defaults read com.apple.mail UserHeaders 

