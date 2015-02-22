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
            let task = NSTask()
            task.launchPath = "/usr/bin/open";
            task.arguments = ["-a", item.name]
            if let path = scriptResult.stringValue {
                var isDir : ObjCBool = false
                if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory:&isDir) {
                    if isDir {
                        task.arguments.append(path)
                    } else {
                        task.arguments.append(path.stringByDeletingLastPathComponent)
                    }
                }
            }
            task.launch()
        }
    }

}
