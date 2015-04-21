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
    var hotKey:MASShortcut?
    
    override init(frame frameRect: NSRect) {
        println("init(frame frameRect: NSRect)")
        super.init(frame:frameRect)
    }
    
    override var objectValue:AnyObject? {
        set {hotKey = newValue as? MASShortcut}
        get {return hotKey}
    }

    required init?(coder: NSCoder) {
        println("init?(coder: NSCoder)")
        class MyFormatter:NSFormatter {
            
            var delegate:NSControl?
            
            private override func stringForObjectValue(obj: AnyObject) -> String? {
                println("stringForObjectValue \(obj)")
                if let hotKey = obj as? MASShortcut {
                    return hotKey.modifierFlagsString + hotKey.keyCodeString
                } else {
                    return nil
                }
            }
            private override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
                println("getObjectValue \(self.delegate)")
                //if let hotKey = self.delegate?.objectValue as? MASShortcut {
//                    obj.memory = MASShortcut(keyCode:hotKey.keyCode, modifierFlags:hotKey.modifierFlags)
                //}
                let hotKey = self.delegate?.objectValue as? MASShortcut
                let keyCode = UInt(kVK_Return)
                let modifierFlags = UInt(NSEventModifierFlags.CommandKeyMask.rawValue + NSEventModifierFlags.ShiftKeyMask.rawValue)
                obj.memory = MASShortcut(keyCode:keyCode, modifierFlags:modifierFlags)
                return true
            }
//            private override func isPartialStringValid(partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
//                return true
//            }

        }
        super.init(coder:coder)
        let formatter = MyFormatter()
        formatter.delegate = self
        self.formatter = formatter
    }
    
    override func becomeFirstResponder() -> Bool {
        let ok = super.becomeFirstResponder()
        if ok {
            globalMonitor = NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.KeyDownMask, handler: {event in
                    return self.processHotkeyEvent(event)
            })
        }
        //println("becomeFirstResponder \(ok)")
        return ok
    }
    
    override func resignFirstResponder() -> Bool {
        let ok = super.resignFirstResponder()
        if ok && globalMonitor != nil {
            NSEvent.removeMonitor(globalMonitor!)
        }
        //println("resignFirstResponder \(ok)")
        return ok
    }
    
    func processHotkeyEvent(event:NSEvent) -> NSEvent! {
        println("processHotkeyEvent \(event)")
        dispatch_async(dispatch_get_main_queue()) {
            self.window!.makeFirstResponder(nil)
        }
        
        let hotKey = MASShortcut(keyCode: UInt(event.keyCode), modifierFlags:UInt(event.modifierFlags.rawValue))
        //self.stringValue = hotKey.modifierFlagsString + hotKey.keyCodeString
        //self.doubleValue = 10.0
        self.objectValue = hotKey
        println("processHotkeyEvent hotKey:\(hotKey)")
        println("   hotKey.modifierFlagsString:\(hotKey.modifierFlagsString)")
        println("   hotKey.keyCodeString:\(hotKey.keyCodeString)")
        return event
    }
    
    
}
