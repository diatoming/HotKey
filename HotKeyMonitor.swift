//
//  HotKeyMonitor.swift
//  HotKey
//
//  Created by Peter Vorwieger on 23.05.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

class HotKeyMonitor:NSObject {
    
    static let sharedInstance = HotKeyMonitor()
    
    var eventHandlerRefPointer = UnsafeMutablePointer<EventHotKeyRef>.alloc(1)
    
    var hotKeys = [Shortcut : HotKey]()
    
    override init() {
        super.init()
        let hotKeyPressedSpecPointer = UnsafeMutablePointer<EventTypeSpec>.alloc(1)
        hotKeyPressedSpecPointer.initialize(EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind:  UInt32(kEventHotKeyPressed)
        ))
        let status = InstallEventHandler(GetEventDispatcherTarget(), HotKeyCarbonEventCallbackPointer,
            1, hotKeyPressedSpecPointer, nil, self.eventHandlerRefPointer)
        assert( status == noErr, "Could not create HotKeyMonitor" )
    }
    
    deinit {
        let eventHandlerRef = eventHandlerRefPointer.memory
        if eventHandlerRef != nil {
            RemoveEventHandler(eventHandlerRef)
            self.eventHandlerRefPointer.dealloc(1)
        }
    }
    
    func registerShortcut(shortcut:Shortcut, withAction action:() -> ()) {
        let hotKey = HotKey(shortcut:shortcut, action:action)
        self.hotKeys[shortcut] = hotKey
    }
    
    func unregisterShortcut(shortcut: Shortcut){
        self.hotKeys.removeValueForKey(shortcut)
    }
    
    func unregisterAllShortcuts() {
        self.hotKeys.removeAll(keepCapacity: false)
    }
    
    func isShortcutRegistered(shortcut: Shortcut) -> Bool {
        return self.hotKeys[shortcut] != nil
    }
    
    func handleEvent(event: EventRef) {
        if GetEventClass(event) != OSType(kEventClassKeyboard) {
            return
        }
        var hotKeyID = EventHotKeyID()
        let status = GetEventParameter(event, EventParamName(kEventParamDirectObject),
            EventParamType(typeEventHotKeyID), nil,	sizeof(EventHotKeyID), nil, &hotKeyID)
        if status != noErr || hotKeyID.signature != HotKey.signature {
            return
        }
        for (shortCut, hotKey) in self.hotKeys {
            if hotKeyID.id == hotKey.carbonID {
                dispatch_async(dispatch_get_main_queue()) {
                    hotKey.action()
                }
            break
            }
        }
    }
    
}
