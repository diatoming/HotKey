//
//  PreferencesWindowController.swift
//  HotKey
//
//  Created by Peter Vorwieger on 25.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSWindowDelegate, NSPathControlDelegate {
    
    let launchDaemon = "de.codenuts.HotKeyHelper"
    
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet var launchAtLoginButton: NSButton!
    @IBOutlet var myArrayController: ItemArrayController!
    @IBOutlet var mainView: NSView!
    
    @IBOutlet var leftView: NSView!
    @IBOutlet weak var tableView: NSTableView!
    
    
    @IBOutlet weak var scriptStatusImage: NSImageView!
    @IBOutlet weak var scriptStatusText: NSTextField!
    @IBOutlet weak var scriptStatusButton: NSButton!
    
    @IBOutlet weak var resourceStatusText: NSTextField!
    @IBOutlet weak var resourceStatusImage: NSImageView!
    @IBOutlet weak var resourceStatusControl: NSPathControl!
    
    var bookmark:NSURL? {
        set {
            UserDefaults.bookmarkedURL = newValue
            self.updateView()
        }
        get {
            return UserDefaults.bookmarkedURL
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let enabled = self.appIsPresentInLoginItems()
        launchAtLoginButton.state = enabled ? NSOnState : NSOffState
        
        leftView.wantsLayer = true
        leftView.layer?.backgroundColor = NSColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0).CGColor

        let rightBorder = CALayer()
        rightBorder.borderColor = NSColor.lightGrayColor().CGColor
        rightBorder.borderWidth = 1
        rightBorder.frame = CGRect(x: -1, y: -1, width: leftView.frame.width, height: leftView.frame.height+1002)
        leftView.layer?.addSublayer(rightBorder)
        
        mainView.wantsLayer = true
        //tableView.doubleAction = "doubleClick:"
        
        resourceStatusControl.delegate = self
    }
    
    func pathControl(pathControl: NSPathControl, willDisplayOpenPanel openPanel: NSOpenPanel) {
        openPanel.directoryURL = NSURL(string: "/")
    }
    
    func doubleClick(sender: AnyObject?) {
        let rowNumber = tableView.clickedRow
        let item = myArrayController.arrangedObjects[rowNumber] as! Item
        Starter().startApp(item)
    }
    
    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)
        self.updateView()
    }
    
    func windowDidBecomeKey(notification: NSNotification) {
        UserDefaults.openPrefsOnStart = true
        self.updateView()
    }
    
    func updateView() {
        if ScriptInstaller.scriptUpToDate() {
            scriptStatusImage.image = NSImage(named: "NSStatusAvailable")
            scriptStatusText.stringValue = "Script installed"
            scriptStatusButton.title = "Install"
            scriptStatusButton.enabled = false
        } else if ScriptInstaller.scriptExists() {
            scriptStatusImage.image = NSImage(named: "NSStatusPartiallyAvailable")
            scriptStatusText.stringValue = "Script needs update"
            scriptStatusButton.title = "Update"
            scriptStatusButton.enabled = true
        } else {
            scriptStatusImage.image = NSImage(named: "NSStatusUnavailable")
            scriptStatusText.stringValue = "Script not installed"
            scriptStatusButton.title = "Install"
            scriptStatusButton.enabled = true
        }
        
        if UserDefaults.bookmarkedURL != nil {
            resourceStatusImage.image = NSImage(named: "NSStatusAvailable")
            resourceStatusText.stringValue = "Resource Access"
        } else {
            resourceStatusImage.image = NSImage(named: "NSStatusUnavailable")
            resourceStatusText.stringValue = "No Resource"
        }
    }
    
    func windowShouldClose(sender: AnyObject) -> Bool {
        UserDefaults.openPrefsOnStart = false
        return true
    }
    
    @IBAction func gotoWebsite(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://codenuts.de")!)
    }
    
    @IBAction func installScript(sender: AnyObject?) {
        ScriptInstaller.installScript(self.window!) {
            self.updateView()
        }
    }
    
    @IBAction func bookmark(sender: AnyObject?) {
        let panel = NSOpenPanel()
        panel.directoryURL = NSURL(fileURLWithPath: "/")
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.prompt = "Choose"
        panel.beginSheetModalForWindow(self.window!) { result in
            if result == NSFileHandlingPanelOKButton {
                UserDefaults.bookmarkedURL = panel.URL!
            }
        }
    }
    
    @IBAction func openSelectDialog(sender: AnyObject) {
        let appsDirectoryURL: NSURL?
        do {
            appsDirectoryURL = try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.ApplicationDirectory,
                inDomain: NSSearchPathDomainMask.SystemDomainMask, appropriateForURL: nil, create: true)
        } catch {
            appsDirectoryURL = nil
        }
        let panel = NSOpenPanel()
        panel.directoryURL = appsDirectoryURL
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.prompt = "Choose"
        panel.beginSheetModalForWindow(self.window!) { result in
            if result == NSFileHandlingPanelOKButton {
                if let url = panel.URL {
                    self.myArrayController.addItem(url)
                }
            }
        }
    }
    
    @IBAction func startAtLoginAction(sender: AnyObject) {
        if (SMLoginItemSetEnabled(launchDaemon, sender.state == NSOnState ? false : true)) {
            NSLog("Couldn't add/remove Helper App to launch at login item list.")
        }
    }
    
    func appIsPresentInLoginItems() -> Bool {
        let jobDicts = SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeUnretainedValue()
        let count = CFArrayGetCount(jobDicts)
        for (var i = 0; i < count; i++) {
            let value = CFArrayGetValueAtIndex(jobDicts, i)
            let job = Unmanaged<NSDictionary>.fromOpaque(COpaquePointer(value)).takeUnretainedValue()
            let label = job["Label"] as! String
            let onDemand = job["OnDemand"] as! Bool
            if (label == launchDaemon && onDemand) {
                return true;
            }
        }
        return false;
    }
    
}
