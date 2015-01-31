//
//  Configuration.swift
//  HotKey
//
//  Created by Peter Vorwieger on 30.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class Configuration: NSObject {

    var managedObjectContext:NSManagedObjectContext
    var delegates:[ConfigurationDelegate] = []

    init(_ managedObjectContext:NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func changed() {
        for config in delegates {
            config.willInsert()
        }
        for item in loadItems() {
            for config in delegates {
                config.doInsert(item)
            }
        }
        for config in delegates {
            config.didInsert()
        }
    }
    
    func loadItems() -> [Item] {
        let fetchRequest = NSFetchRequest(entityName: "Item")
        fetchRequest.predicate = NSPredicate(value: true)
        var err:NSError?
        return managedObjectContext.executeFetchRequest(fetchRequest, error: &err) as [Item]
    }

    
    //        let context = persistenceStack!.managedObjectContext!
    //        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as Item
    //        item.name = "ONKI"
    //        item.modifier = Int32(NSEventModifierFlags.CommandKeyMask.rawValue + NSEventModifierFlags.ShiftKeyMask.rawValue)
    //
    //        var err:NSError?
    //        context.save(&err)

}
