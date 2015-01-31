//
//  Item.swift
//  HotKey
//
//  Created by Peter Vorwieger on 27.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var modifier: Int32
    
}
