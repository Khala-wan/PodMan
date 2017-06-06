//
//  settingWindow.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/27.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class settingWindow: NSWindow ,NSTableViewDataSource,NSTableViewDelegate,ProcessDelegate{
    
    static func window() -> settingWindow{
        let window:settingWindow = settingWindow.loadWithNibName("settingWindow", settingWindow.classForCoder()) as! settingWindow
        NotificationCenter.default.addObserver(window, selector: #selector(windowWillClose(noti:)), name: NSWindow.willCloseNotification, object: nil)
        return window
    }
    
//MARK: ---- Life Cycle
    @objc fileprivate final func windowWillClose(noti:Notification){
        if noti.object is AddSpecWindow {
            NSApplication.shared.stopModal()
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
        NSApplication.shared.runModal(for: window)
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        loading = true
        let index:Int = specTableView.selectedRow
        currntRepoName = specList[index].name!
        let process:PodProcess = PodProcess.initWith(delegate: self)
        process.runPodRepoRemove(name: currntRepoName!)
        
    }
    
//MARK: ---- DataSource && Delegate
    func numberOfRows(in tableView: NSTableView) -> Int {
        return specList.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let item:PodSpecs = specList[row]
        switch (tableColumn?.identifier)!.rawValue {
        case "name":
            return item.name
        case "HTTPSURL":
            return item.httpsURL
        case "SSHURL":
            return item.sshURL
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 22
    }
    
    //PodProcessDelegate
    func ProcessDidFinished() {
        PodSpecs.deleteData(name: currntRepoName!)
        specTableView.reloadData()
        loading = false
    }
    
    func ProcessDidFailed(message: String) {
        loading = false
    }
    
    func ProcessDidOutPut(message: String) {
        
    }
//MARK: ---- getter && setter
    
    fileprivate var currntRepoName:String?
    
    var loading:Bool = false{
        didSet{
            deleteBtn.isHidden = loading
            loadingView.isHidden = !loading
            if loading {
                loadingView.startAnimation(nil)
            }else{
                loadingView.stopAnimation(nil)
            }
        }
    }
    
    @IBOutlet weak var specTableView: NSTableView!
    
    @IBOutlet weak var deleteBtn: NSButton!
    @IBOutlet weak var loadingView: NSProgressIndicator!
    fileprivate var specList:[PodSpecs]{
        get{
            return PodSpecs.queryData(nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
