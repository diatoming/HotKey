//
//  ScriptInstaller.swift
//  HotKey
//
//  Created by Peter Vorwieger on 11.03.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Foundation

class ScriptInstaller {
   
    class var baseURL:NSURL {
        get {
            var err : NSError?
            let fileManager = NSFileManager.defaultManager()
            return fileManager.URLForDirectory(NSSearchPathDirectory.ApplicationScriptsDirectory,
                inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: &err)!
        }
    }
    
    class var scriptURL:NSURL {
        get {
            return baseURL.URLByAppendingPathComponent("HotKey.applescript")
        }
    }
    
    class var sourceScriptURL:NSURL {
        get {
            return NSBundle.mainBundle().URLForResource("HotKey", withExtension: "applescript")!
        }
    }

    class func checkScript() -> Bool {
        return scriptExists() && scriptUpToDate()
    }
    
    class func scriptUpToDate() -> Bool {
        let fileManager = NSFileManager.defaultManager()
        return fileManager.contentsEqualAtPath(sourceScriptURL.path!, andPath: scriptURL.path!)
    }

    class func scriptExists() -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(scriptURL.path!)
    }
    
    class func installScript(window:NSWindow, completionHandler:() -> Void) {
        var savePanel = NSSavePanel()
        savePanel.directoryURL = self.scriptURL.URLByDeletingLastPathComponent
        savePanel.nameFieldStringValue = self.scriptURL.lastPathComponent!
        savePanel.showsTagField = false
        savePanel.message = "Install Script for HotKey. Please do not change the prefilled fields."
        savePanel.prompt = "Install"
        savePanel.beginSheetModalForWindow(window) { result in
            if result == NSFileHandlingPanelOKButton {
                if savePanel.URL! == self.scriptURL {
                    self.copyScript()
                } else {
                    // try again because the user changed the file anme or folder path
                    self.installScript(window, completionHandler: completionHandler)
                }
            }
            completionHandler()
        }
    }
    
    class func copyScript() {
        var err : NSError?
        let fileManager = NSFileManager.defaultManager()
        fileManager.removeItemAtURL(self.scriptURL, error: nil)
        if fileManager.copyItemAtURL(self.sourceScriptURL, toURL:self.scriptURL, error:&err) {
            // self.successAlert("Congratulation!", text:"The HotKey Script was installed succcessfully.")
            // get the Application Scripts path out of the next open or save panel that appears
            NSUserDefaults.standardUserDefaults().removeObjectForKey("NSNavLastRootDirectory")
        } else {
            NSLog("%s error = %@", __FUNCTION__, err!);
            // the item couldn't be copied
            self.errorAlert(err!)
        }
    }
    
    class func successAlert(title:String, text:String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.runModal()
    }
    
    class func errorAlert(error:NSError) {
        let alert = NSAlert(error: error)
        alert.messageText = "Script not installed."
        alert.runModal()
    }
    
}
