//
//  HotKeyCarbonEvent.m
//

#import "HotKeyCarbonEvent.h"
#import "HotKey-Swift.h"

static OSStatus HotKeyCarbonEventCallback(EventHandlerCallRef _, EventRef event, void *context) {
    [[HotKeyMonitor sharedInstance] handleEvent:event];
    return noErr;
}

EventHandlerUPP HotKeyCarbonEventCallbackPointer = HotKeyCarbonEventCallback;
