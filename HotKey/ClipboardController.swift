//
//  ClipboardController.swift
//  HotKey
//
//  Created by Peter Vorwieger on 02.09.15.
//  Copyright © 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class ClipboardController: NSWindowController,NSWindowDelegate {
    
    @IBOutlet weak var labelView: LabelView!
    
    var isOpen = false
    
    convenience init() {
        self.init(windowNibName: "ClipboardController")
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.close()
    }
    
    override func keyDown(theEvent: NSEvent) {
        self.close()
    }
    
    func windowWillClose(notification: NSNotification) {
        self.isOpen = false
    }
    
    func toggle() {
        let myPasteboard = NSPasteboard.generalPasteboard()
        let cliptext = myPasteboard.stringForType(NSPasteboardTypeString)
        if cliptext == nil || cliptext == labelView?.text && isOpen {
            self.close()
        } else {
            isOpen = true
            super.showWindow(nil)
            labelView.text = cliptext!
            
            let screenSize = (NSScreen.mainScreen()?.frame.size)!
            let maxWidth = screenSize.width - 50
            let maxHeight = screenSize.height - 100
            let maxSize = NSSize(width: maxWidth, height: maxHeight)
            let aspectSize = labelView.aspectFitSize(maxSize)
            let frame = NSRect(origin:NSPoint.zero, size: aspectSize)
            window!.setFrame(frame, display: true, animate: false)
            window!.center()
            window!.level =  Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
        }
        
    }
}
