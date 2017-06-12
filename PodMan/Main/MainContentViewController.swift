//
//  MainContentViewController.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/22.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa
import Kingfisher

class MainContentViewController: NSViewController ,NSSplitViewDelegate,NSTableViewDataSource,NSTableViewDelegate ,NSSearchFieldDelegate ,statusBarMenuDelegate ,NSUserNotificationCenterDelegate{
    
    

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
        projectListView.register(NSNib.init(nibNamed: NSNib.Name(rawValue: "ProjectRowView"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "project"))
        projectListView.selectionHighlightStyle = .regular
        searchField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(noti:)), name: NSWindow.willCloseNotification, object: nil)
        let appDelegate:AppDelegate = NSApplication.shared.delegate as! AppDelegate
        if let meun:StatusBarMenu = appDelegate.statusBarItem?.menu as? StatusBarMenu{
            meun.statusDelegate = self
        }
        NSUserNotificationCenter.default.delegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        projectListView.selectRowIndexes(IndexSet.init(integer: 0), byExtendingSelection: true)
    }
    
    @objc fileprivate final func windowWillClose(noti:Notification){
        if let session = currentModalSession{
            if noti.object is settingWindow || noti.object is CreateProjectPanel{
                NSApplication.shared.endModalSession(session)
            }
        }
    }
//MARK: ---- eventResponse
    
    @IBAction func podOprationBtnClicked(_ sender: NSButton) {
        var type:PodManOperationType?
        switch sender.tag {
        case 1:
            type = PodManOperationType.Init
        case 2:
            type = PodManOperationType.install
        case 3:
            type = PodManOperationType.update
        case 4:
            type = PodManOperationType.lint
        case 5:
            type = PodManOperationType.specLint
        case 6:
            type = PodManOperationType.release
        default:
            return
        }
        currentProjectView?.beginProcessWith(operationType: type!, outPutView: consoleView)
    }
    
    
    @IBAction func createBtnClicked(_ sender: Any) {
        let panel:CreateProjectPanel = CreateProjectPanel.panel { (project, item, isCreate) in
            self.createPanelDidCreatePod(tempProject: project, item: item)
        }
        currentModalSession = NSApplication.shared.beginModalSession(for: panel)
    }
    
    //添加项目
    @IBAction func addBtnClicked(_ sender: Any) {
        let panel:NSOpenPanel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["podspec","xcodeproj","xcworkspace"]
        panel.begin { [unowned self](res:NSApplication.ModalResponse) in
            if res == .OK,let url = panel.url{
                let newProject:project = self.getProjectInfoWith(url: url)
                
                switch newProject{
                case .app:
                    self.insertPodManProject(item: newProject)
                    self.selectLastProject()
                case  .pod(let name,let path, _, _):
                    let panel:CreateProjectPanel = CreateProjectPanel.panel(path: path, name: name, completionHandler: { (pod, isCreate) in
                        self.createPanelDidCreatePod(tempProject: newProject, item: pod)
                    })
                    self.currentModalSession = NSApplication.shared.beginModalSession(for: panel)
                case .unknow(let description):
                    let alert:NSAlert = NSAlert()
                    alert.messageText = description
                    alert.beginSheetModal(for: self.superWindow!, completionHandler: nil)
                }
            }
        }
    }
    @IBAction func subBtnClicked(_ sender: Any) {
        if let view:ProjectRowView = currentProjectView {
            deleteProject(filePath: view.projectLintPath!)
        }
    }
    
    @IBAction func settingBtnClicked(_ sender: Any) {
        let window:settingWindow = settingWindow.window()
        currentModalSession = NSApplication.shared.beginModalSession(for: window)
    }
    

    @IBAction func allowWarningsChaned(_ sender: NSButton) {
        let allow:Bool = sender.state == .on
        selectedPod?.allowWarnings = allow
        Pod.changeData(selectedPod!)
    }
    
    @IBAction func useLibrariesChanged(_ sender: NSButton) {
        let use:Bool = sender.state == .on
        selectedPod?.useLibraries = use
        Pod.changeData(selectedPod!)
    }
    
    @IBAction func verboseChanged(_ sender: NSButton) {
        let verbose:Bool = sender.state == .on
        selectedPod?.verbose = verbose
        Pod.changeData(selectedPod!)
    }
    @IBAction func tagBtnClicked(_ sender: Any) {
        let process:GitProcess = GitProcess()
        process.runGitTag(filePath: selectedPod!.dictionary!, podName: selectedPod!.name!, outPutView: consoleView)
    }
    
