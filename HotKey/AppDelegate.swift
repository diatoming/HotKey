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
    
    var preferencesWindowController:PreferencesWindowController?
    var persistenceStack:PersistenceStack
    var starter:Starter
    var statusItem:NSStatusItem
    var configuration:Configuration
    
    override init() {
        UserDefaults.initialize()
        
        persistenceStack = PersistenceStack()
        configuration = Configuration(persistenceStack.managedObjectContext!)

        starter = Starter()
        let hotKeyConfiguration = HotKeyConfiguration(starter)
        configuration.delegates.append(hotKeyConfiguration)

        let menu = MenuConfiguration(starter)
        configuration.delegates.append(menu)
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        statusItem.menu = menu.statusMenu
        statusItem.image = NSImage(named: "HotKey")
        statusItem.alternateImage = NSImage(named: "HotKey-Alternate")
        statusItem.highlightMode = true
    }
    
    func applicationDidFinishLaunching(aNotification:NSNotification) {
        configuration.changed()
        if UserDefaults.createExampleOnStart {
            self.createExampleAppItem()
            UserDefaults.createExampleOnStart = false
            UserDefaults.showPopupOnPrefs = true
        }
        if UserDefaults.openPrefsOnStart {
            self.openPreferences(self)
        }
    }
    
    func openAbout(sender:AnyObject) {
        NSApp.activateIgnoringOtherApps(true)
        NSApp.orderFrontStandardAboutPanel(self)
    }
    
    func openPreferences(sender:AnyObject) {
        if (preferencesWindowController == nil) {
            preferencesWindowController = PreferencesWindowController(windowNibName:"PreferencesWindowController")
            preferencesWindowController!.managedObjectContext = persistenceStack.managedObjectContext
        }
        NSApp.activateIgnoringOtherApps(true)
        preferencesWindowController!.showWindow(self)
    }

    func terminate(sender:AnyObject) {
        NSApp.terminate(self)
    }
    
    func createExampleAppItem() {
        let terminalApp = "/Applications/Utilities/Terminal.app"
        let moc = persistenceStack.managedObjectContext!
        let item = Item.insertNew(NSURL(string:terminalApp)!, managedObjectContext: moc)
        item?.keyCode = Int32(kVK_Return)
        item?.modifierFlags = Int32(NSEventModifierFlags.CommandKeyMask.rawValue + NSEventModifierFlags.ShiftKeyMask.rawValue)
    }

}

