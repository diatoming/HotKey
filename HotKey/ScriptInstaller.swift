//
//  ScriptInstaller.swift
//  HotKey
//
//  Created by Peter Vorwieger on 11.03.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Foundation

class ScriptInstaller: NSObject {
    
    class var scriptsDirectoryURL:NSURL {
        get {
            var err : NSError?
            let fileManager = NSFileManager.defaultManager()
            return fileManager.URLForDirectory(NSSearchPathDirectory.ApplicationScriptsDirectory,
                inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: &err)!
        }
    }

    class func checkScript() -> Bool {
        let fileManager = NSFileManager.defaultManager()
        let sourceURL = NSBundle.mainBundle().URLForResource("default", withExtension:"scpt")
        let destURL = self.scriptsDirectoryURL.URLByAppendingPathComponent("default.scpt")
        return fileManager.contentsEqualAtPath(sourceURL!.path!, andPath: destURL.path!)
    }
    
    class func installScript() {
        var err : NSError?
        var openPanel = NSOpenPanel()
        openPanel.directoryURL = self.scriptsDirectoryURL
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.prompt = "Select Script Folder"
        openPanel.message = "Please select the User > Library > Application Scripts > de.codenuts.HotKey folder"
        openPanel.beginWithCompletionHandler { result in
            if result == NSFileHandlingPanelOKButton {
                let selectedURL = openPanel.URL!
                if selectedURL == self.scriptsDirectoryURL {
                    let destinationURL = selectedURL.URLByAppendingPathComponent("default.scpt")
                    let fileManager = NSFileManager.defaultManager()
                    let sourceURL = NSBundle.mainBundle().URLForResource("default", withExtension:"scpt")
                    if fileManager.copyItemAtURL(sourceURL!, toURL:destinationURL, error:&err) {
                        let alert = NSAlert()
                        alert.messageText = "Script Installed"
                        alert.informativeText = "The Automation script was installed succcessfully."
                        alert.runModal()
                        // get the Application Scripts path out of the next open or save panel that appears
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("NSNavLastRootDirectory")
                    } else {
                        NSLog("%s error = %@", __FUNCTION__, err!);
                        if (err!.code == NSFileWriteFileExistsError) {
                            // the script was already installed Application Scripts folder
                            if !fileManager.removeItemAtURL(destinationURL, error:&err) {
                                NSLog("%s error = %@", __FUNCTION__, err!);
                            } else {
                                if fileManager.copyItemAtURL(sourceURL!, toURL:destinationURL, error:&err) {
                                    let alert = NSAlert()
                                    alert.messageText = "Script Updated"
                                    alert.informativeText = "The Automation script was updated."
                                    alert.runModal()
                                }
                            }
                        } else {
                            // the item couldn't be copied, try again
                            self.installScript()
                        }
                    }
                } else {
                    // try again because the user changed the folder path
                    self.installScript()
                }
            }
        }
    }
    
}
