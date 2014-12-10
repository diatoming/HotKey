//
//  AppDelegate.m
//  HotKey
//
//  Created by Peter Vorwieger on 08.12.14.
//  Copyright (c) 2014 Peter Vorwieger. All rights reserved.
//

#import "AppDelegate.h"
#import "DDHotKeyCenter.h"
#import "DDHotKeyUtilities.h"
#import "SimpleItemView.h"

#import <Carbon/Carbon.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:-1];
    self.statusMenu = [[NSMenu alloc] init];
//    [self.statusItem setupView];
//    [self.statusItem setDelegate:self];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setImage:[NSImage imageNamed:@"HotKey"]];
    [self.statusItem setAlternateImage:[NSImage imageNamed:@"HotKey-Alternate"]];
    [self.statusItem setHighlightMode:YES];

    NSString *source = @"tell application \"Finder\" to set myname to POSIX path of (target of window 1 as alias)";
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:source];
    DDHotKeyTask task = ^(NSEvent *hkEvent) {
        NSAppleEventDescriptor *scriptResult = [script executeAndReturnError:NULL];
        NSString *path = [scriptResult stringValue];
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/usr/bin/open";
        task.arguments  = @[@"-a", @"Terminal", path?path:@""];
        [task launch];
    };
    
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    if (![c registerHotKeyWithKeyCode:kVK_Return modifierFlags:NSCommandKeyMask | NSShiftKeyMask task:task]) {
        //[self addOutput:@"Unable to register hotkey for example 1"];
    }

    [self refreshMenu];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)actionItem:(id)sender {
}

- (void)refreshMenu {

    [self.statusMenu removeAllItems];
    
    NSMenuItem *aboutItem = [[NSMenuItem alloc] initWithTitle:@"About HotKey" action:@selector(openAbout:) keyEquivalent:@""];
    [aboutItem setView:[[SimpleItemView alloc] initWithSizeForLabel:aboutItem.title]];
    [aboutItem setEnabled:YES];
    [aboutItem setTarget:self];
    [self.statusMenu addItem:aboutItem];
    [self.statusMenu addItem:[NSMenuItem separatorItem]];
    
    NSString *str = DDStringFromKeyCode(kVK_Return, 0);
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Terminal" action:@selector(actionItem:) keyEquivalent:str];
    [item setKeyEquivalentModifierMask:NSCommandKeyMask|NSShiftKeyMask];
    [self.statusMenu addItem:item];
    
    
    [self.statusMenu addItem:[NSMenuItem separatorItem]];
    
//    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Add App..." action:@selector(openFile) keyEquivalent:@""];
//    [item setView:[[SimpleItemView alloc] initWithSizeForLabel:item.title]];
//    [item setEnabled:YES];
//    [item setTarget:self];
//    [self.statusMenu addItem:item];
    
    //    item = [[NSMenuItem alloc] initWithTitle:@"Preferences..." action:@selector(openPreferences:) keyEquivalent:@""];
    //    [item setView:[[SimpleItemView alloc] initWithSizeForLabel:item.title]];
    //    [item setEnabled:YES];
    //    [item setTarget:self];
    //    [self.statusMenu addItem:item];
    
    [self.statusMenu addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:@"Quit HotKey" action:@selector(terminate) keyEquivalent:@""];
    [quitItem setView:[[SimpleItemView alloc] initWithSizeForLabel:quitItem.title]];
    [quitItem setEnabled:YES];
    [quitItem setTarget:self];
    [self.statusMenu addItem:quitItem];
}

- (void)openAbout:(id)sender {
//    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
//    [self.aboutWindow makeKeyAndOrderFront:self];
}

- (void)terminate {
    [[NSApplication sharedApplication] terminate:self];
}


@end
