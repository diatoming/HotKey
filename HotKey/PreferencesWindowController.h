//
//  PreferencesWindowController.h
//  HotKey
//
//  Created by Peter Vorwieger on 18.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindowController : NSWindowController

@property (assign) IBOutlet NSButton *launchAtLoginButton;

-(IBAction)toggleLaunchAtLogin:(id)sender;

@end
