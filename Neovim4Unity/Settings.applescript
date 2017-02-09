script Settings
    property parent : class "NSObject"
    property myWindow : missing value
    property myButton : missing value
    
    on myButtonClicked:sender
        display dialog "wdad"
        log "I'm clicked"
    end myButtonClicked:
    
end script
