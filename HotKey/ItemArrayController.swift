//
//  ItemArrayController.swift
//  HotKey
//
//  Created by Peter Vorwieger on 10.02.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class ItemArrayController: NSArrayController, NSTableViewDataSource, NSTableViewDelegate, NSPopoverDelegate {
    
    let movedRowType = "de.codenuts.ItemArrayController"
    
    let shortcutRecorder = ShortcutRecorder()
    
    @IBOutlet weak var popover:NSPopover! {
        didSet {
            popover.delegate = self
        }
    }
    
    @IBOutlet weak var tableView:NSTableView! {
        didSet {
            tableView.registerForDraggedTypes([movedRowType])
        }
    }
    
    func popoverWillClose(notification: NSNotification) {
        shortcutRecorder.stopMonitoring()
        // HotKeyMonitor.sharedInstance.start()
        // self.tableView.reloadData()
        tableView.window?.makeFirstResponder(tableView)
    }
    
    func popoverWillShow(notification: NSNotification) {
        // HotKeyMonitor.sharedInstance.unregisterAllShortcuts()
        // HotKeyMonitor.sharedInstance.stop()
        
    }
    
    @IBAction func click(sender: NSButton) {
        popover.showRelativeToRect(NSRect.zero, ofView: sender, preferredEdge: NSRectEdge.MinX)
        sender.window?.makeFirstResponder(sender)
        // sender.title = "..."
        let row = tableView.rowForView(sender)
        let item = arrangedObjects[row] as! Item
        shortcutRecorder.start() {shortcut,changed in
            if changed {
                item.hotKey = shortcut
            }
            self.tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
    }
    
    func addItem(url:NSURL) {
        if let item = Item.insertNew(url, managedObjectContext:self.managedObjectContext!) {
            item.order = Int32(self.arrangedObjects.count)
            self.rearrangeOrder()
        }
    }
    
    override func remove(sender: AnyObject?) {
        super.remove(sender)
        self.rearrangeOrder()
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
        if info.draggingSource() as! NSTableView == tableView {
            let data = info.draggingPasteboard().dataForType(movedRowType)
            let indexSet = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! NSIndexSet
            var items = self.arrangedObjects as! [Item]
            let item = items.removeAtIndex(indexSet.firstIndex)
            items.insert(item, atIndex:indexSet.firstIndex < row ? row-1 : row)
            for (index, item) in items.enumerate() {
                item.order = Int32(index)
            }
            do {
                try self.managedObjectContext?.save()
            } catch _ {
            }
            return true;
        }
        return false;
    }
    
    func rearrangeOrder() {
        for (index, item) in (arrangedObjects as! [Item]).enumerate() {
            item.order = Int32(index)
        }
        do {
            try self.managedObjectContext?.save()
        } catch _ {
        }
    }
    
}
