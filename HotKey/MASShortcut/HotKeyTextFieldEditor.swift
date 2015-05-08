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
        let hotKey = MASShortcut(event: event)
        self.window!.makeFirstResponder(nil)
        if MASShortcutValidator.sharedValidator().isShortcutValid(hotKey) {
           setHotKeyValue(hotKey)
        } else if hotKey.keyCode == 53 && hotKey.modifierFlags == 0 {
           setHotKeyValue(nil)
        }
        return nil
    }
    
    func setHotKeyValue(hotKey:MASShortcut?) {
        let bindingInfo = hotKeyField?.infoForBinding("value") as! [String: AnyObject]
        if let key = bindingInfo[NSObservedKeyPathKey] as? String {
            if let object = bindingInfo[NSObservedObjectKey] as? NSTableCellView {
                object.setValue(hotKey, forKeyPath: key)
            }
        }
    }
    
}
