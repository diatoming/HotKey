//
//  ViewController.h
//  HotKey
//
//  Created by Peter Vorwieger on 08.12.14.
//  Copyright (c) 2014 Peter Vorwieger. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (assign) IBOutlet NSButton *launchAtLoginButton;

-(IBAction)toggleLaunchAtLogin:(id)sender;

@end

