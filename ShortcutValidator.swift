//
//  ShortcutValidator.swift
//  HotKey
//
//  Created by Peter Vorwieger on 23.05.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

// The following API enable hotkeys with the Option key as the only modifier
// For example, Option-G will not generate © and Option-R will not paste ®
let allowAnyShortcutWithOptionModifier = false

class ShortcutValidator: NSObject {
	
    static let sharedInstance = ShortcutValidator()

	func isShortcutValid( shortcut:Shortcut ) -> Bool {
		
		let keyCode = Int( shortcut.keyCode )
		let modifiers = shortcut.modifierFlags
		
		// Allow any function key with any combination of modifiers
		
		let includesFunctionKey
			=  ( keyCode == kVK_F1 )
			|| ( keyCode == kVK_F2 )
			|| ( keyCode == kVK_F3 )
			|| ( keyCode == kVK_F4 )
			|| ( keyCode == kVK_F5 )
			|| ( keyCode == kVK_F6 )
			|| ( keyCode == kVK_F7 )
			|| ( keyCode == kVK_F8 )
			|| ( keyCode == kVK_F9 )
			|| ( keyCode == kVK_F10 )
			|| ( keyCode == kVK_F11 )
			|| ( keyCode == kVK_F12 )
			|| ( keyCode == kVK_F13 )
			|| ( keyCode == kVK_F14 )
			|| ( keyCode == kVK_F15 )
			|| ( keyCode == kVK_F16 )
			|| ( keyCode == kVK_F17 )
			|| ( keyCode == kVK_F18 )
			|| ( keyCode == kVK_F19 )
			|| ( keyCode == kVK_F20 )
		
		if includesFunctionKey {
			return true
		}
		
		// Do not allow any other key without modifiers
		let hasModifierFlags = ( modifiers > 0 )
		if !hasModifierFlags {
			return false
		}
		
		// Allow any hotkey containing Control or Command modifier
		let includesCommand = (modifiers & NSEventModifierFlags.CommandKeyMask.rawValue) > 0
		let includesControl = (modifiers & NSEventModifierFlags.ControlKeyMask.rawValue) > 0
		if includesCommand || includesControl {
			return true
		}
		
		// Allow Option key only in selected cases
		let includesOption = (modifiers & NSEventModifierFlags.AlternateKeyMask.rawValue) > 0
		if includesOption {
			
			// Always allow Option-Space and Option-Escape because they do not have any bind system commands
			if (keyCode == kVK_Space) || (keyCode == kVK_Escape) {
				return true
			}
			
			// Allow Option modifier with any key even if it will break the system binding
			if allowAnyShortcutWithOptionModifier{
				return true
			}
		}
		
		// The hotkey does not have any modifiers or violates system bindings
		return false

	}
		
	func isShortcut(
		shortcut: Shortcut!,
		alreadyTakenInMenu menu: NSMenu!,
		explanation: AutoreleasingUnsafeMutablePointer<NSString?>
	) -> Bool {
	
		let keyEquivalent = shortcut.keyCodeStringForKeyEquivalent
		let flags = shortcut.modifierFlags
		
		for menuItem in menu.itemArray as! [NSMenuItem] {
			
			if menuItem.hasSubmenu && self.isShortcut(
				shortcut,
				alreadyTakenInMenu:menuItem.submenu,
				explanation: explanation
			) {
				return true
			}

			var equalFlags = PickCocoaModifiers( UInt(menuItem.keyEquivalentModifierMask) ) == flags
			var equalHotkeyLowercase = menuItem.keyEquivalent.lowercaseString == keyEquivalent

			// Check if the cases are different, we know ours is lower and that shift is included in our modifiers
			// If theirs is capitol, we need to add shift to their modifiers
			if equalHotkeyLowercase && menuItem.keyEquivalent != keyEquivalent {
				equalFlags = PickCocoaModifiers(
					UInt( menuItem.keyEquivalentModifierMask ) | NSEventModifierFlags.ShiftKeyMask.rawValue
				) == flags
			}
			if equalFlags && equalHotkeyLowercase {
				if let explanation_str = explanation.memory {
					explanation.memory = NSLocalizedString(
						"This shortcut cannot be used because it is already used by the menu item ‘\(menuItem.title)’.",
						comment: "Message for alert when shortcut is already used"
					)
					
				}
				return true
			}
		}
		return false
	
	}

	func isShortcutAlreadyTakenBySystem(
		shortcut: Shortcut!,
		explanation: AutoreleasingUnsafeMutablePointer<NSString?>
	) -> Bool {
		
		// START hack. not sure if this is what orig author intended
		explanation.memory = "" as NSString
		// END hack. not sure if this is what orig author intended
		
		var globalHotKeys_ptr = UnsafeMutablePointer<Unmanaged<CFArray>?>.alloc(1)
		
		if CopySymbolicHotKeys( globalHotKeys_ptr ) == noErr {

			// let globalHotKeys = globalHotKeys_ptr.memory!.takeUnretainedValue()
			let globalHotKeys = unsafeBitCast(
				globalHotKeys_ptr.memory!,
				 CFArray.self
			)
			
			// Enumerate all global hotkeys and check if any of them matches current shortcut
			
			for var i = CFIndex(0), count=CFArrayGetCount( globalHotKeys ); i < count; i++ {
				
				
				let hotKeyInfo = unsafeBitCast(
					CFArrayGetValueAtIndex( globalHotKeys, i ), NSDictionary.self
				)
				
				let cf_code = hotKeyInfo.objectForKey(kHISymbolicHotKeyCode)! as! NSNumber
				let cf_flags = hotKeyInfo.objectForKey(kHISymbolicHotKeyModifiers)! as! NSNumber
				let cf_enabled = hotKeyInfo.objectForKey(kHISymbolicHotKeyEnabled)! as! NSNumber
				
				let code = (cf_code as NSNumber).unsignedIntegerValue
				let flags = (cf_flags as NSNumber).unsignedIntegerValue
				let enabled = (cf_enabled as NSNumber).boolValue
				
				if (
					code == Int( shortcut.keyCode )
					&& flags == Int( shortcut.carbonFlags )
					&& enabled
				) {

					if let explanation_str = explanation.memory {
						
						explanation.memory = NSLocalizedString(
							"This combination cannot be used because it is already used by a system-wide "
							+ "keyboard shortcut.\nIf you really want to use this key combination, most shortcuts "
							+ "can be changed in the Keyboard & Mouse panel in System Preferences.",
							comment: "Message for alert when shortcut is already used by the system"
						)
					
					}

					return true
						
				}
				
			}
			
		}
		
		globalHotKeys_ptr.dealloc(1)
		
		return self.isShortcut(
			shortcut,
			alreadyTakenInMenu: NSApp.mainMenu,
			explanation: explanation
		)
		
	}
		
}
