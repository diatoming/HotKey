//
//  HotKeyCarbonEvent.m
//  HotKey
//
//  Created by Peter Vorwieger on 23.05.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

#import "HotKeyCarbonEvent.h"
#import "HotKey-Swift.h"

static OSStatus HotKeyCarbonEventCallback(EventHandlerCallRef _, EventRef event, void *context) {
    [[HotKeyMonitor sharedInstance] handleEvent:event];
    return noErr;
}

EventHandlerUPP HotKeyCarbonEventCallbackPointer = HotKeyCarbonEventCallback;
