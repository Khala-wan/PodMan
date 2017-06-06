//
//  ProjectRowView.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/23.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class ProjectRowView: NSTableCellView {
    
    var type:project?{
        didSet{
            if case let project.pod(name, path, version ,lpath) = type!{
                var versionStr = version
                if version == "*" {
                   versionStr = FileManager.default.getVersionFromPodspec(url: path)
                }
                versionLabel.stringValue = versionStr
                nameLabel.stringValue = name
                filePath = path
                lintPath = lpath
                typeInfo = project.pod(name: name, path: path, version: versionStr, lintPath: lpath)
            }
            if case let project.app(name, path, lpath) = type!{
                versionLabel.stringValue = ""
                nameLabel.stringValue = name
                filePath = path
                lintPath = lpath
                typeInfo = project.app(name: name, path: path, lintPath: lpath)
            }
        }
    }
    
    var typeInfo:project?
    
    override var backgroundStyle: NSView.BackgroundStyle{
        didSet{
            nameLabel.textColor = backgroundStyle == .light ? NSColor.black : NSColor.white
            versionLabel.textColor = backgroundStyle == .light ? NSColor.black : NSColor.white
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context:CGContext = NSGraphicsContext.current!.cgContext
        context.move(to: CGPoint.init(x: 0, y: 0))
        context.addLine(to: CGPoint.init(x: bounds.size.width, y: 0))
        NSColor.getColor("dcdcdc").setStroke()
        context.strokePath()
    }
    
    var filePath:URL?
    
    var lintPath:String?
    
    @IBOutlet weak var versionLabel: NSTextField!
    
    @IBOutlet weak var nameLabel: NSTextField!
}
