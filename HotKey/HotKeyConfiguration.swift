//
//  MenuConfiguration.swift
//  HotKey
//
//  Created by Peter Vorwieger on 29.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class HotKeyConfiguration: NSObject, ConfigurationDelegate {

    var monitor:HotKeyMonitor
    var starter:Starter
    
    init(_ starter:Starter) {
        monitor = HotKeyMonitor.sharedInstance
        self.starter = starter
    }
    
    func willInsert() {
        monitor.unregisterAllShortcuts()
    }
    
    func doInsert(item:Item) {
        if item.enabled {
            if let key = item.hotKey {
                monitor.registerShortcut(item.hotKey) {
                    self.starter.startApp(item)
                }
            }
        }
    }
    
    func didInsert() {
    }
    
}
