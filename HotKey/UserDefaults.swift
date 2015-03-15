//
//  UserDefaults.swift
//  HotKey
//
//  Created by Peter Vorwieger on 24.02.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

class UserDefaults {

    class var defaults:NSUserDefaults {
        get { return NSUserDefaults.standardUserDefaults() }
    }

    class func initialize() {
        var defaultValues:[NSObject:AnyObject] = [:]
        defaultValues["createExampleOnStart"] = true
        defaultValues["openPrefsOnStart"] = true
        defaultValues["showPopupOnPrefs"] = true
        defaults.registerDefaults(defaultValues)
    }
    
    class var createExampleOnStart:Bool {
        get {return defaults.boolForKey("createExampleOnStart")}
        set {defaults.setBool(newValue, forKey:"createExampleOnStart")}
    }

    class var openPrefsOnStart:Bool {
        get {return defaults.boolForKey("openPrefsOnStart")}
        set {defaults.setBool(newValue, forKey:"openPrefsOnStart")}
    }
    
    class var showPopupOnPrefs:Bool {
        get {return defaults.boolForKey("showPopupOnPrefs")}
        set {defaults.setBool(newValue, forKey:"showPopupOnPrefs")}
    }
    
    class var bookmarkedURL:NSURL? {
        get {
            if let data = defaults.objectForKey("bookmark") as? NSData {
                var isStale: ObjCBool = false
                return NSURL(byResolvingBookmarkData: data, options: .WithSecurityScope,
                    relativeToURL: nil, bookmarkDataIsStale: &isStale, error: nil)
            } else {
                return nil
            }
        }
        set {
            if newValue != nil {
                let data = newValue!.bookmarkDataWithOptions(.WithSecurityScope,
                    includingResourceValuesForKeys: nil, relativeToURL: nil, error: nil)
                defaults.setObject(data, forKey: "bookmark")
            } else {
                defaults.removeObjectForKey("bookmark")
            }
        }
    }

}
