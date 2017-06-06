//
//  VerticalCenterFieldCell.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/18.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class VerticalCenterFieldCell: NSTextFieldCell {
    
    func adjustFrameToVerticalCenter(frame:NSRect)->NSRect{
        let offset = frame.height * 0.5 - ((font?.ascender ?? 0) + (font?.descender ?? 0))
        return frame.insetBy(dx: 0.0, dy: offset)
    }
    
    override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
        super.edit(withFrame: adjustFrameToVerticalCenter(frame: rect), in: controlView, editor: textObj, delegate: delegate, event: event)
    }
    
    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        super.select(withFrame: adjustFrameToVerticalCenter(frame: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }
    
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.drawInterior(withFrame: adjustFrameToVerticalCenter(frame: cellFrame), in: controlView)
    }
}
