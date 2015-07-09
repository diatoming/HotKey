//
//  ScriptArrayController.swift
//  HotKey
//
//  Created by Peter Vorwieger on 23.06.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa


class ScriptItem:NSObject {
    
    var name:String?
    
    override init() {
    }
    
    init(name:String) {
        self.name = name
    }
    
}

class ScriptArrayController: NSArrayController, NSMenuDelegate {
    
    var fileMonitor:FileSystemEventMonitor?
   	var	fileMonitorQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        var err : NSError?
        let fileManager = NSFileManager.defaultManager()
        let scriptDir = fileManager.URLForDirectory(NSSearchPathDirectory.ApplicationScriptsDirectory,
            inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: &err)!
        fileMonitor = FileSystemEventMonitor(
            pathsToWatch: [scriptDir.path!], latency: 0,
            watchRoot: false, queue: fileMonitorQueue) { events in
                println("rearrange")
                self.rearrangeObjects()
        }
    }
    
    override func arrangeObjects(objects: [AnyObject]) -> [AnyObject] {
        var err : NSError?
        let fileManager = NSFileManager.defaultManager()
        let scriptDir = fileManager.URLForDirectory(NSSearchPathDirectory.ApplicationScriptsDirectory,
            inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: &err)!
        let contents = fileManager.contentsOfDirectoryAtURL(scriptDir, includingPropertiesForKeys:[],
            options: NSDirectoryEnumerationOptions.SkipsHiddenFiles, error:&err) as? [NSURL]
        return contents!.map({url in
            return ScriptItem(name: url.lastPathComponent!)
        })
    }
    
}


