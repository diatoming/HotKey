//
//  BlocksMenuItem.swift
//  HotKey
//
//  Created by Peter Vorwieger on 22.02.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class MyMenuItem: NSMenuItem {
    
    var actionClosure:() -> ()
    
    init(title: String, actionClosure: () -> (), keyEquivalent: String) {
        self.actionClosure = actionClosure
        super.init(title: title, action: "action:", keyEquivalent: keyEquivalent)
        self.target = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action(sender: NSMenuItem) {
        self.actionClosure()
    }
    
}