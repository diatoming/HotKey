//
//  LabelView.swift
//  HotKey
//
//  Created by Peter Vorwieger on 02.09.15.
//  Copyright © 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class LabelView: NSView {
    
    var text = "" {
        didSet {
            needsDisplay = true
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        // NSColor.windowBackgroundColor().set()
        // NSColor.clearColor().set()
        NSColor(white: 0.9, alpha: 0.9).set()
        NSRectFill(dirtyRect)
        text.drawInRect(frame, withAttributes: attributes)
    }
    
    var attributes:[String:AnyObject] {
        get {
            let fontSize = calculateFontSize(frame.size)
            let font = NSFont.systemFontOfSize(fontSize)
            let color = NSColor.textColor()
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.Center
            return [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: color,
                NSParagraphStyleAttributeName: style
            ]
        }
    }
    
    func calculateFontSize(size: NSSize) -> CGFloat {
        let sampleFont = NSFont.systemFontOfSize(100)
        let attributes = [NSFontAttributeName: sampleFont]
        let sampleSize = text.sizeWithAttributes(attributes)
        let width = size.width - 20
        let height = size.height
        let scale = min(width / sampleSize.width, height / sampleSize.height)
        return scale * sampleFont.pointSize
    }
    
    func aspectFitSize(original: NSSize) -> NSSize {
        let fontSize = calculateFontSize(original)
        let font = NSFont.systemFontOfSize(fontSize)
        let size = text.sizeWithAttributes([NSFontAttributeName: font])
        let width = min(original.width, size.width)
        let height = min(original.height, size.height)
        return NSSize(width: width, height:height)
    }
    
}
