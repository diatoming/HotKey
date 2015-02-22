//
//  BlocksMenuItem.swift
//  HotKey
//
//  Created by Peter Vorwieger on 22.02.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class BlocksMenuItem:NSMenuItem {
    
    var block:() -> ();
    
    init(title:String, block:() -> (), keyEquivalent:String) {
        self.block = block
        super.init(title: title, action:"action:", keyEquivalent: keyEquivalent)
        self.target = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action(sender:NSMenuItem) {
        self.block()
    }
    
}