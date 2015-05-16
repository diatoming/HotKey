//
//  Shortcut.swift
//

let ShortcutKeyCode = "KeyCode"
let ShortcutModifierFlags = "ModifierFlags"

func contains_flag(container:UInt, flag:NSEventModifierFlags) -> Bool {
	let cont = Int(container)
	let f = Int(flag.rawValue)
	return cont & f == f
}

class Shortcut: NSObject, NSSecureCoding, NSCopying {

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
		let keyCodeString = self.keyCodeString
		if ( keyCodeString.length <= 1 ) {
			return keyCodeString.lowercaseString
		}

		switch Int( self.keyCode ){
			case kVK_F1:
				return NSStringFromKeyCode( CUnsignedShort( 0xF704 ) )
			case kVK_F2:
				return NSStringFromKeyCode( CUnsignedShort( 0xF705 ) )
			case kVK_F3:
				return NSStringFromKeyCode( CUnsignedShort( 0xF706 ) )
			case kVK_F4:
				return NSStringFromKeyCode( CUnsignedShort( 0xF707 ) )
			case kVK_F5:
				return NSStringFromKeyCode( CUnsignedShort( 0xF708 ) )
			case kVK_F6:
				return NSStringFromKeyCode( CUnsignedShort( 0xF709 ) )
			case kVK_F7:
				return NSStringFromKeyCode( CUnsignedShort( 0xF70a ) )
			case kVK_F8:
				return NSStringFromKeyCode( CUnsignedShort( 0xF70b ) )
			case kVK_F9:
				return NSStringFromKeyCode( CUnsignedShort( 0xF70c ) )
			case kVK_F10:
				return NSStringFromKeyCode( CUnsignedShort( 0xF70d ) )
			case kVK_F11:
				return NSStringFromKeyCode( CUnsignedShort( 0xF70e ) )
			case kVK_F12:
				return NSStringFromKeyCode( CUnsignedShort( 0xF70f ) )
			// From here I am guessing F13 etc come sequentially
			case kVK_F13:
				return NSStringFromKeyCode( CUnsignedShort( 0xF710 ) )
			case kVK_F14:
				return NSStringFromKeyCode( CUnsignedShort( 0xF711 ) )
			case kVK_F15:
				return NSStringFromKeyCode( CUnsignedShort( 0xF712 ) )
			case kVK_F16:
				return NSStringFromKeyCode( CUnsignedShort( 0xF713 ) )
			case kVK_F17:
				return NSStringFromKeyCode( CUnsignedShort( 0xF714 ) )
			case kVK_F18:
				return NSStringFromKeyCode( CUnsignedShort( 0xF715 ) )
			case kVK_F19:
				return NSStringFromKeyCode( CUnsignedShort( 0xF716 ) )
			case kVK_Space:
				return NSStringFromKeyCode( CUnsignedShort( 0x20 ) )
			default:
				break
		}
		return ""
	}
	
	typealias UniCharCount = CUnsignedLong
	
    var keyCodeString:NSString {

		// Some key codes don't have an equivalent
		
		switch Int( self.keyCode ) {
			
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
			case kVK_Space: return NSLocalizedString(
				"Space",
				comment: "Shortcut glyph name for SPACE key"
			)
			case kVK_Escape: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.Escape.rawValue ) )
			case kVK_Delete: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.DeleteLeft.rawValue ) )
			case kVK_ForwardDelete: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.DeleteRight.rawValue ) )
			case kVK_LeftArrow: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.LeftArrow.rawValue ) )
			case kVK_RightArrow: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.RightArrow.rawValue ) )
			case kVK_UpArrow: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.UpArrow.rawValue ) )
			case kVK_DownArrow: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.DownArrow.rawValue ) )
			case kVK_Help: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.Help.rawValue ) )
			case kVK_PageUp: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.PageUp.rawValue ) )
			case kVK_PageDown: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.PageDown.rawValue ) )
			case kVK_Tab: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.TabRight.rawValue ) )
			case kVK_Return: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.ReturnR2L.rawValue ) )
				
				// Keypad
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
			case kVK_ANSI_KeypadClear: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.PadClear.rawValue ) )
			case kVK_ANSI_KeypadDivide: return "/"
			case kVK_ANSI_KeypadEnter: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.Return.rawValue ) )
			case kVK_ANSI_KeypadMinus: return "–"
			case kVK_ANSI_KeypadEquals: return "="
				
				// Hardcode
			case 119: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.SoutheastArrow.rawValue ) )
			case 115: return NSStringFromKeyCode( CUnsignedShort( kShortcutGlyph.NorthwestArrow.rawValue ) )
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

		// Finally, we've got a shortcut!
		
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
		if contains_flag( self.modifierFlags, NSEventModifierFlags.ControlKeyMask ){
			chars += String(UnicodeScalar( kControlUnicode ))
		}
		if contains_flag( self.modifierFlags, NSEventModifierFlags.AlternateKeyMask ){
			chars += String(UnicodeScalar( kOptionUnicode ))
		}
		if contains_flag( self.modifierFlags, NSEventModifierFlags.ShiftKeyMask ){
			chars += String(UnicodeScalar( kShiftUnicode ))
		}
		if contains_flag( self.modifierFlags, NSEventModifierFlags.CommandKeyMask ){
			chars += String(UnicodeScalar( kCommandUnicode ))
		}
		return chars
	}
	
	init(keyCode code:UInt, modifierFlags flags:UInt) {
		self.keyCode = code
		self.modifierFlags = PickCocoaModifiers( flags )
	}
	
	class func shortcutWithKeyCode(code:UInt, modifierFlags flags:UInt) -> Shortcut {
		return Shortcut(keyCode:code, modifierFlags:flags)
	}

	class func shortcutWithEvent(event:NSEvent) -> Shortcut {
		return Shortcut(
			keyCode: UInt( event.keyCode ),
			modifierFlags:event.modifierFlags.rawValue as UInt
		)
	}

	func encodeWithCoder(coder: NSCoder) {
		
		coder.encodeInteger(
			self.keyCode != UInt( NSNotFound )
			? Int( self.keyCode )
			: -1,
			forKey: ShortcutKeyCode
		)
		coder.encodeInteger(
			Int( self.modifierFlags ),
			forKey: ShortcutModifierFlags
		)
		
	}

	override func isEqual( object: AnyObject? ) -> Bool {
		if let shortcut = object as? Shortcut {
			return shortcut.keyCode == self.keyCode
			&& shortcut.modifierFlags == self.modifierFlags
		}
		return false
	}
	
	override var hash:Int {
		return Int( self.keyCode + self.modifierFlags )
	}
	
	required init(coder decoder: NSCoder) {
		
		let code = decoder.decodeIntegerForKey(ShortcutKeyCode )
		self.keyCode
			= code < 0
			? UInt( NSNotFound )
			: UInt( code )
		self.modifierFlags = UInt( decoder.decodeIntegerForKey( ShortcutModifierFlags ) )
		
	}
	
	static func supportsSecureCoding() -> Bool {
		return true
	}
	
	func copyWithZone( zone: NSZone ) -> AnyObject {
		
		return Shortcut.shortcutWithKeyCode(
			self.keyCode,
			modifierFlags: self.modifierFlags
		)

	}
	
}
