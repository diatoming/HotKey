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
        let url = UserDefaults.bookmarkedURL
        switch item.type {
            case .APP:
                callScript { path in
                    if path != nil {
                        url?.startAccessingSecurityScopedResource()
                        if !workspace.openFile(path!, withApplication: item.url) {
                            if !workspace.openFile(path!.stringByDeletingLastPathComponent, withApplication: item.url) {
                                workspace.launchApplication(item.url)
                            }
                        }
                        url?.stopAccessingSecurityScopedResource()
                    } else {
                        workspace.launchApplication(item.url)
                    }
                }
                break;
            case .OTHER:
                url?.startAccessingSecurityScopedResource()
                workspace.openFile(item.url)
                url?.stopAccessingSecurityScopedResource()
                break;
        }
    }
    
    func callScript(completionHandler:(path:String?) -> Void) {
        var err : NSError?
        if let script = NSUserAppleScriptTask(URL: ScriptInstaller.scriptURL, error:&err) {
            if (err == nil) {
                script.executeWithAppleEvent(eventDescriptor()!) { result, err in
                    
                    completionHandler(path: result.stringValue)
                }
            } else {
                NSLog("script compile error: %@", err!)
            }
        }
    }
    
    func eventDescriptor() -> NSAppleEventDescriptor? {
        var psn = ProcessSerialNumber(highLongOfPSN: UInt32(0), lowLongOfPSN: UInt32(kCurrentProcess))
        let target = NSAppleEventDescriptor(descriptorType: DescType(typeProcessSerialNumber),
            bytes:&psn, length:sizeof(ProcessSerialNumber))
        let eventDescriptor = NSAppleEventDescriptor(eventClass:AEEventClass(kCoreEventClass),
            eventID:AEEventID(kAEOpenApplication), targetDescriptor:target,
            returnID:AEReturnID(kAutoGenerateReturnID), transactionID: AETransactionID(kAnyTransactionID))
        return eventDescriptor
    }

}
