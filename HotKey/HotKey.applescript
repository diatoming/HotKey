-------------------------------------
-- Default Applescript for App HotKey
-- Please do not modify this file!
-- Copyright (C) 2015 Peter Vorwieger
-------------------------------------

tell application "Finder"
    try
        if selection is not {} then
            return POSIX path of (selection as alias)
        else
            return POSIX path of (target of window 1 as alias)
        end if
        on error
            return null
    end try
end tell
