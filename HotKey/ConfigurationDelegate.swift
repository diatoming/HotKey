//
//  ConfigurationDelegate.swift
//  HotKey
//
//  Created by Peter Vorwieger on 29.01.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Foundation

protocol ConfigurationDelegate {
    
    func willInsert()
    
    func doInsert(item:Item)

    func didInsert()

}
