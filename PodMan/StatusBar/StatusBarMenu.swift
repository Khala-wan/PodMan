//
//  StatusBarMenu.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/7.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

public enum PodManOperationType : String{
    case Init = "初始化"
    case install
    case update
    case lint
    case specLint
    case tag
    case release
    case addSpec
    case removeSpec
    case create
    case unknow
}

protocol statusBarMenuDelegate {
    func statusBarItemClicked(type:PodManOperationType)
}

class StatusBarMenu: NSMenu ,NSMenuDelegate{
    
//MARK: ---- event response
    @IBAction func itemClicked(_ sender: NSMenuItem) {
        var type:PodManOperationType?
        switch sender.tag {
        case 1:
            type = .lint
        case 2:
            type = .specLint
        case 3:
            type = .tag
        case 4:
            type = .release
        case 5:
            type = .install
        case 6:
            type = .update
        default:
            type = .unknow
        }
        guard type != .unknow else {
            return
        }
        self.statusDelegate?.statusBarItemClicked(type: type!)
    }
    
    @IBAction func showClicked(_ sender: Any) {
        if !NSApplication.shared.isActive {
            NSRunningApplication.current.activate(options: [.activateAllWindows,.activateIgnoringOtherApps])
        }
        NSApplication.shared.windows.forEach { (window) in
            window.deminiaturize(nil)
        }
    }


    
//MARK: ---- getter && setter
    var isPod:Bool?{
        didSet{
            if isPod != nil {
                PodOpertaionItem.isEnabled = isPod!
                lintItem.isEnabled = isPod!
                specLintItem.isEnabled = isPod!
                tagItem.isEnabled = isPod!
                releaseItem.isEnabled = isPod!
                PodFileOperationItem.isEnabled = !isPod!
                installItem.isEnabled = !isPod!
                UpdateItem.isEnabled = !isPod!
            }
        }
    }
    
    var projectName:String?{
        didSet{
            podNameItem.title = projectName ?? ""
        }
    }
    
    var statusDelegate:statusBarMenuDelegate?
    
    @IBOutlet weak var UpdateItem: NSMenuItem!
    @IBOutlet weak var installItem: NSMenuItem!
    @IBOutlet weak var releaseItem: NSMenuItem!
    @IBOutlet weak var tagItem: NSMenuItem!
    @IBOutlet weak var specLintItem: NSMenuItem!
    @IBOutlet weak var lintItem: NSMenuItem!
    
    @IBOutlet weak var PodOpertaionItem: NSMenuItem!
    @IBOutlet weak var PodFileOperationItem: NSMenuItem!
    @IBOutlet weak var showItem: NSMenuItem!
    @IBOutlet weak var podNameItem: NSMenuItem!
    
}
