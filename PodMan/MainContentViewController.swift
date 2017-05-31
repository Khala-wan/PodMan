//
//  MainContentViewController.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/22.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class MainContentViewController: NSViewController ,NSSplitViewDelegate,NSTableViewDataSource,NSTableViewDelegate ,NSSearchFieldDelegate{

    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var subProjectBtn: NSButton!
    @IBOutlet weak var addProjectBtn: NSButton!
    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var splitView: NSSplitView!
   
    weak var superWindow:NSWindow?
//MARK: ---- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        splitView.delegate = self
        iconView.wantsLayer = true
        iconView.layer?.cornerRadius = 4
        projectListView.dataSource = self
        projectListView.delegate = self
        projectListView.register(NSNib.init(nibNamed: "ProjectRowView", bundle: nil), forIdentifier: "project")
        projectListView.selectionHighlightStyle = .regular
        searchField.delegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if projectList.count > 0 , let view = projectListView.view(atColumn: 0, row: 0, makeIfNecessary: false){
            let selectedView:ProjectRowView = view as! ProjectRowView
            selectedProject = selectedView.typeInfo
        }
    }
    
//MARK: ---- eventResponse

    @IBAction func createBtnClicked(_ sender: Any) {
//        let panel:CreateProjectPanel = CreateProjectPanel.panel()
//        if let window:NSWindow = superWindow{
//            window.beginSheet(panel, completionHandler: { (respones) in
//                
//            })
//        }
        let shellPath = Bundle.main.path(forResource: "shell", ofType: "sh")
        process.launchPath = shellPath
        process.arguments = [NSHomeDirectory() + "/Desktop/","hahaha","YES"]

        let outputPipe:Pipe = Pipe.init()
        let output:FileHandle = outputPipe.fileHandleForReading
        
        let inputPipe:Pipe = Pipe.init()
        let input:FileHandle = FileHandle.standardInput
        
        process.standardInput = inputPipe
        process.standardOutput = outputPipe
        
        process.launch()
        
        output.waitForDataInBackgroundAndNotify()
        inputPipe.fileHandleForWriting.write("Swift".data(using: .utf8)!)
        NotificationCenter.default.addObserver(forName: Notification.Name.NSFileHandleDataAvailable, object: output, queue: nil) { (noti) in
            let outData = output.readDataToEndOfFile()
            let outStr = String.init(data: outData, encoding: .utf8)
            output.waitForDataInBackgroundAndNotify()
        }
        process.waitUntilExit()
    }
    
    //添加项目
    @IBAction func addBtnClicked(_ sender: Any) {
        let panel:NSOpenPanel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.begin { [unowned self](res) in
            if res == 1,let url = panel.url{
                let type:project = self.getProjectInfoWith(url: url)

                switch type{
                case .app,.pod:
                    self.projectList.append(type)
                    self.projectListView.selectRowIndexes(IndexSet.init(integer: self.projectList.count - 1), byExtendingSelection: true)
                    self.selectedProject = type
                    self.projectListView.deselectRow(0)
                case .unknow(let description):
                    let alert:NSAlert = NSAlert()
                    alert.messageText = description
                    alert.beginSheetModal(for: self.superWindow!, completionHandler: nil)
                }
            }
        }
    }
    @IBAction func subBtnClicked(_ sender: Any) {
        let view:ProjectRowView = projectListView.view(atColumn: 0, row: projectListView.selectedRow, makeIfNecessary: false) as! ProjectRowView
        deleteProject(filePath: view.lintPath!)
    }
    let process:Process = Process()
    @IBAction func initBtnClicked(_ sender: Any) {
        
        PodProcess().runPodInit(filePath: selectedFilePath!.absoluteString, outPutView: consoleView)
        
    }
    
    @IBAction func installBtnClicked(_ sender: Any) {
    }
    @IBAction func updateBtnClicked(_ sender: Any) {
    }
    @IBAction func specLintBtnClicked(_ sender: Any) {
    }
    @IBAction func libLintBtnClicked(_ sender: Any) {
    }

    @IBAction func settingBtnClicked(_ sender: Any) {
        let window:settingWindow = settingWindow.window()
        NSApplication.shared().beginModalSession(for: window)
    }
