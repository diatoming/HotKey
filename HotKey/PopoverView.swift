//
//  PopoverView.swift
//  HotKey
//
//  Created by Peter Vorwieger on 25.02.15.
//  Copyright (c) 2015 Peter Vorwieger. All rights reserved.
//

import Cocoa

class PopoverView: NSView {

    private func setup() {
        self.layer = CALayer()
        self.wantsLayer = true
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setAnchorPoint() {
        let frame = self.layer?.frame
        self.layer?.position = CGPoint(x:CGRectGetMidX(frame!), y:CGRectGetMidY(frame!))
        self.layer?.anchorPoint = CGPointMake(0.5, 0.5)
    }
    
    func showPopup() {
        self.hidden = false
        self.setAnchorPoint()
        self.layer?.pop_removeAllAnimations()

        let show = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
        show.toValue = 1.0
        self.layer?.pop_addAnimation(show, forKey:"show")
        
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSize(width: 1.0, height: 1.0))
        scaleAnim.velocity = NSValue(CGSize: CGSize(width: 4.0, height: 4.0))
        scaleAnim.springBounciness = 20.0
        self.layer?.pop_addAnimation(scaleAnim, forKey:"scaleAnim")
        
        let hideAnim = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
        hideAnim.beginTime = CACurrentMediaTime() + 10.0
        hideAnim.toValue = 0.0
        self.layer?.pop_addAnimation(hideAnim, forKey:"hideAnim")
    }
    
}
