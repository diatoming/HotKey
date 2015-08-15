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
            callScript(item.scriptFunction) { strings in
                if let urls = strings?.map({NSURL(fileURLWithPath:$0)}) {
                    url?.startAccessingSecurityScopedResource()
                    let bundleIdentifier = NSBundle(path: item.url)?.bundleIdentifier
                    if !workspace.openURLs(urls, withAppBundleIdentifier: bundleIdentifier, options: .Default, additionalEventParamDescriptor: nil, launchIdentifiers: nil) {
                        workspace.launchApplication(item.url)
                    }
                    url?.stopAccessingSecurityScopedResource()
                } else {
                    workspace.launchApplication(item.url)
                }
            }
        case .OTHER:
            url?.startAccessingSecurityScopedResource()
            workspace.openFile(item.url)
            url?.stopAccessingSecurityScopedResource()
        }
    }
    
    func callScript(function:Item.ScriptFunction, completionHandler:(strings:[String]?) -> Void) {
        if function == Item.ScriptFunction.NOTHING {
            completionHandler(strings: nil)
        } else {
            var err : NSError?
            do {
                let script = try NSUserAppleScriptTask(URL: ScriptInstaller.scriptURL)
                if (err == nil) {
                    script.executeWithAppleEvent(eventDescriptor(function.rawValue)!) { result, err in
                        var strings:[String] = []
                        for index in 0..<result!.numberOfItems {
                            if let value = result!.descriptorAtIndex(index+1)?.stringValue {
                                strings.append(value)
                            }
                        }
                        completionHandler(strings: strings)
                    }
                } else {
                    NSLog("script compile error: %@", err!)
                }
            } catch let error as NSError {
                err = error
            }
        }
    }
    
    func eventDescriptor(functionName:String) -> NSAppleEventDescriptor? {
        var psn = ProcessSerialNumber(highLongOfPSN: UInt32(0), lowLongOfPSN: UInt32(kCurrentProcess))
        let target = NSAppleEventDescriptor(descriptorType: DescType(typeProcessSerialNumber),
            bytes:&psn, length:sizeof(ProcessSerialNumber))
        let function = NSAppleEventDescriptor(string: functionName)
        let event = NSAppleEventDescriptor(eventClass:AEEventClass(kASAppleScriptSuite),
            eventID:AEEventID(kASSubroutineEvent), targetDescriptor:target,
            returnID:AEReturnID(kAutoGenerateReturnID), transactionID: AETransactionID(kAnyTransactionID))
        event.setParamDescriptor(function, forKeyword: AEKeyword(keyASSubroutineName))
        return event
    }
    
}
