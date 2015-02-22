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
    var starter:Starter
    
    init(_ starter:Starter) {
        statusMenu = NSMenu()
        self.starter = starter
    }
    
    func willInsert() {
        statusMenu.removeAllItems()
        statusMenu.addItem(NSMenuItem(title:"About HotKey", action:"openAbout:", keyEquivalent:""))
        statusMenu.addItem(NSMenuItem.separatorItem())
    }
    
    func doInsert(item:Item) {
        let key = item.hotKey?.keyCodeStringForKeyEquivalent ?? ""
        let menuItem = BlocksMenuItem(title:item.name, block:{
            self.starter.startApp(item)
        }, keyEquivalent:key)
        menuItem.keyEquivalentModifierMask = Int(item.modifierFlags)
        menuItem.image = IconTransformer().transformedValue(item.url) as? NSImage
        statusMenu.addItem(menuItem)
    }
    
    func didInsert() {
        statusMenu.addItem(NSMenuItem.separatorItem())
        statusMenu.addItem(NSMenuItem(title:"Preferences...", action:"openPreferences:", keyEquivalent:""))
        statusMenu.addItem(NSMenuItem.separatorItem())
        statusMenu.addItem(NSMenuItem(title:"Quit HotKey", action:"terminate:", keyEquivalent:""))
    }

}
