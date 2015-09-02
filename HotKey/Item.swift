//
//  Item.swift
//  HotKey
//
//  Created by Peter Vorwieger on 27.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import CoreData

class Item: NSManagedObject {
    
    enum Type {
        case APP, OTHER, CLIPBOARD
    }

    @NSManaged var enabled: Bool
    @NSManaged var name: String
    @NSManaged var url: String
    @NSManaged var keyCode: Int32
    @NSManaged var modifierFlags: Int32
    @NSManaged var order: Int32
    
    var _enabled:Bool {
        set {
            enabled = newValue
            do {
                try self.managedObjectContext?.save()
            } catch _ {
            }
        }
        get {
            return enabled
        }
    }

    var icon:NSImage? {
        get {
            return IconTransformer().transformedValue(self.url) as? NSImage
        }
    }

    var type:Type {
        get {
            switch (url as NSString).pathExtension {
                case "app": return Type.APP
                default: return Type.OTHER
            }
        }
    }

    var kind:String {
        let workspace = NSWorkspace.sharedWorkspace()
        let type: String?
        do {
            type = try workspace.typeOfFile(self.url)
        } catch {
            type = nil
        }
        return workspace.localizedDescriptionForType(type!)!
    }

    var hotKey:Shortcut? {
        get {
            let shortcut = Shortcut(keyCode: UInt(keyCode), modifierFlags:UInt(modifierFlags))
            return modifierFlags != 0 ? shortcut : nil
        }
        set {
            keyCode = Int32(newValue != nil ? newValue!.keyCode : 0)
            modifierFlags = Int32(newValue != nil ? newValue!.modifierFlags : 0)
            do {
                try self.managedObjectContext?.save()
            } catch _ {
            }
        }
    }

    class func itemExists(url:NSURL, managedObjectContext:NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Item")
        fetchRequest.predicate = NSPredicate(format:"url == %@", url.path!)
        let items = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Item]
        return !items.isEmpty
    }

    class func insertNew(url:NSURL, managedObjectContext:NSManagedObjectContext) -> Item? {
        if itemExists(url, managedObjectContext:managedObjectContext) {
            return nil
        } else {
            let name = (url.lastPathComponent! as NSString).stringByDeletingPathExtension
            let item = NSEntityDescription.insertNewObjectForEntityForName("Item",
                inManagedObjectContext:managedObjectContext) as! Item
            item.enabled = true
            item.name = name
            item.url = url.path!
            return item
        }
    }
}
