--
--  AppDelegate.applescript
--  Neovim4Unity
--
--  Created by Joni Strömberg on 15/11/2016.
--  Copyright © 2016 Yonstorm. All rights reserved.
--
--
-- http://snipplr.com/view/15608/
-- (ord('-') << 24) | (ord('-') << 16) | (ord('-') << 8) | ord('-')
-- kCoreEventClass = 1634039412
-- kAEOpenDocuments = 1868853091
-- AEKeyword '---' = 757935405
-- kpos = 1802530675
script AppDelegate
	property parent : class "NSObject"
    
    property NSImage: current application's class "NSImage"
    property NSMenu: current application's class "NSMenu"
    property NSMenuItem: current application's class "NSMenuItem"
    
    property EditorController : missing value
    
    property statusItem: missing value
    property statusMenu: missing value
    
	on applicationWillFinishLaunching_(aNotification)
        --set theController to current application's class "NSWindowController"'s alloc()'s init()
        --current application's class "NSBundle"'s loadNibNamed:"SettingsWindow" owner:theController
        
        --theController's showWindow:me
        
        
        set statusItem to current application's NSStatusBar's systemStatusBar()'s statusItemWithLength_(-2)'s retain()
        set myImg to NSImage's imageNamed_("StatusBarButtonImage")
        set statusItem's button()'s image to myImg
        
        set statusMenu to (NSMenu's alloc)'s initWithTitle_("")
        statusMenu's setAutoenablesItems_(true)
        statusMenu's setDelegate_(me)
        statusItem's setMenu_(statusMenu)
        
        set menuItemQuit to createMenuItem("Quit", "handleQuit:", "q")
        set menuItemSettings to createMenuItem("Settings", "handleSettings:", "s")
        statusMenu's addItem_(menuItemSettings)
        statusMenu's addItem_(menuItemQuit)

        tell current application's NSAppleEventManager's sharedAppleEventManager() to setEventHandler_andSelector_forEventClass_andEventID_(me, "handleOpenFile:", 1634039412, 1868853091)
        
        
	end applicationWillFinishLaunching_
    
    on handleQuit_(sender)
        tell current application's NSApp to terminate_(me)
    end handleQuit
    
    on createMenuItem(aTitle, aAction, keyEquivalent)
        return (NSMenuItem's alloc)'s initWithTitle_action_keyEquivalent_(aTitle, aAction, keyEquivalent)
    end createMenuItem
	
    on handleOpenFile_(evt)
        EditorController's openFileRequest_(evt)
    end handleOpenFile_

------------------------------------------------------------------------------------------------------------------------------


   on application_openFile_(theApplication, filename)
       --display dialog "lol"
       return true
   end application_openFile_
	
	on applicationShouldTerminate:sender
		--display dialog "i die"
		-- Insert code here to do any housekeeping before your application quits 
		return 1
	end applicationShouldTerminate:
	
end script
