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
        var defaultValues = [String:AnyObject]()
        defaultValues["hideAppIcon"] = false
        defaultValues["createExampleOnStart"] = true
        defaultValues["openPrefsOnStart"] = true
        defaultValues["showPopupOnPrefs"] = true
        defaults.registerDefaults(defaultValues)
    }

    class var hideAppIcon:Bool {
        get {return defaults.boolForKey("hideAppIcon")}
        set {defaults.setBool(newValue, forKey:"hideAppIcon")}
    }

    class var createExampleOnStart:Bool {
        get {return defaults.boolForKey("createExampleOnStart")}
        set {defaults.setBool(newValue, forKey:"createExampleOnStart")}
    }

    class var openPrefsOnStart:Bool {
        get {return defaults.boolForKey("openPrefsOnStart")}
        set {defaults.setBool(newValue, forKey:"openPrefsOnStart")}
    }
    
    class var bookmarkedURL:NSURL? {
        get {
            if let data = defaults.objectForKey("bookmark") as? NSData {
                var isStale: ObjCBool = false
                do {
                    return try NSURL(byResolvingBookmarkData: data, options: .WithSecurityScope,
                        relativeToURL: nil, bookmarkDataIsStale: &isStale)
                } catch _ {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if newValue != nil {
                let data: NSData?
                do {
                    data = try newValue!.bookmarkDataWithOptions(.WithSecurityScope,
                                        includingResourceValuesForKeys: nil, relativeToURL: nil)
                } catch _ {
                    data = nil
                }
                defaults.setObject(data, forKey: "bookmark")
            } else {
                defaults.removeObjectForKey("bookmark")
            }
        }
    }

}
