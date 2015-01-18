//
//  PreferencesWindowController.m
//  HotKey
//
//  Created by Peter Vorwieger on 18.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

#import "PreferencesWindowController.h"
#import <ServiceManagement/ServiceManagement.h>

@interface PreferencesWindowController ()

@end

@implementation PreferencesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    BOOL enabled = [self appIsPresentInLoginItems];
    [self.launchAtLoginButton setState:enabled?NSOnState:NSOffState];
}

-(IBAction)toggleLaunchAtLogin:(id)sender {
    if ([sender state] == NSOnState) {
        // Turn on launch at login
        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)@"de.peter-vorwieger.HotKeyHelper", YES)) {
            NSLog(@"Couldn't add Helper App to launch at login item list.");
        }
    } else {
        // Turn off launch at login
        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)@"de.peter-vorwieger.HotKeyHelper", NO)) {
            NSLog(@"Couldn't remove Helper App from launch at login item list");
        }
    }
}

-(BOOL)appIsPresentInLoginItems {
    NSString *bundleID = @"de.peter-vorwieger.HotKeyHelper";
    NSArray * jobDicts = (__bridge NSArray *)SMCopyAllJobDictionaries( kSMDomainUserLaunchd );
    // Note: Sandbox issue when using SMJobCopyDictionary()
    
    if ( (jobDicts != nil) && [jobDicts count] > 0 ) {
        BOOL bOnDemand = NO;
        for ( NSDictionary * job in jobDicts ) {
            if ( [bundleID isEqualToString:[job objectForKey:@"Label"]] ) {
                bOnDemand = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }
        
        CFRelease((CFDictionaryRef)jobDicts); jobDicts = nil;
        return bOnDemand;
        
    }
    return NO;
}


@end
