//
//  Shortcut.swift
//  HotKey
//
//  Created by Peter Vorwieger on 23.05.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

let ShortcutKeyCode = "KeyCode"
let ShortcutModifierFlags = "ModifierFlags"

func ==(lhs: Shortcut, rhs: Shortcut) -> Bool {
    return lhs.keyCode == rhs.keyCode && lhs.modifierFlags == rhs.modifierFlags
}

class Shortcut: NSObject, Hashable, Printable {

    var keyCode:UInt!

	var modifierFlags:UInt!
    
    var carbonKeyCode:UInt32 {
		return self.keyCode == UInt(NSNotFound) ? UInt32(0)	: UInt32(self.keyCode)
	}

    var carbonFlags:UInt32 {
		return CarbonModifiersFromCocoaModifiers(self.modifierFlags)
	}

    override var description:String {
		return "\(self.modifierFlagsString)\(self.keyCodeString)"
	}
	
	var keyCodeStringForKeyEquivalent:String {
		switch Int(self.keyCode) {
			case kVK_F1: return  String(UnicodeScalar(0xF704))
			case kVK_F2: return  String(UnicodeScalar(0xF705))
			case kVK_F3: return  String(UnicodeScalar(0xF706))
			case kVK_F4: return  String(UnicodeScalar(0xF707))
			case kVK_F5: return  String(UnicodeScalar(0xF708))
			case kVK_F6: return  String(UnicodeScalar(0xF709))
			case kVK_F7: return  String(UnicodeScalar(0xF70a))
			case kVK_F8: return  String(UnicodeScalar(0xF70b))
			case kVK_F9: return  String(UnicodeScalar(0xF70c))
			case kVK_F10: return  String(UnicodeScalar(0xF70d))
			case kVK_F11: return  String(UnicodeScalar(0xF70e))
			case kVK_F12: return  String(UnicodeScalar(0xF70f))
			case kVK_F13: return  String(UnicodeScalar(0xF710))
			case kVK_F14: return  String(UnicodeScalar(0xF711))
			case kVK_F15: return  String(UnicodeScalar(0xF712))
			case kVK_F16: return  String(UnicodeScalar(0xF713))
			case kVK_F17: return  String(UnicodeScalar(0xF714))
			case kVK_F18: return  String(UnicodeScalar(0xF715))
			case kVK_F19: return  String(UnicodeScalar(0xF716))
			case kVK_Space: return  String(UnicodeScalar(0x20))
			default: return self.keyCodeString.lowercaseString
		}
	}

    var keyCodeString:String {
		switch Int(self.keyCode) {
			case NSNotFound: return ""
			case kVK_F1: return "F1"
			case kVK_F2: return "F2"
			case kVK_F3: return "F3"
			case kVK_F4: return "F4"
			case kVK_F5: return "F5"
			case kVK_F6: return "F6"
			case kVK_F7: return "F7"
			case kVK_F8: return "F8"
			case kVK_F9: return "F9"
			case kVK_F10: return "F10"
			case kVK_F11: return "F11"
			case kVK_F12: return "F12"
			case kVK_F13: return "F13"
			case kVK_F14: return "F14"
			case kVK_F15: return "F15"
			case kVK_F16: return "F16"
			case kVK_F17: return "F17"
			case kVK_F18: return "F18"
			case kVK_F19: return "F19"
			case kVK_Space: return NSLocalizedString("Space", comment: "Shortcut name for SPACE key")
			case kVK_Escape: return  String(UnicodeScalar(0x238B))
			case kVK_Delete: return  String(UnicodeScalar(0x232B))
			case kVK_ForwardDelete: return  String(UnicodeScalar(0x2326))
			case kVK_LeftArrow: return  String(UnicodeScalar(0x2190))
			case kVK_RightArrow: return  String(UnicodeScalar(0x2192))
			case kVK_UpArrow: return  String(UnicodeScalar(0x2191))
			case kVK_DownArrow: return  String(UnicodeScalar(0x2193))
			case kVK_Help: return  String(UnicodeScalar(0x003F))
			case kVK_PageUp: return  String(UnicodeScalar(0x21DE))
			case kVK_PageDown: return  String(UnicodeScalar(0x21DF))
			case kVK_Tab: return  String(UnicodeScalar(0x21E5))
			case kVK_Return: return  String(UnicodeScalar(0x21A9))
			case kVK_ANSI_Keypad0: return "0"
			case kVK_ANSI_Keypad1: return "1"
			case kVK_ANSI_Keypad2: return "2"
			case kVK_ANSI_Keypad3: return "3"
			case kVK_ANSI_Keypad4: return "4"
			case kVK_ANSI_Keypad5: return "5"
			case kVK_ANSI_Keypad6: return "6"
			case kVK_ANSI_Keypad7: return "7"
			case kVK_ANSI_Keypad8: return "8"
			case kVK_ANSI_Keypad9: return "9"
			case kVK_ANSI_KeypadDecimal: return "."
			case kVK_ANSI_KeypadMultiply: return "*"
			case kVK_ANSI_KeypadPlus: return "+"
			case kVK_ANSI_KeypadClear: return  String(UnicodeScalar(0x2327))
			case kVK_ANSI_KeypadDivide: return "/"
			case kVK_ANSI_KeypadEnter: return  String(UnicodeScalar(0x2305))
			case kVK_ANSI_KeypadMinus: return "–"
			case kVK_ANSI_KeypadEquals: return "="
            case 119: return  String(UnicodeScalar(0x2198)) // SoutheastArrow
			case 115: return  String(UnicodeScalar(0x2196)) // NorthwestArrow
			default: break
		}
		
		// Everything else should be printable so look it up in the current ASCII capable keyboard layout
		var maybe_keystroke:NSString? = keycode_to_str( UInt16( self.keyCode ) )
		
		if !( maybe_keystroke?.length > 0 ) {
				return ""
		}
		
		// Validate keystroke
		var keystroke = maybe_keystroke!
		for i in 0 ..< keystroke.length {
			let char = keystroke.characterAtIndex(i)
			let char_is_valid = Shortcut.valid_chars.characterIsMember( char )
			if !char_is_valid {
				return ""
			}
		}

		return keystroke.uppercaseString;
	}
	
