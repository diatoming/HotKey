//
//  AppDelegate.h
//  HotKey
//
//  Created by Peter Vorwieger on 08.12.14.
//  Copyright (c) 2014 Peter Vorwieger. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> 

@property (strong) NSMenu *statusMenu;
@property (strong) NSStatusItem *statusItem;

@property (strong,nonatomic) PreferencesWindowController *preferencesWindowController;

@end

