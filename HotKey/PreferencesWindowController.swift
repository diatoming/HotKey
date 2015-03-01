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

    let launchDaemon = "de.peter-vorwieger.HotKeyHelper"
    
    var managedObjectContext: NSManagedObjectContext!

    @IBOutlet var launchAtLoginButton: NSButton!
    @IBOutlet var myArrayController: ItemArrayController!
    @IBOutlet var mainView: NSView!
    @IBOutlet var popover: PopoverView!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let enabled = self.appIsPresentInLoginItems()
        launchAtLoginButton.state = enabled ? NSOnState : NSOffState
        
        mainView.layer = CALayer()
        mainView.wantsLayer = true
    }
    
    func windowDidBecomeMain(notification: NSNotification) {
        if UserDefaults.firstStart {
            self.showPopup()
        }
    }
    
    func windowWillClose(notification: NSNotification) {
        UserDefaults.firstStart = false
    }
    
    func showPopup() {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        let hideTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            self.popover.showPopup()
        }
        dispatch_after(hideTime, dispatch_get_main_queue()) {
            self.popover.hidePopup()
        }
    }    
    
    @IBAction func openSelectDialog(sender: AnyObject) {
        var openPanel = NSOpenPanel()
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
