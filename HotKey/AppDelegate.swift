//
//  AppDelegate.swift
//  swift
//
//  Created by Peter Vorwieger on 19.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    var statusMenu:NSMenu
    var statusItem:NSStatusItem
    var preferencesWindowController:PreferencesWindowController?
    
    override init() {
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        statusMenu = NSMenu()
        statusItem.menu = statusMenu
        statusItem.image = NSImage(named: "HotKey")
        statusItem.alternateImage = NSImage(named: "HotKey-Alternate")
        statusItem.highlightMode = true
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let c = DDHotKeyCenter.sharedHotKeyCenter();
        let modifier =  NSEventModifierFlags.CommandKeyMask.rawValue + NSEventModifierFlags.ShiftKeyMask.rawValue
        c.registerHotKeyWithKeyCode(UInt16(kVK_Return), modifierFlags: modifier, task: {event in
            self.startApp("Terminal")
        })
        self.refreshMenu()
    }
    
    func startApp(appName: String) {
        let scriptURL = NSBundle.mainBundle().URLForResource("script", withExtension: "txt")
        var err : NSDictionary?
        let script = NSAppleScript(contentsOfURL: scriptURL!, error:&err)
        if (err != nil) {
            NSLog("script compile error: %@", err!)
        } else if let scriptResult = script?.executeAndReturnError(&err) {
            let task = NSTask()
            task.launchPath = "/usr/bin/open";
            task.arguments = ["-a", appName]
            if let path = scriptResult.stringValue {
                var isDir : ObjCBool = false
                if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory:&isDir) {
                    if isDir {
                        task.arguments.append(path)
                    } else {
                        task.arguments.append(path.stringByDeletingLastPathComponent)
                    }
                }
            }
            task.launch()
        }
    }
    
    func actionItem(sender : AnyObject) {
        if let menuItem = sender as? NSMenuItem  {
            startApp(menuItem.title)
        }
    }
    
    func refreshMenu() {
        statusMenu.removeAllItems()
        statusMenu.addItem(NSMenuItem(title:"About HotKey", action:"openAbout:", keyEquivalent:""))
        statusMenu.addItem(NSMenuItem.separatorItem())
        
        let key = DDStringFromKeyCode(UInt16(kVK_Return), 0)
        let item = NSMenuItem(title:"Terminal", action:"actionItem:", keyEquivalent:key)
        item.keyEquivalentModifierMask = Int(NSEventModifierFlags.CommandKeyMask.rawValue + NSEventModifierFlags.ShiftKeyMask.rawValue)
        statusMenu.addItem(item)
            
        statusMenu.addItem(NSMenuItem.separatorItem())
        statusMenu.addItem(NSMenuItem(title:"Preferences...", action:"openPreferences:", keyEquivalent:""))
        statusMenu.addItem(NSMenuItem.separatorItem())
        statusMenu.addItem(NSMenuItem(title:"Quit HotKey", action:"terminate:", keyEquivalent:""))
    }
    
    func openAbout(sender : AnyObject) {
        NSApp.activateIgnoringOtherApps(true)
        NSApp.orderFrontStandardAboutPanel(self)
    }
    
    func openPreferences(sender : AnyObject) {
        if (preferencesWindowController == nil) {
            preferencesWindowController = PreferencesWindowController(windowNibName:"PreferencesWindowController")
        }
        NSApp.activateIgnoringOtherApps(true)
        preferencesWindowController!.showWindow(self)
    }

    func terminate(sender : AnyObject) {
        NSApp.terminate(self)
    }

}

