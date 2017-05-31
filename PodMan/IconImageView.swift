//
//  IconImageView.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/18.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class IconImageView: NSImageView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

    }
    
    override func awakeFromNib() {
        layer?.cornerRadius = 36
        layer?.borderColor = NSColor.white.cgColor
        //layer?.borderWidth = 2
        layer?.masksToBounds = true
    }
    
    override var allowsVibrancy: Bool{
        return false
    }
    
}
