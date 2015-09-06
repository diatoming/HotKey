//
//  HotKeyMonitor.swift
//  HotKey
//
//  Created by Peter Vorwieger on 05.09.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class ShortcutRecorder {
    
    private var monitor:AnyObject?
    
    func start(completionHandler handler: (Shortcut?) -> Void) {
        if monitor == nil {
            monitor = NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.KeyDownMask) {
                event in
                self.processHotkeyEvent(event, completionHandler: handler)
                return nil
            }
        }
    }
    
    private func stopMonitoring() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
    
    func processHotkeyEvent(event:NSEvent, completionHandler handler: (Shortcut?) -> Void) {
        stopMonitoring()
        let shortcut = Shortcut(keyCode: UInt(event.keyCode), modifierFlags: event.modifierFlags.rawValue)
        if shortcut.isSystemShortut() {
            let alert = NSAlert()
            alert.alertStyle = .CriticalAlertStyle
            alert.messageText = "Shortcut could not be saved"
            alert.informativeText = "The entered shortcut \(shortcut) is already taken by the system! Please choose another one."
            //alert.beginSheetModalForWindow(self.hotKeyField!.window!, completionHandler:nil)
        } else if shortcut.isValid() {
            handler(shortcut)
        } else if isClearKey(shortcut) {
            handler(nil)
        }

    }
    
    func isClearKey(hotKey:Shortcut) -> Bool {
        return hotKey.modifierFlags == 0 && (
            hotKey.keyCode == UInt(kVK_Delete) ||
                hotKey.keyCode == UInt(kVK_ForwardDelete) ||
                hotKey.keyCode == UInt(kVK_ANSI_KeypadClear)
        )
    }
    
}
