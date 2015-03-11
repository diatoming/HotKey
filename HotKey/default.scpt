tell application "Finder"
    try
        if selection is not {} then
            return POSIX path of (selection as alias)
        else
            return POSIX path of (target of window 1 as alias)
        end if
        on error
            return POSIX path of (home as alias)
    end try
end tell