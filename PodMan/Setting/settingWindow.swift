//
//  settingWindow.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/27.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class settingWindow: NSWindow ,NSTableViewDataSource,NSTableViewDelegate{
    
    static func window() -> settingWindow{
        let window:settingWindow = settingWindow.loadWithNibName("settingWindow", settingWindow.classForCoder()) as! settingWindow
        NotificationCenter.default.addObserver(window, selector: #selector(windowWillClose(noti:)), name: NSNotification.Name.NSWindowWillClose, object: nil)
        return window
    }
    
//MARK: ---- Life Cycle
    @objc fileprivate final func windowWillClose(noti:Notification){
        if noti.object is AddSpecWindow {
            NSApplication.shared().stopModal()
            specTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        specTableView.dataSource = self
        specTableView.delegate = self
        
    }
    
    
//MARK: ---- Event Response
    @IBAction func addBtnClicked(_ sender: Any) {
        let window:AddSpecWindow = AddSpecWindow.window()
        NSApplication.shared().runModal(for: window)
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
    }
    
//MARK: ---- DataSource && Delegate
    func numberOfRows(in tableView: NSTableView) -> Int {
        return specList.count
    }
    
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        let view = NSTextField()
//        view.isBordered = false
//        let item:PodSpecs = specList[row]
//        view.stringValue = tableColumn?.identifier == "name" ? item.name ?? "" : item.repoURL ?? ""
//        return view
//    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let item:PodSpecs = specList[row]
        return tableColumn?.identifier == "name" ? item.name ?? "" : item.repoURL ?? ""
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 22
    }
    
//MARK: ---- getter && setter
    @IBOutlet weak var specTableView: NSTableView!
    
    fileprivate var specList:[PodSpecs]{
        get{
            return PodSpecs.queryData(nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
