//
//  HotKey.swift
//

import Foundation
import Carbon

class HotKey {

    static let signature:FourCharCode = UTGetOSTypeFromString( "HOTK" )
    
    var hotKeyRefPointer = UnsafeMutablePointer<EventHotKeyRef>.alloc(1)
    
    var carbonID:UInt32 = 0
    
    var action:dispatch_block_t!
    
    init(shortcut:Shortcut) {
        struct CarbonHotKeyID { static var memory:UInt32 = 0 }
        self.carbonID = ++CarbonHotKeyID.memory
        let hotKeyID = EventHotKeyID(signature:HotKey.signature, id:self.carbonID)
        let status = RegisterEventHotKey(shortcut.carbonKeyCode, shortcut.carbonFlags,
            hotKeyID, GetEventDispatcherTarget(), 0, self.hotKeyRefPointer)
        assert(status == noErr, "RegisterEventHotKey failed")
    }
    
    deinit {
        let hotKeyRef = hotKeyRefPointer.memory
        if hotKeyRef != nil {
            RemoveEventHandler(hotKeyRef)
            self.hotKeyRefPointer.dealloc(1)
        }
    }
    
    class func registeredHotKeyWithShortcut(shortcut: Shortcut! ) -> HotKey {
        return HotKey(shortcut:shortcut)
    }
    
}