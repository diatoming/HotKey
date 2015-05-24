//
//  KeyCodes.swift
//  HotKey
//
//  Created by Peter Vorwieger on 23.05.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

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
        = (cocoaFlags & NSEventModifierFlags.CommandKeyMask.rawValue != 0 ? cmdKey : 0)
        | (cocoaFlags & NSEventModifierFlags.AlternateKeyMask.rawValue != 0 ? optionKey : 0)
        | (cocoaFlags & NSEventModifierFlags.ControlKeyMask.rawValue != 0 ? controlKey : 0)
        | (cocoaFlags & NSEventModifierFlags.ShiftKeyMask.rawValue != 0 ? shiftKey : 0)
	return UInt32(flags)
}

