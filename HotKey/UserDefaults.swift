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
        defaultValues["createExampleOnStart"] = true
        defaultValues["openPrefsOnStart"] = true
        defaultValues["showPopupOnPrefs"] = true
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultValues)
    }
    
    class var createExampleOnStart:Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("createExampleOnStart")
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "createExampleOnStart")
        }
    }

    class var openPrefsOnStart:Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("openPrefsOnStart")
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "openPrefsOnStart")
        }
    }
    
    class var showPopupOnPrefs:Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("showPopupOnPrefs")
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "showPopupOnPrefs")
        }
    }

}
