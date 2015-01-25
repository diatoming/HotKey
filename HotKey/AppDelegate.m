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

#import <Carbon/Carbon.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:-1];
    self.statusMenu = [[NSMenu alloc] init];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setImage:[NSImage imageNamed:@"HotKey"]];
    [self.statusItem setAlternateImage:[NSImage imageNamed:@"HotKey-Alternate"]];
    [self.statusItem setHighlightMode:YES];

    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    if (![c registerHotKeyWithKeyCode:kVK_Return modifierFlags:NSCommandKeyMask | NSShiftKeyMask target:self action:@selector(actionItem:) object:nil]) {
        NSLog(@"Unable to register hotkey");
    }

    [self refreshMenu];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)actionItem:(id)sender {
    NSURL *scriptURL = [[NSBundle mainBundle] URLForResource: @"script" withExtension:@"txt"];
    NSDictionary *err;
    NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:&err];
    if (err) { NSLog(@"script-error: %@", err); }
    NSAppleEventDescriptor *scriptResult = [script executeAndReturnError:&err];
    NSLog(@"result: %@", err?err.description:scriptResult);
    NSString *path = [scriptResult stringValue];
    BOOL isDir;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    NSLog(@"path:   #%@#", path);
    if (exists && !isDir) {
        NSString *path1 = [[path stringByDeletingLastPathComponent] stringByStandardizingPath];
        NSString *path2 = [path stringByDeletingLastPathComponent];
        NSLog(@"path1:  #%@#", path1);
        NSLog(@"path2:  #%@#", path2);
    }
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/open";
    task.arguments  = @[@"-a", @"Terminal", path?path:@""];
    [task launch];
}

- (void)refreshMenu {

    [self.statusMenu removeAllItems];
    
    NSMenuItem *aboutItem = [[NSMenuItem alloc] initWithTitle:@"About HotKey" action:@selector(openAbout:) keyEquivalent:@""];
    [self.statusMenu addItem:aboutItem];

    [self.statusMenu addItem:[NSMenuItem separatorItem]];
    
    NSString *str = DDStringFromKeyCode(kVK_Return, 0);
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Terminal" action:@selector(actionItem:) keyEquivalent:str];
    [item setKeyEquivalentModifierMask:NSCommandKeyMask|NSShiftKeyMask];
    [self.statusMenu addItem:item];
    
    [self.statusMenu addItem:[NSMenuItem separatorItem]];

    NSMenuItem *preferenceItem = [[NSMenuItem alloc] initWithTitle:@"Preferences..." action:@selector(showPreferences:) keyEquivalent:@""];
    [self.statusMenu addItem:preferenceItem];
    
    [self.statusMenu addItem:[NSMenuItem separatorItem]];

    NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:@"Quit HotKey" action:@selector(terminate:) keyEquivalent:@""];
    [self.statusMenu addItem:quitItem];
}

- (void)openAbout:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:self];
}

- (PreferencesWindowController *)preferencesWindowController {
    if (!_preferencesWindowController) {
        _preferencesWindowController = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindowController"];
    }
    return _preferencesWindowController;
}

- (IBAction)showPreferences:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [[self preferencesWindowController] showWindow:nil];
}

- (void)terminate:(id)sender {
    [NSApp terminate:self];
}

@end
