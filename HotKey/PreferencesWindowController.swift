//
//  PreferencesWindowController.swift
//  HotKey
//
//  Created by Peter Vorwieger on 25.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa
import ServiceManagement

class PreferencesWindowController: NSWindowController {

    let launchDaemon = "de.peter-vorwieger.HotKeyHelper"
    
    @IBOutlet weak var launchAtLoginButton: NSButton!

    override func windowDidLoad() {
        super.windowDidLoad()
        let enabled = self.appIsPresentInLoginItems()
        launchAtLoginButton.state = enabled ? NSOnState : NSOffState
    }

    @IBAction func buttonTapped(sender: AnyObject) {
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
