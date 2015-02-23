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
    @NSManaged var order: Int32
    
    var hotKey:MASShortcut? {
        get {
            let shortcut = MASShortcut(keyCode: UInt(keyCode), modifierFlags:UInt(modifierFlags))
            return modifierFlags != 0 ? shortcut : nil
        }
        set {
            keyCode = Int32(newValue != nil ? newValue!.keyCode : 0)
            modifierFlags = Int32(newValue != nil ? newValue!.modifierFlags : 0)
            self.managedObjectContext?.save(nil)
        }
    }
    
    class func insertNew(url:NSURL, managedObjectContext:NSManagedObjectContext) -> Item? {
        if itemExists(url, managedObjectContext:managedObjectContext) {
            return nil
        } else {
            let name = url.lastPathComponent?.stringByDeletingPathExtension
            let item = NSEntityDescription.insertNewObjectForEntityForName("Item",
                inManagedObjectContext:managedObjectContext) as Item
            item.name = name!
            item.url = url.path!
            return item
        }
    }

    class func itemExists(url:NSURL, managedObjectContext:NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Item")
        fetchRequest.predicate = NSPredicate(format:"url == %@", url.path!)
        let items = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as [Item]
        return !items.isEmpty
    }
    
}
