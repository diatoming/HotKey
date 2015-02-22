//
//  Starter.swift
//  HotKey
//
//  Created by Peter Vorwieger on 30.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class Starter: NSObject {

    func startApp(item:Item) {
        let scriptURL = NSBundle.mainBundle().URLForResource("script", withExtension: "txt")
        var err : NSDictionary?
        let script = NSAppleScript(contentsOfURL: scriptURL!, error:&err)
        if (err != nil) {
            NSLog("script compile error: %@", err!)
        } else if let scriptResult = script?.executeAndReturnError(&err) {
            let workspace = NSWorkspace.sharedWorkspace()
            if let path = scriptResult.stringValue {
                if !workspace.openFile(path, withApplication: item.url) {
                    if !workspace.openFile(path.stringByDeletingLastPathComponent, withApplication: item.url) {
                        workspace.launchApplication(item.url)
                    }
                }
            } else {
                workspace.launchApplication(item.url)
            }
        }
    }

}
