//
//  IconTransformer.swift
//  HotKey
//
//  Created by Peter Vorwieger on 08.02.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class IconTransformer: NSValueTransformer {

    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let url = value as? String {
            return NSWorkspace.sharedWorkspace().iconForFile(url)
        } else {
            return nil
        }
    }
    
}
