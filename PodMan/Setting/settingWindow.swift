//
//  settingWindow.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/27.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class settingWindow: NSWindow {
    
    static func window() -> settingWindow {
        let window:settingWindow = settingWindow.loadWithNibName("settingWindow", settingWindow.classForCoder()) as! settingWindow
        NotificationCenter.default.addObserver(window, selector: #selector(windowWillClose(noti:)), name: NSNotification.Name.NSWindowWillClose, object: nil)
        return window
    }
    
//MARK: ---- Life Cycle
    @objc fileprivate final func windowWillClose(noti:Notification){
        NSApplication.shared().stopModal()
    }
    
    
//MARK: ---- Event Response
    @IBAction func addBtnClicked(_ sender: Any) {
        let window:AddSpecWindow = AddSpecWindow.window()
        NSApplication.shared().runModal(for: window)
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
    }
    
//MARK: ---- getter && setter
    @IBOutlet weak var specTableView: NSTableView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
