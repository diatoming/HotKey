//
//  HotKeyTextFieldEditor.swift
//  HotKey
//
//  Created by Peter Vorwieger on 04.05.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class HotKeyTextFieldEditor: NSTextView {
    
    var hotKeyField:NSTextField?
    var globalMonitor:AnyObject?
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame:frameRect, textContainer:container)
        fieldEditor = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
        let ok = super.becomeFirstResponder()
        if ok {
            self.globalMonitor = NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.KeyDownMask, handler: {
                event in
                return self.processHotkeyEvent(event)
            })
        }
        return ok
    }
    
    override func resignFirstResponder() -> Bool {
        let ok = super.resignFirstResponder()
        if ok && globalMonitor != nil {
            NSEvent.removeMonitor(globalMonitor!)
            self.globalMonitor = nil
        }
        return ok
    }
    
    func processHotkeyEvent(event:NSEvent) -> NSEvent! {
        let shortcut = Shortcut(keyCode: UInt(event.keyCode), modifierFlags: event.modifierFlags.rawValue)
        self.window!.makeFirstResponder(nil)
        if shortcut.isValid() {
           setHotKeyValue(shortcut)
        } else if isClearKey(shortcut) {
           setHotKeyValue(nil)
        }
        return nil
    }
    
    func isClearKey(hotKey:Shortcut) -> Bool {
        return hotKey.modifierFlags == 0 && (
            hotKey.keyCode == UInt(kVK_Delete) ||
            hotKey.keyCode == UInt(kVK_ForwardDelete) ||
            hotKey.keyCode == UInt(kVK_ANSI_KeypadClear)
        )
    }
    
    func setHotKeyValue(hotKey:Shortcut?) {
        let bindingInfo = hotKeyField?.infoForBinding("value") as! [String: AnyObject]
        if let key = bindingInfo[NSObservedKeyPathKey] as? String {
            if let object = bindingInfo[NSObservedObjectKey] as? NSTableCellView {
                object.setValue(hotKey, forKeyPath: key)
            }
        }
    }
    
}
