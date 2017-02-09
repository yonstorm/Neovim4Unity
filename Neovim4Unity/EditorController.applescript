script EditorController
    property parent : class "NSObject"
    
    property editorWindow : missing value
    property editorSession : missing value
    
    
    on openFileRequest_(evt)
        if not application "iTerm" is running then
            set editorWindow to missing value
            set editorSession to missing value

            tell application "iTerm"
                activate
                tell application "iTerm"
                    set editorWindow to (current window)
                    set editorSession to (current session of current window)
                end tell
            end tell
        else if not isEditorRunning() then
            tell application "iTerm"
                set editorWindow to (create window with default profile)
                tell editorWindow
                    set editorSession to (current session of editorWindow)
                end tell
            end tell
        end if
        
        set fileName to getFilename(evt)
        set lineNum to getLinenumber(evt)
        openFile(fileName,lineNum,isEditorRunning())
    
    end openFileRequest_
    
    on openFile(filename,linenumber, isEditorRunning)
        if not isEditorRunning
            tell application "iTerm"
                activate
                tell editorWindow
                    select editorWindow
                end tell
                tell editorSession
                    set variable named "user.name" to "UNITY_SCRIPT_EDITOR"
                    if linenumber is greater than 1
                        write text "/usr/local/bin/nvr --servername /tmp/UNITY_SCRIPT_EDITOR --remote-silent +" & linenumber & " " & filename
                    else
                        write text "/usr/local/bin/nvr --servername /tmp/UNITY_SCRIPT_EDITOR --remote-silent " & filename
                    end if
                end tell
            end tell
        else
            if linenumber is greater than 1
                do shell script "/usr/local/bin/nvr --servername /tmp/UNITY_SCRIPT_EDITOR --remote-silent +"& linenumber & " " & filename
            else
                do shell script "/usr/local/bin/nvr --servername /tmp/UNITY_SCRIPT_EDITOR --remote-silent " & filename
            end if
            tell application "iTerm"
                activate
                tell editorWindow
                    select editorWindow
                end tell
            end tell
        end if
    end openFile

    on justOpenFile(filename, linenumber)
        if isEditorRunning() then
            editorOpenFile(filename, linenumber)
            set editorWindow to item 1 of findEditorSession()
            tell application "iTerm"
                activate
                tell editorWindow
                    select editorWindow
                end tell
            end tell
            else
            startNewEditor(filename,linenumber)
        end if
        
    end justOpenFile_linenumber_
    
----------------------------------------------------------------------------------------------------------------

on editorOpenFile(filename, linenumber)
    if linenumber is greater than 1
    do shell script "/usr/local/bin/nvr --servername /tmp/UNITY_SCRIPT_EDITOR --remote-silent +"& linenumber & " " & filename
    else
    do shell script "/usr/local/bin/nvr --servername /tmp/UNITY_SCRIPT_EDITOR --remote-silent " & filename
end if

end editorOpenFile

on startNewEditor(filename, linenumber)
    set itermRunning to application "iTerm" is running
    set wasActive to true
    if not itermRunning then
        activate application "iTerm"
        set wasActive to false
    end if
    set editorSession to missing value
    set editorWindow to missing value
    if wasActive then
        set editorData to findEditorSession()
        if not editorData is equal to missing value then
            set editorWindow to item 1 of editorData
            set editorSession to item 2 of editorData
        end if
    end if
    if editorSession is equal to missing value then
        if wasActive then
            #new window and session
            tell application "iTerm"
                set editorWindow to (create window with default profile)
                tell editorWindow
                    set editorSession to (current session of editorWindow)
                end tell
            end tell
            else
            tell application "iTerm"
                set editorSession to (current session of current window)
                set editorWindow to (current window)
            end tell
        end if
    end if
    #if iterm was running try find session
    #if session still null at this point create one
    tell application "iTerm"
        activate
        tell editorWindow
            #display dialog "test"
            select editorWindow
        end tell
        tell editorSession
            #display dialog (variable named "name")
            #find session with name from windows
            #set editorTab to my GetEditorTab()
            #set name to "TEST"
            set variable named "user.name" to "UNITY_SCRIPT_EDITOR"
            if linenumber is greater than 0
            write text "/usr/local/bin/nvr --servername /tmp/UNITY_SCRIPT_EDITOR --remote-silent +" & linenumber & " " & filename
            else
            write text "/usr/local/bin/nvr --servername /tmp/UNITY_SCRIPT_EDITOR --remote-silent " & filename
        end if
    end tell
end tell
end startNewEditor

on findEditorSession()
    tell application "iTerm"
        repeat with aWindow in windows
            tell aWindow
                repeat with aTab in tabs
                    tell aTab
                        repeat with aSession in sessions
                            tell aSession
                                if (variable named "user.name") is equal to "UNITY_SCRIPT_EDITOR" then
                                    set answer to {aWindow, aSession}
                                    return answer
                                end if
                            end tell
                        end repeat
                    end tell
                end repeat
            end tell
        end repeat
    end tell
    return missing value
end findEditorSession

on isEditorRunning()
    set isRunning to true
    try
        do shell script "ls /tmp/UNITY_SCRIPT_EDITOR"
        on error errorMsg number errNum
            set isRunning to false
    end try
    return isRunning
end isEditorRunning

on getFilename(evt)
    set filename to evt's descriptorForKeyword_(757935405)'s stringValue()
    set cfn to filename as string
    set cleanFilename to replaceText(cfn, "file://", "")
    
    return cleanFilename
end getFilename

on getLinenumber(evt)
    set kpos to evt's (descriptorForKeyword_(1802530675))
    set lineNum to missing value
    
    if not kpos is missing value
        set kposData to (kpos's |data|)
        set lineNum to (current application's class "helperMethods"'s getLinenumber_(kposData))
    else
        set lineNum to 0
    end if
    return lineNum as integer
end getLinenumber


on replaceText(incomingString, SearchString, replacementString)
    -- This handler is adapted from Apple's sample Applescript "Replace text in item names"
    --current application's class "helperMethods"'s logString_(class of incomingString)
    set savedDelim to AppleScript's text item delimiters -- save the current delimiter setting
    
    -- This block was copied from the more extensive sample Applescript
    set AppleScript's text item delimiters to the SearchString
    set the textitemlist to every text item of the incomingString
    set AppleScript's text item delimiters to the replacementString
    set the newitemname to the textitemlist as string
    
    set AppleScript's text item delimiters to savedDelim -- set the delimiters back
    
    return newitemname
    
end replaceText

end script
