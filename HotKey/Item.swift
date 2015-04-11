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
        case APP, OTHER
    }

    enum ScriptFunction: String {
        case NOTHING = "", FILES = "selectedFiles", FILES_FOLDER = "selectedFilesOrFolders"
    }

    @NSManaged var enabled: Bool
    @NSManaged var name: String
    @NSManaged var url: String
    @NSManaged var keyCode: Int32
    @NSManaged var modifierFlags: Int32
    @NSManaged var order: Int32
    @NSManaged var function: String?
    
    var _enabled:Bool {
        set {
            enabled = newValue
            self.managedObjectContext?.save(nil)
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
            switch url.pathExtension {
                case "app": return Type.APP
                default: return Type.OTHER
            }
        }
    }

    var scriptFunction: ScriptFunction {
        get {
            return function != nil ? ScriptFunction(rawValue: function!)! : ScriptFunction.FILES
        }
        set {
            function = String(newValue.rawValue)
        }
    }
    
    var kind:String {
        let workspace = NSWorkspace.sharedWorkspace()
        var err:NSError?
        let type = workspace.typeOfFile(self.url, error: &err)
        return workspace.localizedDescriptionForType(type!)!
    }

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

    class func itemExists(url:NSURL, managedObjectContext:NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Item")
        fetchRequest.predicate = NSPredicate(format:"url == %@", url.path!)
        let items = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [Item]
        return !items.isEmpty
    }

    class func insertNew(url:NSURL, managedObjectContext:NSManagedObjectContext) -> Item? {
        if itemExists(url, managedObjectContext:managedObjectContext) {
            return nil
        } else {
            let name = url.lastPathComponent?.stringByDeletingPathExtension
            let item = NSEntityDescription.insertNewObjectForEntityForName("Item",
                inManagedObjectContext:managedObjectContext) as! Item
            item.enabled = true
            item.name = name!
            item.url = url.path!
            return item
        }
    }
}
