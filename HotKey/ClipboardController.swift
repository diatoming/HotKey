//
//  ClipboardController.swift
//  HotKey
//
//  Created by Peter Vorwieger on 02.09.15.
//  Copyright © 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class ClipboardController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var labelView: LabelView!
    
    convenience init() {
        self.init(windowNibName: "ClipboardController")
        self.window!.delegate = self
    }
    
    func windowDidExpose(notification: NSNotification) {
        Swift.print("windowDidExpose")
    }
    
    override func windowDidLoad() {
        Swift.print("windowDidLoad")
        super.windowDidLoad()
    }
    
    func windowDidResignKey(notification: NSNotification) {
        Swift.print("windowDidResignKey")
    }

    func windowDidResignMain(notification: NSNotification) {
        Swift.print("windowDidResignMain")
    }
    
    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)
        
        let myPasteboard = NSPasteboard.generalPasteboard()
        if let text = myPasteboard.stringForType(NSPasteboardTypeString) {
            labelView.text = text
        }
        let padding:CGFloat = 100
        let screenSize = (NSScreen.mainScreen()?.frame.size)!
        let size = labelView.aspectFitSize(NSSize(width: screenSize.width-padding, height: screenSize.height-padding))
        let frame = NSRect(origin:NSPoint.zero, size: size)
        
        window!.setFrame(frame, display: true, animate: false)
        window!.center()
        
        window!.level = Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
        
       // window!.level =  Int(CGWindowLevelForKey(.MaximumWindowLevelKey))

        
    }
    
}
