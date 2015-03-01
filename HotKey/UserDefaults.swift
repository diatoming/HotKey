//
//  UserDefaults.swift
//  HotKey
//
//  Created by Peter Vorwieger on 24.02.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

class UserDefaults {
    
    class func initialize() {
        var defaultValues:[NSObject:AnyObject] = [:]
        defaultValues["firstStart"] = true
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultValues)
    }
    
    class var firstStart:Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("firstStart")
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "firstStart")
        }
    }
    
}