	class var valid_chars:NSCharacterSet {
		var chars = NSMutableCharacterSet()
		chars.formUnionWithCharacterSet( NSCharacterSet.alphanumericCharacterSet() )
		chars.formUnionWithCharacterSet( NSCharacterSet.punctuationCharacterSet() )
		chars.formUnionWithCharacterSet( NSCharacterSet.symbolCharacterSet() )
		return chars
	}

	func keycode_to_str( keyCode:UInt16 ) -> NSString? {

		// Everything else should be printable so look it up in the current ASCII capable keyboard layout
		var error = noErr
		
		var keystroke:NSString? = nil
		
		let inputSource:TISInputSource!
			= TISCopyCurrentASCIICapableKeyboardLayoutInputSource().takeUnretainedValue()
		
		if inputSource == nil {
			return keystroke
		}
		
		let layoutDataRef_ptr = TISGetInputSourceProperty( inputSource, kTISPropertyUnicodeKeyLayoutData)
		var layoutDataRef:CFDataRef! = unsafeBitCast( layoutDataRef_ptr, CFDataRef.self )

		if layoutDataRef == nil {
			return keystroke
		}

		var layoutData
			= unsafeBitCast( CFDataGetBytePtr(layoutDataRef), UnsafePointer<CoreServices.UCKeyboardLayout>.self )
		
		let key_translate_options = OptionBits(CoreServices.kUCKeyTranslateNoDeadKeysBit)
		var deadKeyState = UInt32( 0 )
		let max_chars = 256
		var chars = [UniChar]( count:max_chars, repeatedValue:0 )
		var length = 0
		
		error = CoreServices.UCKeyTranslate(
			layoutData,
			keyCode,
			UInt16( CoreServices.kUCKeyActionDisplay ),
			UInt32( 0 ), // No modifiers
			UInt32( LMGetKbdType() ),
			key_translate_options,
			&deadKeyState,
			max_chars,
			&length,
			&chars
		)
		
		keystroke
			= ( error == noErr ) && ( length > 0 )
			? NSString( characters:&chars, length:length )
			: ""
		
		return keystroke
	}
	
	var modifierFlagsString:String {
		var chars = ""
        if self.modifierFlags & NSEventModifierFlags.ControlKeyMask.rawValue != 0 {
			chars += String(UnicodeScalar(kControlUnicode))
		}
        if self.modifierFlags & NSEventModifierFlags.AlternateKeyMask.rawValue != 0 {
			chars += String(UnicodeScalar(kOptionUnicode))
		}
        if self.modifierFlags & NSEventModifierFlags.ShiftKeyMask.rawValue != 0 {
			chars += String(UnicodeScalar(kShiftUnicode))
		}
        if self.modifierFlags & NSEventModifierFlags.CommandKeyMask.rawValue != 0 {
			chars += String(UnicodeScalar(kCommandUnicode))
		}
		return chars
	}
    
	init(keyCode code:UInt, modifierFlags flags:UInt) {
		self.keyCode = code
		self.modifierFlags = PickCocoaModifiers( flags )
	}
    
    override var hashValue:Int {
        return Int( self.keyCode + self.modifierFlags )
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Shortcut(keyCode:self.keyCode, modifierFlags:self.modifierFlags)
    }

}
