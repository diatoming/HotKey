//
//  ViewController.m
//  HotKey
//
//  Created by Peter Vorwieger on 08.12.14.
//  Copyright (c) 2014 Peter Vorwieger. All rights reserved.
//

#import "ViewController.h"
#import <ServiceManagement/ServiceManagement.h>

@implementation ViewController

-(IBAction)toggleLaunchAtLogin:(id)sender {
    NSInteger clickedSegment = [sender selectedSegment];
    if (clickedSegment == 0) { // ON
        // Turn on launch at login
        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)@"de.peter-vorwieger.HotKeyHelper", YES)) {
            NSLog(@"Couldn't add Helper App to launch at login item list.");
        }
    }
    if (clickedSegment == 1) { // OFF
        // Turn off launch at login
        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)@"de.peter-vorwieger.HotKeyHelper", NO)) {
            NSLog(@"Couldn't remove Helper App from launch at login item list");
        }
    }
}

@end
