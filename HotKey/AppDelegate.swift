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
    
    var preferencesWindowController:PreferencesWindowController?
    var persistenceStack:PersistenceStack
    var starter:Starter
    var statusItem:NSStatusItem
    var configuration:Configuration
    
    override init() {
        persistenceStack = PersistenceStack()
        configuration = Configuration(persistenceStack.managedObjectContext!)

        starter = Starter()
        let hotKeyConfiguration = HotKeyConfiguration(starter)
        configuration.delegates.append(hotKeyConfiguration)

        let menu = MenuConfiguration()
        configuration.delegates.append(menu)
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        statusItem.menu = menu.statusMenu
        statusItem.image = NSImage(named: "HotKey")
        statusItem.alternateImage = NSImage(named: "HotKey-Alternate")
        statusItem.highlightMode = true
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        configuration.changed()
        self.openPreferences(self)
    }
    
    func actionItem(sender : AnyObject) {
        if let menuItem = sender as? NSMenuItem  {
            starter.startApp(menuItem.title)
        }
    }
    
    func openAbout(sender : AnyObject) {
        NSApp.activateIgnoringOtherApps(true)
        NSApp.orderFrontStandardAboutPanel(self)
    }
    
    func openPreferences(sender : AnyObject) {
        if (preferencesWindowController == nil) {
            preferencesWindowController = PreferencesWindowController(windowNibName:"PreferencesWindowController")
            preferencesWindowController!.managedObjectContext = persistenceStack.managedObjectContext
        }
        NSApp.activateIgnoringOtherApps(true)
        preferencesWindowController!.showWindow(self)
    }

    func terminate(sender : AnyObject) {
        NSApp.terminate(self)
    }

}

