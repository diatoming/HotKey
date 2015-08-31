//
//  ScriptInstaller.swift
//  HotKey
//
//  Created by Peter Vorwieger on 11.03.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Foundation

class ScriptInstaller {
    
    class var scriptURL:NSURL {
        get {
            let fileManager = NSFileManager.defaultManager()
            let scriptDir = try! fileManager.URLForDirectory(NSSearchPathDirectory.ApplicationScriptsDirectory,
                inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
            return scriptDir.URLByAppendingPathComponent("HotKey.applescript")
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
        let savePanel = NSSavePanel()
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
        do {
            try fileManager.removeItemAtURL(self.scriptURL)
        } catch _ {
        }
        do {
            try fileManager.copyItemAtURL(self.sourceScriptURL, toURL:self.scriptURL)
            // self.successAlert("Congratulation!", text:"The HotKey Script was installed succcessfully.")
            // get the Application Scripts path out of the next open or save panel that appears
            NSUserDefaults.standardUserDefaults().removeObjectForKey("NSNavLastRootDirectory")
        } catch let error as NSError {
            err = error
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
