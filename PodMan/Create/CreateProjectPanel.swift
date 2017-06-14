//
//  CreateProjectPanel.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/22.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class CreateProjectPanel: NSWindow ,NSComboBoxDelegate,NSComboBoxDataSource,ProcessDelegate{
    
    static func panel() -> CreateProjectPanel {
        let panel:CreateProjectPanel = CreateProjectPanel.loadWithNibName("CreateProjectPanel", CreateProjectPanel.classForCoder()) as! CreateProjectPanel
        return panel
    }

    static func panel(path:URL, name:String,completionHandler:@escaping (_ item:PodModel,_ isCreate:Bool)->()) -> CreateProjectPanel {
        let panel:CreateProjectPanel = CreateProjectPanel.panel()
        panel.isCreate = false
        panel.setFrame(NSRect.init(x: 0, y: 0, width: 400, height: 185), display: true)
        panel.center()
        panel.podNameLabel.isEditable = false
        panel.podNameLabel.stringValue = name
        panel.pathLabel.stringValue = path.deletingLastPathComponent().absoluteString
        panel.PodInfo["podPath"] = panel.pathLabel.stringValue
        panel.completionHandler = completionHandler
        return panel
    }
    
    static func panel(completionHandler:@escaping (_ newProject:project,_ item:PodModel,_ isCreate:Bool)->()) -> CreateProjectPanel {
        let panel:CreateProjectPanel = CreateProjectPanel.panel()
        panel.completionHandlerForCrate = completionHandler
        return panel
    }
    
    
//MARK: ---- Life Cycle
    override func awakeFromNib() {
        let titles:[String] = sepcsRepos.map({ (specs) -> String in
            return specs.name ?? ""
        })
        specsRepoPopUp.addItems(withTitles: titles)
        
        //默认配置
        PodInfo["specsRepo"] = specsRepoPopUp.itemTitles.first
        PodInfo["testTool"] = "Quick"
        PodInfo["viewTest"] = "yes"
        PodInfo["demoAPP"] = "yes"
        PodInfo["lan"] = "swift"
    }
    
//MARK: ---- Event Response
    
    @IBAction func chooseBtnClicked(_ sender: Any) {
        
        let panel:NSOpenPanel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.beginSheetModal(for: self) { (res:NSApplication.ModalResponse) in
            if res == .OK,let url = panel.url{
                let path:String = url.absoluteString.replacingOccurrences(of: "file://", with: "")
                self.PodInfo["podPath"] = path
                self.pathLabel.stringValue = path
            }
        }
    }

    @IBAction func privatePodChanged(_ sender: NSButton) {
        isPrivatePod = sender.state == .on
    }
    
    
    @IBAction func languageChoose(_ sender: NSButton) {
        if sender.tag == 101 {
            PodInfo["lan"] = "swift"
            testTool1.title = "Quick"
            testTool2.isHidden = true
        }else{
            PodInfo["lan"] = "objc"
            testTool1.title = "Specta"
            testTool2.isHidden = false
            testTool2.title = "Kiwi"
        }
        testTool1.state = .off
        testTool2.state = .off
    }

    @IBAction func testToolChoose(_ sender: NSButton) {
        PodInfo["testTool"] = sender.title
    }
    
    @IBAction func viewTestChanged(_ sender: NSButton) {
        PodInfo["viewTest"] = sender.state == .off ? "no" : "yes"
    }
    @IBAction func demoAPPChanged(_ sender: NSButton) {
        PodInfo["demoAPP"] = sender.state == .off ? "no" : "yes"
    }
    
    @IBAction func createBtnClicked(_ sender: Any) {
        PodInfo["podName"] = podNameLabel.stringValue
        if isCreate {
            guard validatePodInfo(info: PodInfo, isPrivate: isPrivatePod) else {
                return
            }
            PodProcess.initWith(operation: .create, delegate: self).runPodCreate(podInfo:PodInfo)
        }else{
            ProcessDidSuccessed(opration: .create)
        }
        
    }
    @IBAction func SpecsRepoChanged(_ sender: Any) {
        
        let name:String = specsRepoPopUp.itemTitles[specsRepoPopUp.indexOfSelectedItem]
        PodInfo["specsRepo"] = name
    }
    
//MARK: ---- delegate
    
    //MARK:PodProcess
    func ProcessDidSuccessed(opration: PodManOperationType) {
        close()
        let podItem = getPodItemFromPodInfo(info: PodInfo)
        if isCreate {
            var path:URL = URL.init(string: podItem.dictionary!)!
            path.appendPathComponent("\(podItem.name!).podspec")
            let newProject = project.pod(name: podItem.name!, path: path, version: "0.1.0", lintPath: path.absoluteString)
            completionHandlerForCrate(newProject,podItem,isCreate)
        }else{
            completionHandler(podItem, isCreate)
        }
    }
    
    func ProcessDidFailed(opration: PodManOperationType, message: String) {
        let alert:NSAlert = NSAlert()
        alert.messageText = message
        alert.beginSheetModal(for: self, completionHandler: nil)
    }

//MARK: ---- private Method
    fileprivate final func validatePodInfo(info:[String:String],isPrivate:Bool)->Bool{
        var paramas:[String] = ["podName","podPath"]
        if isPrivate {
            paramas += ["specsRepo","lan","testTool","viewTest","demoAPP"]
        }
        for parama in paramas{
            if info[parama] == nil{
                return false
            }
        }
        return true
    }
    
    fileprivate final func getPodItemFromPodInfo(info:[String:String])->PodModel{
        let podDir:URL = URL.init(string: PodInfo["podPath"]!)!
        let podItem:PodModel = PodModel()
        podItem.name = PodInfo["podName"]!
        podItem.dictionary = podDir.appendingPathComponent(podItem.name!).absoluteString
        podItem.specsRepo = PodInfo["specsRepo"]
        podItem.isPrivate = isPrivatePod
        podItem.useLibraries = false
        podItem.allowWarnings = true
        podItem.verbose = false
        return podItem
    }

//MARK: ---- getter && setter
    
    //private
    
    /// 是否为私有POD
    fileprivate var isPrivatePod:Bool = true{
        didSet{
            if !isPrivatePod {
                specsRepoPopUp.setTitle("CocoaPods")
                PodInfo["specsRepo"] = "CocoaPods"
            }
            specsRepoPopUp.isEnabled = isPrivatePod
        }
    }
    
    /// Pod 相关信息
    fileprivate var PodInfo:[String:String] = [:]
    
    /// sepcs repo 数组
    fileprivate var sepcsRepos:[PodSpecs]{
        get{
            return PodSpecs.queryData(nil)
        }
    }
    
    var isCreate:Bool = true{
        didSet{
            self.title = isCreate ? "创建Pod" : "设置Pod"
        }
    }
    
    fileprivate var completionHandler:(_ item:PodModel,_ isCreate:Bool)->() = {_,_ in }
    fileprivate var completionHandlerForCrate:(_ newProject:project,_ item:PodModel,_ isCreate:Bool)->() = {_,_,_ in }
    //IB
    @IBOutlet weak var testTool1: NSButton!
    
    @IBOutlet weak var testTool2: NSButton!
    
    @IBOutlet weak var pathLabel: NSTextField!
    
    @IBOutlet weak var podNameLabel: NSTextField!
    
    @IBOutlet weak var specsRepoPopUp: NSPopUpButton!
    
}
