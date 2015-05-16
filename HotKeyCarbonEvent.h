//
//  HotKeyCarbonEvent.h
//

@import Carbon;

static OSStatus HotKeyCarbonEventCallback(EventHandlerCallRef _, EventRef event, void *context);

EventHandlerUPP HotKeyCarbonEventCallback_ptr;
