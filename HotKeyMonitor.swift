//
//  HotKeyMonitor.swift
//

import Foundation
import Carbon

class HotKeyMonitor:NSObject {
    
    static let sharedInstance = HotKeyMonitor()
	
	var eventHandlerRef_ptr = UnsafeMutablePointer<EventHotKeyRef>.alloc(1)
	var eventHandlerRef:EventHotKeyRef {
		return eventHandlerRef_ptr.memory
	}
	
	var hotKeys:NSMutableDictionary! = NSMutableDictionary()
	
	override init() {
		super.init()
		let hotKeyPressedSpec = EventTypeSpec(
			eventClass: OSType( kEventClassKeyboard ),
			eventKind:  UInt32( kEventHotKeyPressed )
		)
		var hotKeyPressedSpec_ptr = UnsafeMutablePointer<EventTypeSpec>.alloc(1)
		hotKeyPressedSpec_ptr.memory = hotKeyPressedSpec
		let handler_upp = HotKeyCarbonEventCallback_ptr
		let status = InstallEventHandler(
			GetEventDispatcherTarget(),
			handler_upp,
			1,
			hotKeyPressedSpec_ptr,
			unsafeBitCast( self, UnsafeMutablePointer<Void>.self ),  //as_void_ptr( self ),
			self.eventHandlerRef_ptr
		)
		assert( status == noErr, "Could not create HotKeyMonitor" )
	}
	
	deinit {
		if self.eventHandlerRef != nil {
			RemoveEventHandler( self.eventHandlerRef )
			self.eventHandlerRef_ptr.dealloc(1)
		}
	}
		
	func registerShortcut( shortcut: Shortcut!, withAction action: dispatch_block_t! ) -> Bool {
		let hotKey:HotKey! = HotKey.registeredHotKeyWithShortcut(shortcut)
		if hotKey == nil {
			return false
		}
		hotKey.action = action
		self.hotKeys.setObject( hotKey, forKey: shortcut )
		return true
	}
	
	func unregisterShortcut( shortcut: Shortcut! ){
		if shortcut != nil {
			self.hotKeys.removeObjectForKey( shortcut )
		}
	}
	
	func unregisterAllShortcuts() {
		self.hotKeys.removeAllObjects()
	}
	
	func isShortcutRegistered( shortcut: Shortcut! ) -> Bool {
		return self.hotKeys.objectForKey( shortcut ) != nil
	}
	
	@objc internal func handleEvent( event: EventRef ) {
		if GetEventClass( event ) != OSType( kEventClassKeyboard ) {
			return
		}
		var hotKeyID = EventHotKeyID()
		let status = GetEventParameter(
			event,
			EventParamName( kEventParamDirectObject ),
			EventParamType( typeEventHotKeyID ),
			nil,
			sizeof( EventHotKeyID ),
			nil,
			&hotKeyID
		)
		if status != noErr || hotKeyID.signature != HotKeySignature {
			return
		}
		self.hotKeys.enumerateKeysAndObjectsUsingBlock {
			shortcut_obj, hotKey_obj, stop in
			let shortcut = shortcut_obj as! Shortcut!
			let hotKey = hotKey_obj as! HotKey!
			if hotKey.action != nil {
				dispatch_async( dispatch_get_main_queue(), {
					let action = hotKey.action
					action()
				})
			}
			stop.memory = true
		}
	}
	
}
