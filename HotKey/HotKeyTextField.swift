//
//  HotKeyFieldCell.swift
//  HotKey
//
//  Created by Peter Vorwieger on 14.04.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class HotKeyTextField: NSTextField {

    var globalMonitor:AnyObject?
    
    override func becomeFirstResponder() -> Bool {
        let ok = super.becomeFirstResponder()
        println("becomeFirstResponder \(ok)")
        if ok {
            let mon: AnyObject? = NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.KeyDownMask, handler: {
                event in
                return self.processHotkeyEvent(event)
            })
            self.globalMonitor = mon
        }
        return ok
    }
    
    override func resignFirstResponder() -> Bool {
        let ok = super.resignFirstResponder()
        println("resignFirstResponder \(ok)")
        if ok && globalMonitor != nil {
            NSEvent.removeMonitor(globalMonitor!)
        }
        return ok
    }
    
    override func valueClassForBinding(binding: String) -> AnyClass? {
        return MASShortcut.self
    }
    
    func processHotkeyEvent(event:NSEvent) -> NSEvent! {
        let hotKey = MASShortcut(keyCode: UInt(event.keyCode), modifierFlags:UInt(event.modifierFlags.rawValue))
        println("processHotkeyEvent hotKey:\(hotKey)")
        let bindingInfo = infoForBinding("value") as! [String: AnyObject]
        if let key = bindingInfo[NSObservedKeyPathKey] as? String {
            if let object = bindingInfo[NSObservedObjectKey] as? NSTableCellView {
                object.setValue(hotKey, forKeyPath: key)
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.window!.makeFirstResponder(nil)
        }
        return nil
    }
    
}
