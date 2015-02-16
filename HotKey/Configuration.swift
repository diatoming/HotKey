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
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"changed",
                name:NSManagedObjectContextDidSaveNotification, object:nil)
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        var err:NSError?
        return managedObjectContext.executeFetchRequest(fetchRequest, error: &err) as [Item]
    }

}
