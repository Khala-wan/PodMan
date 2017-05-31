//
//  ImageButton.swift
//  Pudge
//
//  Created by 万圣 on 2017/4/26.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class ImageButton: NSButton {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    var normalImage:NSImage?{
        didSet{
            self.image = normalImage
            self.setUp()
        }
    }
    
    fileprivate final func setUp(){
    
        imageScaling = .scaleProportionallyUpOrDown
        isBordered  = false
        setButtonType(.momentaryChange)
    }
    
}
