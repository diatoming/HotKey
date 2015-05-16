//
//  HotKeyCarbonEvent.m
//

#import "HotKeyCarbonEvent.h"
#import "HotKey-Swift.h"

static OSStatus HotKeyCarbonEventCallback(EventHandlerCallRef _, EventRef event, void *context) {
	HotKeyMonitor *dispatcher = (__bridge id)context;
	[dispatcher handleEvent:event];
	return noErr;
}

EventHandlerUPP HotKeyCarbonEventCallback_ptr = HotKeyCarbonEventCallback;
