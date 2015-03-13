//
//  Starter.swift
//  HotKey
//
//  Created by Peter Vorwieger on 30.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa
import Carbon

class Starter {

    func startApp(item:Item) {
        let workspace = NSWorkspace.sharedWorkspace()
        var err : NSError?
        if let script = NSUserAppleScriptTask(URL: ScriptInstaller.scriptURL, error:&err) {
            if (err != nil) {
                NSLog("script compile error: %@", err!)
                workspace.launchApplication(item.url)
            } else {
                script.executeWithAppleEvent(eventDescriptor()!, completionHandler: { result, err in
                    if (err != nil) {
                        NSLog("script error: %@", err!)
                        workspace.launchApplication(item.url)
                    } else {
                        if let path = result.stringValue {
                            println("path \(path)")
                            if !workspace.openFile(path, withApplication: item.url) {
                                println("path2 \(path.stringByDeletingLastPathComponent)")
                                if !workspace.openFile(path.stringByDeletingLastPathComponent, withApplication: item.url) {
                                    workspace.launchApplication(item.url)
                                }
                            }
                        } else {
                            NSLog("script did not return path")
                            workspace.launchApplication(item.url)
                        }
                    }
                })
            }
        } else {
            NSLog("no script found")
            workspace.launchApplication(item.url)
        }
    }
    
    func eventDescriptor() -> NSAppleEventDescriptor? {
        var psn = ProcessSerialNumber(highLongOfPSN: UInt32(0), lowLongOfPSN: UInt32(kCurrentProcess))
        let target = NSAppleEventDescriptor(descriptorType: DescType(typeProcessSerialNumber),
            bytes:&psn, length:sizeof(ProcessSerialNumber))
        let event = NSAppleEventDescriptor(eventClass:AEEventClass(kCoreEventClass),
            eventID:AEEventID(kAEOpenApplication), targetDescriptor:target,
            returnID:AEReturnID(kAutoGenerateReturnID), transactionID: AETransactionID(kAnyTransactionID))
        return event
    }

}
