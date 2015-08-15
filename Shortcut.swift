//
//  Shortcut.swift
//  HotKey
//
//  Created by Peter Vorwieger on 23.05.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

func ==(lhs: Shortcut, rhs: Shortcut) -> Bool {
    return lhs.keyCode == rhs.keyCode && lhs.modifierFlags == rhs.modifierFlags
}

class Shortcut: NSObject {

    var keyCode:UInt!

	var modifierFlags:UInt!
    
    init(keyCode code:UInt, modifierFlags flags:UInt) {
        self.keyCode = code
        self.modifierFlags = flags
    }
    
    init(carbonKeyCode code:UInt, carbonFlags flags:UInt) {
        self.keyCode = code
        modifierFlags =
              (flags & UInt(cmdKey) != 0 ? NSEventModifierFlags.CommandKeyMask.rawValue : 0)
            | (flags & UInt(optionKey) != 0 ? NSEventModifierFlags.AlternateKeyMask.rawValue : 0)
            | (flags & UInt(controlKey) != 0 ? NSEventModifierFlags.ControlKeyMask.rawValue : 0)
            | (flags & UInt(shiftKey) != 0 ? NSEventModifierFlags.ShiftKeyMask.rawValue : 0)
    }
    
    override var hashValue:Int {
        return Int(self.keyCode + self.modifierFlags )
    }

    override var description:String {
        return "\(self.modifierFlagsString)\(self.keyCodeString)"
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Shortcut(keyCode:self.keyCode, modifierFlags:self.modifierFlags)
    }

    var carbonKeyCode:UInt32 {
		return self.keyCode == UInt(NSNotFound) ? UInt32(0)	: UInt32(self.keyCode)
	}

    var carbonFlags:UInt32 {
        return UInt32(
              (modifierFlags & NSEventModifierFlags.CommandKeyMask.rawValue != 0 ? cmdKey : 0)
            | (modifierFlags & NSEventModifierFlags.AlternateKeyMask.rawValue != 0 ? optionKey : 0)
            | (modifierFlags & NSEventModifierFlags.ControlKeyMask.rawValue != 0 ? controlKey : 0)
            | (modifierFlags & NSEventModifierFlags.ShiftKeyMask.rawValue != 0 ? shiftKey : 0)
        )
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
        
        let inputSource = TISCopyCurrentASCIICapableKeyboardLayoutInputSource().takeUnretainedValue()
        let layoutDataRefPtr = TISGetInputSourceProperty(inputSource, kTISPropertyUnicodeKeyLayoutData)
        let layoutDataRef = unsafeBitCast(layoutDataRefPtr, CFDataRef.self)
        let layoutData = unsafeBitCast(CFDataGetBytePtr(layoutDataRef), UnsafePointer<CoreServices.UCKeyboardLayout>.self)
        
        var deadKeyState:UInt32 = 0
        let maxLength = 255
        var length = 0
        var chars = [UniChar](count:maxLength, repeatedValue:0)

        let status = CoreServices.UCKeyTranslate(layoutData, UInt16(keyCode),
            UInt16(CoreServices.kUCKeyActionDown), UInt32(0), UInt32(LMGetKbdType()),
            OptionBits(CoreServices.kUCKeyTranslateNoDeadKeysBit), &deadKeyState, maxLength,
            &length, &chars)
        
        let key = status == noErr && length > 0 ? String(utf16CodeUnits:&chars, count:length) : ""
        return key.uppercaseString
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
    
    func isValid() -> Bool {
        let keyCode = Int(self.keyCode)
        if keyCode == kVK_F1 || keyCode == kVK_F2 || keyCode == kVK_F3 || keyCode == kVK_F4
            || keyCode == kVK_F5 || keyCode == kVK_F6 || keyCode == kVK_F7 || keyCode == kVK_F8
            || keyCode == kVK_F9 || keyCode == kVK_F10 || keyCode == kVK_F11 || keyCode == kVK_F12
            || keyCode == kVK_F13 || keyCode == kVK_F14 || keyCode == kVK_F15 || keyCode == kVK_F16
            || keyCode == kVK_F17 || keyCode == kVK_F18 || keyCode == kVK_F19 || keyCode == kVK_F20 {
                return true
        }
        if self.modifierFlags & NSEventModifierFlags.CommandKeyMask.rawValue > 0 {
            return true
        } else if self.modifierFlags & NSEventModifierFlags.ControlKeyMask.rawValue > 0 {
            return true
        } else if self.modifierFlags & NSEventModifierFlags.AlternateKeyMask.rawValue > 0 {
            return keyCode == kVK_Space || keyCode == kVK_Escape
        }
        return false
    }
    
    func isSystemShortut() -> Bool {
        let globalHotKeysPointer = UnsafeMutablePointer<Unmanaged<CFArray>?>.alloc(1)
        if CopySymbolicHotKeys(globalHotKeysPointer) == noErr {
            let globalHotKeys = unsafeBitCast(globalHotKeysPointer.memory!, CFArray.self)
            for var i = CFIndex(0), count=CFArrayGetCount(globalHotKeys); i < count; i++ {
                let hotKeyInfo = unsafeBitCast(CFArrayGetValueAtIndex(globalHotKeys, i), NSDictionary.self)
                let code = hotKeyInfo.objectForKey(kHISymbolicHotKeyCode)! as! NSNumber
                let flags = hotKeyInfo.objectForKey(kHISymbolicHotKeyModifiers)! as! NSNumber
                let enabled = hotKeyInfo.objectForKey(kHISymbolicHotKeyEnabled)! as! Bool
                //println("\(Shortcut(carbonKeyCode: UInt(code), carbonFlags: UInt(flags)))")
                if code == self.keyCode && flags == Int(self.carbonFlags) && enabled {
                    return true
                }
            }
        }
        globalHotKeysPointer.dealloc(1)
        return false
    }

}
