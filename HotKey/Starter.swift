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
    
    let clipboardController = ClipboardController()
    
    func startApp(item:Item) {
        let workspace = NSWorkspace.sharedWorkspace()
        let url = UserDefaults.bookmarkedURL
        
        switch item.type {
        case .APP:
            callScript("selectedFiles") { strings in
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
        case .CLIPBOARD:
            clipboardController.showWindow(self)
        }
    }
    
    func callScript(function:String, completionHandler:(strings:[String]?) -> Void) {
        do {
            let script = try NSUserAppleScriptTask(URL: ScriptInstaller.scriptURL)
            script.executeWithAppleEvent(eventDescriptor(function)!) { result, err in
                var strings:[String] = []
                if (err == nil) {
                    for index in 0..<result!.numberOfItems {
                        if let value = result!.descriptorAtIndex(index+1)?.stringValue {
                            strings.append(value)
                        }
                    }
                }
                completionHandler(strings: strings)
            }
        } catch _ {
            completionHandler(strings: [])
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
