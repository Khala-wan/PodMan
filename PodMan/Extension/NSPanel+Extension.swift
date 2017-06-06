//
//  NSPanel+Extension.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/22.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

extension NSWindow{
    class func loadWithNibName(_ name:String , _ loadClass:AnyClass) -> NSWindow {
        let nib:NSNib = NSNib.init(nibNamed: NSNib.Name(rawValue: name), bundle: nil)!
        var objects:NSArray = NSArray()
        if (!nib.instantiate(withOwner: nil, topLevelObjects: AutoreleasingUnsafeMutablePointer.init(&objects))){
            return NSWindow()
        }
        for object in objects{
            
            if (object as AnyObject).classForCoder == loadClass {
                return object as! NSWindow
            }
        }
        return NSWindow()
    }
}
