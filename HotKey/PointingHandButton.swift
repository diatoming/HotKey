//
//  PointingHandButton.swift
//  HotKey
//
//  Created by Peter Vorwieger on 15.03.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class PointingHandButton: NSButton {

    override func resetCursorRects() {
        super.resetCursorRects()
        self.addCursorRect(self.bounds, cursor: NSCursor.pointingHandCursor())
    }
    
}
