-------------------------------------
-- Default Applescript for App HotKey
-- Please do not modify this script
-- Copyright (C) 2015 Peter Vorwieger
-------------------------------------

on execute()
	tell application "System Events" to set activeApp to name of first application process whose frontmost is true
	if activeApp is "Finder" then
		set selectedFiles to selection of application "Finder"
		set myFiles to {}
		repeat with aFile in selectedFiles
			set end of myFiles to POSIX path of (aFile as alias)
		end repeat
		return myFiles
	end if
end execute

on run
	display alert "HotKey App" message "This script is used by HotKey App to automate tasks"
end run
