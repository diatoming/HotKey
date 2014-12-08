//
//  AppDelegate.m
//  HotKey
//
//  Created by Peter Vorwieger on 08.12.14.
//  Copyright (c) 2014 Peter Vorwieger. All rights reserved.
//

#import "AppDelegate.h"
#import "DDHotKeyCenter.h"
#import <Carbon/Carbon.h>
//  #import <AppKit/AppKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSString *source = @"tell application \"Finder\" to set myname to POSIX path of (target of window 1 as alias)";
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:source];
    
    DDHotKeyTask task = ^(NSEvent *hkEvent) {
        NSAppleEventDescriptor *scriptResult = [script executeAndReturnError:nil];
        NSString *path = [scriptResult stringValue];
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/usr/bin/open";
        task.arguments  = @[@"-a",@"Terminal",path];
        [task launch];
    };
    
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    if (![c registerHotKeyWithKeyCode:kVK_Return modifierFlags:NSCommandKeyMask | NSShiftKeyMask task:task]) {
        //[self addOutput:@"Unable to register hotkey for example 1"];
    }

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
