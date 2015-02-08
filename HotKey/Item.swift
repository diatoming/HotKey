//
//  Item.swift
//  HotKey
//
//  Created by Peter Vorwieger on 27.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import CoreData

class Item: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var url: String
    @NSManaged var keyCode: Int32
    @NSManaged var modifierFlags: Int32
    
    var hotKey:MASShortcut? {
        get {
            let shortcut = MASShortcut(keyCode: UInt(keyCode), modifierFlags:UInt(modifierFlags))
            return modifierFlags != 0 ? shortcut : nil
        }
        set {
            keyCode = Int32(newValue != nil ? newValue!.keyCode : 0)
            modifierFlags = Int32(newValue != nil ? newValue!.modifierFlags : 0)
        }
    }
    
    class func insertNew(url:NSURL, managedObjectContext:NSManagedObjectContext) -> Item {
        let name = url.lastPathComponent?.stringByDeletingPathExtension
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item",
            inManagedObjectContext:managedObjectContext) as Item
        item.name = name!
        item.url = url.path!
        return item
    }

}
