#!/usr/bin/env bash

ask() {
	local server=$1
	local default=${2:-n}
	read -p "
$server? [$default] " value
	[[ "${value:-$default}" == "y" ]]
}

bounce_mysql() {
	ask $FUNCNAME y && mysql.server restart
}

bounce_pow() {
	if ask $FUNCNAME y; then
		echo Unloading ; launchctl unload -w ~/Library/LaunchAgents/cx.pow.powd.plist
		echo Loading ; launchctl load -w ~/Library/LaunchAgents/cx.pow.powd.plist
	fi
}

bounce_dnsmasq() {
	if ask $FUNCNAME; then
		echo Unloading ; sudo launchctl unload -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
		echo Loading ; sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
	fi
}

bounce_apache() {
	ask $FUNCNAME && (echo Apache: Restarting ; sudo apachectl restart)
}

# Do the work
bounce_mysql
bounce_dnsmasq
bounce_apache
