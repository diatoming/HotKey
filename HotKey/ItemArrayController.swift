//
//  ItemArrayController.swift
//  HotKey
//
//  Created by Peter Vorwieger on 10.02.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class ItemArrayController: NSArrayController, NSTableViewDataSource, NSTableViewDelegate {

    let movedRowType = "de.peter-vorwieger.ItemArrayController"
    
    @IBOutlet weak var tableView:NSTableView! {
        didSet {
            tableView.registerForDraggedTypes([movedRowType])
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
    }
    
    func tableView(tableView: NSTableView, writeRowsWithIndexes rowIndexes: NSIndexSet, toPasteboard pboard: NSPasteboard) -> Bool {
        let data = NSKeyedArchiver.archivedDataWithRootObject(rowIndexes)
        pboard.setData(data, forType:movedRowType)
        return true
    }
    
    func tableView(tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        if info.draggingSource() as? NSTableView == tableView {
            tableView.setDropRow(row, dropOperation: NSTableViewDropOperation.Above)
            return NSDragOperation.Move
        } else {
            return NSDragOperation.None
        }
    }
    
    func tableView(tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        if info.draggingSource() as NSTableView == tableView {
            let data = info.draggingPasteboard().dataForType(movedRowType)
            let indexSet = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as NSIndexSet
            var items = self.arrangedObjects as [Item]
            let item = items.removeAtIndex(indexSet.firstIndex)
            items.insert(item, atIndex:indexSet.firstIndex < row ? row-1 : row)
            for (index, item) in enumerate(items) {
                item.order = Int32(index)
            }
            return true;
        }
        return false;
    }
    
    func rowsAboveRow(row:Int, inIndexSet indexSet:NSIndexSet) -> Int {
        var currentIndex = indexSet.firstIndex
        var i = 0
        while currentIndex != NSNotFound {
            if currentIndex < row { i++ }
            currentIndex = indexSet.indexGreaterThanIndex(currentIndex)
        }
        return i
    }

}
