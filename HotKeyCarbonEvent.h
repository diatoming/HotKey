//
//  HotKeyCarbonEvent.h
//  HotKey
//
//  Created by Peter Vorwieger on 23.05.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

@import Carbon;

static OSStatus HotKeyCarbonEventCallback(EventHandlerCallRef _, EventRef event, void *context);

EventHandlerUPP HotKeyCarbonEventCallbackPointer;
