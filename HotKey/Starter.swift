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
            if let script = item.function {
                callScript(script, function: "execute") { strings in
                    if let urls = strings?.map({NSURL(fileURLWithPath:$0)!}) {
                        url?.startAccessingSecurityScopedResource()
                        let bundleIdentifier = NSBundle(path: item.url)?.bundleIdentifier
                        println("\(bundleIdentifier) -> \(urls)")
                        if !workspace.openURLs(urls, withAppBundleIdentifier: bundleIdentifier, options: .Default, additionalEventParamDescriptor: nil, launchIdentifiers: nil) {
                            let path = urls[0].path!.stringByDeletingLastPathComponent
                            println("     \(path)")
                            if !workspace.openFile(path, withApplication: item.url) {
                                println("     launch...")
                                workspace.launchApplication(item.url)
                            }
                        }
                        url?.stopAccessingSecurityScopedResource()
                    } else {
                        workspace.launchApplication(item.url)
                    }
                }
            } else {
                workspace.launchApplication(item.url)
            }
        case .OTHER:
            url?.startAccessingSecurityScopedResource()
            workspace.openFile(item.url)
            url?.stopAccessingSecurityScopedResource()
        }
    }
    
    func callScript(script:String, function:String, completionHandler:(strings:[String]?) -> Void) {
        var err : NSError?
        let url = ScriptInstaller.baseURL.URLByAppendingPathComponent(script)
        if let script = NSUserAppleScriptTask(URL: url, error:&err) {
            if (err == nil) {
                script.executeWithAppleEvent(eventDescriptor(function)!) { result, err in
                    var strings:[String] = []
                    if result != nil {
                        for index in 0..<result.numberOfItems {
                            if let value = result.descriptorAtIndex(index+1)?.stringValue {
                                strings.append(value)
                            }
                        }
                    }
                    completionHandler(strings: strings)
                }
            } else {
                NSLog("script compile error: %@", err!)
            }
        } else {
            NSLog("script error: %@", err!)
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
        event?.setParamDescriptor(function!, forKeyword: AEKeyword(keyASSubroutineName))
        return event
    }
    
}
