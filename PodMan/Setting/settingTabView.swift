//
//  settingTabView.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/27.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class settingTabView: NSTabView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context:CGContext = (NSGraphicsContext.current?.cgContext)!
        NSColor.clear.setFill()
        context.fill(dirtyRect)
        
    }
    
}
