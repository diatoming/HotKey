//
//  HotKey.swift
//  HotKey
//
//  Created by Peter Vorwieger on 23.05.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

class HotKey {

    static let signature:FourCharCode = UTGetOSTypeFromString( "HOTK" )

    static var carbonIDCounter:UInt32 = 0

    var hotKeyRefPointer = UnsafeMutablePointer<EventHotKeyRef>.alloc(1)
    
    var carbonID:UInt32
    
    var action:() -> ()
    
    init?(shortcut:Shortcut, action:() -> ()) {
        self.action = action
        self.carbonID = ++HotKey.carbonIDCounter
        let hotKeyID = EventHotKeyID(signature:HotKey.signature, id:self.carbonID)
        let status = RegisterEventHotKey(shortcut.carbonKeyCode, shortcut.carbonFlags,
            hotKeyID, GetEventDispatcherTarget(), 0, self.hotKeyRefPointer)
        if status != noErr {
            return nil
        }
    }
    
    deinit {
        let hotKeyRef = hotKeyRefPointer.memory
        if hotKeyRef != nil {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRefPointer.dealloc(1)
        }
    }
    
}