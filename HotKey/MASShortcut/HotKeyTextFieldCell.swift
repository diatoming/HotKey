//
//  HotKeyTextFieldCell.swift
//  HotKey
//
//  Created by Peter Vorwieger on 05.05.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class HotKeyTextFieldCell: NSTextFieldCell {

    var editor:HotKeyTextFieldEditor
    
    required init?(coder aDecoder: NSCoder) {
        editor = HotKeyTextFieldEditor()
        super.init(coder: aDecoder)
    }
    
    override func fieldEditorForView(aControlView: NSView) -> NSTextView? {
        if let view = aControlView as? NSTextField {
            editor.hotKeyField = view
            return editor
        }
        return nil
    }
    
}