//MARK: ---- private Method
    
    fileprivate final func getProjectInfoWith(url:URL)->project{
        let manger:FileManager = FileManager.default
        let fileFullName:String = url.lastPathComponent
        let fileName:String = fileFullName.components(separatedBy: ".").first ?? ""
        if fileFullName.hasSuffix("podspec"){
            if !vaildProject(name: fileName, path: url) {
                return project.unknow(description: "\(fileName) 已经存在")
            }
            let version:String = manger.getVersionFromPodspec(url: url)
            return project.pod(name: fileName, path: url, version: version, lintPath: url.absoluteString)
        }else{
            if !vaildProject(name: fileName, path: url) {
                return project.unknow(description: "\(fileName) 已经存在")
            }
            return project.app(name: fileName, path: url, lintPath: url.absoluteString)
        }
    }
    
    fileprivate final func vaildProject(name:String,path:URL)->Bool{
            
        return PodManProject.queryData(path).count == 0
    }
    
    fileprivate final func deleteProject(filePath:String){
        PodManProject.deleteData(path: filePath)
        projectListViewReload()
    }
    
    fileprivate final func selectLastProject(){
        projectListView.selectRowIndexes(IndexSet.init(integer: projectList.count - 1), byExtendingSelection: true)
        projectListView.deselectRow(0)
    }
    
    fileprivate final func insertPodManProject(item:project){
        if case let project.app(name, path, _) = item{
            PodManProject.insertData(name: name, filePath: path, isPod: false)
        }
        if case let project.pod(name, path, _, _) = item{
            PodManProject.insertData(name: name, filePath: path, isPod: true)
        }
        projectListViewReload()
    }
    
    fileprivate final func projectListViewReload(){
        projectList = PodManProject.queryData(nil)
        projectListView.reloadData()
    }
    
    //MARK:创建、设置Pod之后的处理
    fileprivate final func createPanelDidCreatePod(tempProject:project,item: PodModel) {
        insertPodManProject(item: tempProject)
        Pod.insertData(item: item)
        projectListViewReload()
        selectLastProject()
    }
    
    /// 初始化操作按钮
    ///
    /// - Parameter isPodOperation: 是否是Pod相关操作还是PodFile相关操作
    fileprivate final func initOperationButtons(isPodOperation:Bool){
        allowWaringsBox.isEnabled = isPodOperation
        useLibrariesBox.isEnabled = isPodOperation
        initBtn.isEnabled = !isPodOperation
        installBtn.isEnabled = !isPodOperation
        updateBtn.isEnabled = !isPodOperation
        lintBtn.isEnabled = isPodOperation
        specLintBtn.isEnabled = isPodOperation
    }
    
    /// 初始化Pod操作相关选项按钮
    ///
    /// - Parameters:
    ///   - allowWarnings: 忽略警告
    ///   - useLibraries: 使用静态库
    ///   - verbose: 输出详细信息
    fileprivate final func initPodSettingButtons(allowWarnings:Bool,useLibraries:Bool,verbose:Bool){
        allowWaringsBox.state = allowWarnings ? .on : .off
        useLibrariesBox.state = useLibraries ? .on : .off
        verboseBox.state = verbose ? .on : .off
    }
    
    fileprivate final func updateStatusBarMenu(name:String,isPod:Bool){
        let appDelegate:AppDelegate = NSApplication.shared.delegate as! AppDelegate
        if let meun:StatusBarMenu = appDelegate.statusBarItem?.menu as? StatusBarMenu{
            meun.isPod = isPod
            meun.projectName = name
        }
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
        let view:ProjectRowView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "project"), owner: self) as! ProjectRowView
        view.type = currentProjects[row]
        return view
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if let view = projectListView.view(atColumn: 0, row: row, makeIfNecessary: true){
            currentProjectView = view as? ProjectRowView
            
            if !FileManager.default.exportFileExists(path: currentProjectView!.projectFilePath!) {
                let alert:NSAlert = NSAlert.init()
                alert.messageText = "项目不存在"
                alert.beginSheetModal(for: superWindow!, completionHandler: nil)
                deleteProject(filePath: currentProjectView!.projectLintPath!)
                return false
            }
        }
        return true
    }
    
    //MARK:searchField
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        projectListViewReload()
    }
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        projectListViewReload()
    }
    
    //MARK:statusBarMenuDelegate
    func statusBarItemClicked(type: PodManOperationType) {
        currentProjectView?.beginProcessWith(operationType: type, outPutView: consoleView)
    }
    
    //MARK:NSUserNotificationCenterDelegate
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        self.superWindow?.orderFront(nil)
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
    
    fileprivate var currentModalSession:NSApplication.ModalSession?
    
    fileprivate var currentProjectView:ProjectRowView?{
        didSet{
            var isPod:Bool = false
            switch (currentProjectView?.type)!{
            case .pod:
                isPod = true
//                initPodSettingButtons(allowWarnings: currentProjectView!.selectedPod!.allowWarnings, useLibraries: currentProjectView!.selectedPod!.useLibraries, verbose: currentProjectView!.selectedPod!.verbose)
            case .app:
                isPod = false
            default:
                break
            }
            projectVersionLabel.stringValue = currentProjectView!.projectVersion!
            projectNameLabel.stringValue = currentProjectView!.projectName!
            initOperationButtons(isPodOperation: isPod)
            updateStatusBarMenu(name: currentProjectView!.projectName!, isPod: isPod)
            
        }
    }
    
    fileprivate var selectedPod:Pod?{
        get{
            return currentProjectView?.selectedPod
        }
    }
    
    var iconURL:String?{
        didSet{
            if iconURL?.characters.count == 0 {
                iconView.image = NSImage(named: NSImage.Name.init("logo"))
            }else{
                iconView.kf.setImage(with: URL.init(string: iconURL!))
            }
        }
    }
    
    //Operation Buttons
    
    @IBOutlet weak var initBtn: NSButton!
    @IBOutlet weak var specLintBtn: NSButton!
    @IBOutlet weak var lintBtn: NSButton!
    @IBOutlet weak var updateBtn: NSButton!
    @IBOutlet weak var installBtn: NSButton!
    @IBOutlet weak var createBtn: NSButton!
  
    @IBOutlet weak var releaseBtn: NSButton!
    @IBOutlet weak var tagBtn: NSButton!
    @IBOutlet var consoleView: NSTextView!
    @IBOutlet weak var projectVersionLabel: NSTextField!
    @IBOutlet weak var projectNameLabel: NSTextField!
    @IBOutlet weak var projectListView: NSTableView!
    
    @IBOutlet weak var verboseBox: NSButton!
    @IBOutlet weak var useLibrariesBox: NSButton!
    @IBOutlet weak var allowWaringsBox: NSButton!
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
