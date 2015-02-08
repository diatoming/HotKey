//
//  MenuConfiguration.swift
//  HotKey
//
//  Created by Peter Vorwieger on 29.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class HotKeyConfiguration: NSObject, ConfigurationDelegate {

    var monitor:MASShortcutMonitor
    var starter:Starter
    
    init(_ starter:Starter) {
        monitor = MASShortcutMonitor.sharedMonitor()
        self.starter = starter
    }
    
    func willInsert() {
        monitor.unregisterAllShortcuts()
    }
    
    func doInsert(item:Item) {
        if let key = item.hotKey {
            monitor.registerShortcut(item.hotKey) {
                self.starter.startApp(item.name)
            }
        }
    }
    
    func didInsert() {
    }
    
}
