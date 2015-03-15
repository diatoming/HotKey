//
//  PreferencesWindowController.swift
//  HotKey
//
//  Created by Peter Vorwieger on 25.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa
import ServiceManagement

class PreferencesWindowController: NSWindowController, NSWindowDelegate {

    let launchDaemon = "de.codenuts.HotKeyHelper"
    
    var managedObjectContext: NSManagedObjectContext!

    @IBOutlet var launchAtLoginButton: NSButton!
    @IBOutlet var myArrayController: ItemArrayController!
    @IBOutlet var mainView: NSView!
    @IBOutlet var popover: PopoverView!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let enabled = self.appIsPresentInLoginItems()
        launchAtLoginButton.state = enabled ? NSOnState : NSOffState
    }

    override func showWindow(sender: AnyObject?) {
        if !ScriptInstaller.checkScript() {
            ScriptInstaller.installScript(self.window!) {
                // do someting fancy here
            }
        }
        super.showWindow(sender)
    }
    
    func windowDidBecomeKey(notification: NSNotification) {
        UserDefaults.openPrefsOnStart = true
        if UserDefaults.showPopupOnPrefs {
            self.popover.showPopup()
            UserDefaults.showPopupOnPrefs = false
        }
    }

    func windowShouldClose(sender: AnyObject) -> Bool {
        UserDefaults.openPrefsOnStart = false
        return true
    }

    @IBAction func bookmark(sender: NSButton) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.beginWithCompletionHandler { result in
            if result == NSFileHandlingPanelOKButton {
                UserDefaults.bookmarkedURL = panel.URL!
            }
        }
    }
    
    @IBAction func openSelectDialog(sender: AnyObject) {
        var err : NSError?
        let appsDirectoryURL = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.ApplicationDirectory,
            inDomain: NSSearchPathDomainMask.SystemDomainMask, appropriateForURL: nil, create: true, error: &err)
        var openPanel = NSOpenPanel()
        openPanel.directoryURL = appsDirectoryURL
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["app"]
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                if let url = openPanel.URL {
                    self.myArrayController.addItem(url)
                }
            }
        }
    }
    
    @IBAction func startAtLoginAction(sender: AnyObject) {
        if (SMLoginItemSetEnabled(launchDaemon, sender.state == NSOnState ? 1 : 0) != 1) {
            NSLog("Couldn't add/remove Helper App to launch at login item list.")
        }
    }

    func appIsPresentInLoginItems() -> Bool {
        let jobDicts = SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeUnretainedValue()
        let count = CFArrayGetCount(jobDicts)
        for (var i = 0; i < count; i++) {
            let value = CFArrayGetValueAtIndex(jobDicts, i)
            let job = Unmanaged<NSDictionary>.fromOpaque(COpaquePointer(value)).takeUnretainedValue()
            let label = job["Label"] as String
            let onDemand = job["OnDemand"] as Bool
            if (label == launchDaemon && onDemand) {
                return true;
            }
        }
        return false;
    }

}
