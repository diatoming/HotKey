//
//  KeyCodes.swift
//

enum kShortcutGlyph: Int {
	case Eject = 0x23CF
	case Clear = 0x2715
	case DeleteLeft = 0x232B
	case DeleteRight = 0x2326
	case LeftArrow = 0x2190
	case RightArrow = 0x2192
	case UpArrow = 0x2191
	case DownArrow = 0x2193
	case Escape = 0x238B
	case Help = 0x003F
	case PageDown = 0x21DF
	case PageUp = 0x21DE
	case TabRight = 0x21E5
	case Return = 0x2305
	case ReturnR2L = 0x21A9
	case PadClear = 0x2327
	case NorthwestArrow = 0x2196
	case SoutheastArrow = 0x2198
}

func StringFromKeyCode(ch: UInt16) -> String {
	return NSString( format:"%C", ch ) as String
}

func PickCocoaModifiers(flags: UInt) -> UInt {
	return flags & (
		NSEventModifierFlags.ControlKeyMask.rawValue
		| NSEventModifierFlags.ShiftKeyMask.rawValue
		| NSEventModifierFlags.AlternateKeyMask.rawValue
		| NSEventModifierFlags.CommandKeyMask.rawValue
	)
}

func CarbonModifiersFromCocoaModifiers(cocoaFlags: UInt) -> UInt32 {
	let flags
        = ( contains_flag( cocoaFlags, NSEventModifierFlags.CommandKeyMask ) ? cmdKey : 0 )
        | ( contains_flag( cocoaFlags, NSEventModifierFlags.AlternateKeyMask ) ? optionKey : 0 )
        | ( contains_flag( cocoaFlags, NSEventModifierFlags.ControlKeyMask ) ? controlKey : 0 )
        | ( contains_flag( cocoaFlags, NSEventModifierFlags.ShiftKeyMask ) ? shiftKey : 0 )
	return UInt32(flags)
}

