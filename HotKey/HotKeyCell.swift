//
//  HotKeyCell.swift
//  HotKey
//
//  Created by Peter Vorwieger on 05.02.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

class HotKeyView: MASShortcutView {
    
     var objectValue: AnyObject? {
        didSet {
            if let item = objectValue as? Item {
                self.bind("shortcutValue", toObject: item, withKeyPath: "hotKey", options: nil)
            }
        }
    }
    
}
