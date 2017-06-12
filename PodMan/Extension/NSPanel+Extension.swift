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
        var tempObjects:NSArray? = NSArray()
        if (!nib.instantiate(withOwner: nil, topLevelObjects: &tempObjects)){
            return NSWindow()
        }
        for object in tempObjects!{
            
            if (object as AnyObject).classForCoder == loadClass {
                return object as! NSWindow
            }
        }
        return NSWindow()
    }
}

extension NSMenu{
    class func loadWithNibName(_ name:String , _ loadClass:AnyClass) -> NSMenu {
        let nib:NSNib = NSNib.init(nibNamed: NSNib.Name(rawValue: name), bundle: nil)!
        var tempObjects:NSArray? = NSArray()
        if (!nib.instantiate(withOwner: nil, topLevelObjects: &tempObjects)){
            return NSMenu()
        }
        for object in tempObjects!{
            
            if (object as AnyObject).classForCoder == loadClass {
                return object as! NSMenu
            }
        }
        return NSMenu()
    }
}
