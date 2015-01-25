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
    var windowController:NSWindowController
    
    override init() {
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        statusMenu = NSMenu()
        statusItem.menu = statusMenu
        statusItem.image = NSImage(named: "HotKey")
        statusItem.alternateImage = NSImage(named: "HotKey-Alternate")
        statusItem.highlightMode = true
        
        windowController = NSWindowController(windowNibName:"Preferences")
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let c = DDHotKeyCenter.sharedHotKeyCenter();
        let modifier =  NSEventModifierFlags.CommandKeyMask.rawValue + NSEventModifierFlags.ShiftKeyMask.rawValue
        c.registerHotKeyWithKeyCode(UInt16(kVK_Return), modifierFlags:modifier, target:self, action:"actionItem:", object:nil)
        self.refreshMenu()
    }
    
    func actionItem(sender : AnyObject) {
        
        let scriptURL = NSBundle.mainBundle().URLForResource("script", withExtension: "txt")
        var err : NSDictionary?
        let script = NSAppleScript(contentsOfURL: scriptURL!, error:&err)
        if (err != nil) {
            NSLog("script compile error: %@", err!)
        }
        
        let scriptResult = script?.executeAndReturnError(&err)
        if (err != nil) {
            NSLog("script execute error: %@", err!)
        } else {
            NSLog("script result: %@", scriptResult!)
        }
        
        let task = NSTask()
        task.launchPath = "/usr/bin/open";
        task.arguments  = ["-a", "Terminal"]
        
        let path = scriptResult?.stringValue
        if path != nil {
            var isDir : ObjCBool = false
            if NSFileManager.defaultManager().fileExistsAtPath(path!, isDirectory:&isDir) {
                if isDir {
                    NSLog("file exists and is a directory")
                    task.arguments.append(path!)
                } else {
                   task.arguments.append(path!.stringByDeletingLastPathComponent)
                    NSLog("file exists and is not a directory")
                }
            } else {
                NSLog("file does not exist")
            }
        }

        task.launch()

    }

    func refreshMenu() {
        statusMenu.removeAllItems()
        statusMenu.addItem(NSMenuItem(title:"About HotKey", action:"openAbout:", keyEquivalent:""))
        statusMenu.addItem(NSMenuItem.separatorItem())
        
        let key = DDStringFromKeyCode(UInt16(kVK_Return), 0)
        let item = NSMenuItem(title:"Terminal", action:"actionItem:", keyEquivalent:key)
        item.keyEquivalentModifierMask = Int((NSEventModifierFlags.CommandKeyMask & NSEventModifierFlags.ShiftKeyMask).rawValue)
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
        NSApp.activateIgnoringOtherApps(true)
        windowController.showWindow(self)
    }

    func terminate(sender : AnyObject) {
        NSApp.terminate(self)
    }

}

