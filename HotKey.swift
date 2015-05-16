//
//  HotKey.swift
//

import Foundation
import Carbon

let HotKeySignature:FourCharCode = UTGetOSTypeFromString( "HOTK" )

@objc class HotKey: NSObject {

	var hotKeyRef_ptr = UnsafeMutablePointer<EventHotKeyRef>.alloc(1)
    
	var hotKeyRef:EventHotKeyRef {
		return hotKeyRef_ptr.memory
	}

	@objc var carbonID:UInt32=0
	
	var action:dispatch_block_t!
	
	init( shortcut:Shortcut ) {
		super.init()
		struct CarbonHotKeyID { static var memory:UInt32=0 }
		self.carbonID = ++CarbonHotKeyID.memory
		let hotKeyID = EventHotKeyID(
			signature: HotKeySignature,
			id: self.carbonID
		)
		let status = RegisterEventHotKey(
			shortcut.carbonKeyCode,
			shortcut.carbonFlags,
			hotKeyID,
			GetEventDispatcherTarget(),
			0 as OptionBits,
			self.hotKeyRef_ptr
		)
		assert( status == noErr, "RegisterEventHotKey failed" )
	}
	
	deinit {
		if self.hotKeyRef != nil {
			UnregisterEventHotKey( self.hotKeyRef )
			self.hotKeyRef_ptr.dealloc(1)
		}
	}
	
	class func registeredHotKeyWithShortcut(shortcut: Shortcut! ) -> HotKey {
		return HotKey(shortcut:shortcut)
	}
	
}