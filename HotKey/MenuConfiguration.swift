//
//  MenuConfiguration.swift
//  HotKey
//
//  Created by Peter Vorwieger on 29.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class MenuConfiguration: NSObject, ConfigurationDelegate {

    var statusMenu:NSMenu
    
    override init() {
        statusMenu = NSMenu()
    }
    
    func willInsert() {
        statusMenu.removeAllItems()
        statusMenu.addItem(NSMenuItem(title:"About HotKey", action:"openAbout:", keyEquivalent:""))
        statusMenu.addItem(NSMenuItem.separatorItem())
    }
    
    func doInsert(item:Item) {
        if let key = item.hotKey?.keyCodeStringForKeyEquivalent {
            let menuItem = NSMenuItem(title:item.name, action:"actionItem:", keyEquivalent:key)
            menuItem.keyEquivalentModifierMask = Int(item.modifierFlags)
            statusMenu.addItem(menuItem)
        }
    }
    
    func didInsert() {
        statusMenu.addItem(NSMenuItem.separatorItem())
        statusMenu.addItem(NSMenuItem(title:"Preferences...", action:"openPreferences:", keyEquivalent:""))
        statusMenu.addItem(NSMenuItem.separatorItem())
        statusMenu.addItem(NSMenuItem(title:"Quit HotKey", action:"terminate:", keyEquivalent:""))
    }
    
}
