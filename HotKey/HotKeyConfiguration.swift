//
//  MenuConfiguration.swift
//  HotKey
//
//  Created by Peter Vorwieger on 29.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class HotKeyConfiguration: NSObject, ConfigurationDelegate {

    var hotKeyCenter:DDHotKeyCenter
    var starter:Starter
    
    init(_ starter:Starter) {
        hotKeyCenter = DDHotKeyCenter.sharedHotKeyCenter();
        self.starter = starter
    }
    
    func willInsert() {
        hotKeyCenter.unregisterAllHotKeys()
    }
    
    func doInsert(item:Item) {
        let modifierFlags =  UInt(item.modifierFlags)
        let key = UInt16(item.keyCode)
        hotKeyCenter.registerHotKeyWithKeyCode(key, modifierFlags: modifierFlags, task: {event in
            self.starter.startApp(item.name)
        })
    }
    
    func didInsert() {
    }
    
}