//MARK: ---- private Method
    
    fileprivate final func getProjectInfoWith(url:URL)->project{
        let manger:FileManager = FileManager.default
        if let result = try? manger.findFileWith(url: url, suffix: "podspec"){
            if !vaildProject(name: result.0, path: result.1) {
                return project.unknow(description: "\(result.0) 已经存在")
            }
            PodManProject.insertData(name: result.0, filePath: result.1,isPod: true)
            let version:String = manger.getVersionFromPodspec(url: result.1)
            return project.pod(name: result.0, path: result.1, version: version, lintPath: result.1.absoluteString)
        }else{
            if let result = try? manger.findFileWith(url: url, suffix: "xcodeproj"){
                if !vaildProject(name: result.0, path: result.1) {
                    return project.unknow(description: "\(result.0) 已经存在")
                }
                PodManProject.insertData(name: result.0, filePath: result.1,isPod: false)
                return project.app(name: result.0, path: result.1, lintPath: result.1.absoluteString)
            }else{
                return project.unknow(description:"未找到podspec文件和工程文件")
            }
        }
    }
    
    fileprivate final func vaildProject(name:String,path:URL)->Bool{
            
        return PodManProject.queryData(path).count == 0
    }
    
    fileprivate final func deleteProject(filePath:String){
        PodManProject.deleteData(path: filePath)
        projectList = PodManProject.queryData(nil)
        projectListView.reloadData()
    }

//MARK: ---- Delegate
    //MARK:splitViewDelegate
    
    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 300
    }
    
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 150
    }
    
    //MARK:tableView
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return currentProjects.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view:ProjectRowView = tableView.make(withIdentifier: "project", owner: self) as! ProjectRowView
        view.type = currentProjects[row]
        return view
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if  let view = projectListView.view(atColumn: 0, row: row, makeIfNecessary: false){
            let selectedView:ProjectRowView = view as! ProjectRowView
            selectedProject = selectedView.typeInfo
            
            if !FileManager.default.exportFileExists(path: selectedView.filePath!) {
                let alert:NSAlert = NSAlert.init()
                alert.messageText = "项目不存在"
                alert.beginSheetModal(for: superWindow!, completionHandler: nil)
                deleteProject(filePath: selectedView.lintPath!)
                return false
            }
        }
        return true
    }
    
    //MARK:searchField
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        projectListView.reloadData()
    }
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        projectListView.reloadData()
    }
//MARK: ---- getter && setter
    fileprivate var projectList:[project] = {
        return PodManProject.queryData(nil)
    }(){
        didSet{
            projectListView.reloadData()
        }
    }
    
    var currentProjects:[project]{
        get{
            if searchField.stringValue.characters.count == 0 {
                return projectList
            }else{
                return projectList.filter({ (item) -> Bool in
                    if case let project.pod(name, _, _ ,_) = item{
                        return name.lowercased().contains(searchField.stringValue)                    }
                    if case let project.app(name, _ ,_) = item{
                        return name.lowercased().contains(searchField.stringValue)
                    }
                    return false
                })
            }
        }
    }
    
    fileprivate var selectedProject:project?{
        didSet{
            if case let project.pod(name, path, version, _) = selectedProject!{
                projectVersionLabel.stringValue = version
                projectNameLabel.stringValue = name
                selectedFilePath = path
                isPodOperation = true
            }
            if case let project.app(name, path, _) = selectedProject!{
                projectNameLabel.stringValue = name
                selectedFilePath = path
                isPodOperation = false
            }
        }
    }
    
    fileprivate var selectedFilePath:URL?
    
    fileprivate var isPodOperation:Bool?{
        didSet{
            initBtn.isEnabled = !isPodOperation!
            installBtn.isEnabled = !isPodOperation!
            updateBtn.isEnabled = !isPodOperation!
            lintBtn.isEnabled = isPodOperation!
            specLintBtn.isEnabled = isPodOperation!
        }
    }
    
    //Operation Buttons
    
    @IBOutlet weak var initBtn: NSButton!
    @IBOutlet weak var specLintBtn: NSButton!
    @IBOutlet weak var lintBtn: NSButton!
    @IBOutlet weak var updateBtn: NSButton!
    @IBOutlet weak var installBtn: NSButton!
    @IBOutlet weak var createBtn: NSButton!
  
    @IBOutlet var consoleView: NSTextView!
    @IBOutlet weak var projectVersionLabel: NSTextField!
    @IBOutlet weak var projectNameLabel: NSTextField!
    @IBOutlet weak var projectListView: NSTableView!
}
