//
//  ProjectRowView.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/23.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class ProjectRowView: NSTableCellView ,ProcessDelegate{
    
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
    
//MARK: ---- private Method
    
    /// 执行相关操作
    ///
    /// - Parameters:
    ///   - opreationType: 操作类型
    ///   - outPutView: 输出View
    func beginProcessWith(operationType:PodManOperationType,outPutView:NSTextView){
        animation(true)
        op = operationType
        switch operationType{
            case .Init:
                PodProcess.initWith(operation: .install, delegate: self).runPodInit(filePath: projectLintPath!, outPutView: outPutView)
            case .install:
                PodProcess.initWith(operation: .Init, delegate: self).runPodInstall(filePath: self.projectLintPath!, outPutView: outPutView)
            case .update:
                PodProcess.initWith(operation: .update, delegate: self).runPodUpdate(filePath: self.projectLintPath!, outPutView: outPutView)
            case .lint:
                selectedPod!.lintWith(pDelegate: self, outPutView: outPutView)
            case .specLint:
                selectedPod!.specLintWith(pDelegate: self, outPutView: outPutView)
            case .release:
                selectedPod!.releaseWith(pDelegate: self, outPutView: outPutView)
            default:
                animation(false)
                return
        }
    }
    
    /// 加载动画
    ///
    /// - Parameter begin: 开始or结束
    fileprivate final func animation(_ begin:Bool){
        if begin{
            loadingView.startAnimation(nil)
        }else{
//            loadingView.stopAnimation(nil)
        }
        loadingView.isHidden = !begin
        versionLabel.isHidden = begin
    }
    
    fileprivate final func showNoti(successed:Bool){
        let noti:NSUserNotification = NSUserNotification()
        noti.title = selectedPod?.name!
        noti.informativeText = successed ? "\(String(describing: op))已完成!" : "\(String(describing: op))失败"
        noti.deliveryDate = Date.init(timeIntervalSinceNow: 0)
        NSUserNotificationCenter.default.scheduleNotification(noti)
    }
//MARK:Delegate
    func ProcessDidSuccessed(opration: PodManOperationType) {
        animation(false)
        showNoti(successed: true)
    }
    
    func ProcessDidFailed(opration: PodManOperationType, message: String) {
        animation(false)
        showNoti(successed: false)
    }
    
//MARK: ---- getter && setter
    
    /// Project类型
    var type:project?{
        didSet{
            if case let project.pod(name, path, version ,lpath) = type!{
                var versionStr = version
                if version == "*" {
                    versionStr = FileManager.default.getVersionFromPodspec(url: path)
                }
                projectVersion = versionStr
                projectName = name
                projectFilePath = path
                projectLintPath = lpath
                selectedPod = Pod.queryData(name)
            }
            if case let project.app(name, path, lpath) = type!{
                projectVersion = ""
                projectName = name
                projectFilePath = path
                projectLintPath = lpath
                selectedPod = nil
            }
        }
    }
    
    /// 项目名称
    var projectName:String?{
        didSet{
            nameLabel.stringValue = projectName ?? ""
        }
    }
    
    /// Pod项目的版本号
    var projectVersion:String?{
        didSet{
            versionLabel.stringValue = projectVersion ?? ""
        }
    }
    
    /// 项目文件地址
    var projectFilePath:URL?
    
    /// 项目目录地址（验证）
    var projectLintPath:String?
    
    /// 项目对应的Pod
    var selectedPod:Pod?
    
    fileprivate var op:PodManOperationType?
    
    @IBOutlet weak var versionLabel: NSTextField!
    
    @IBOutlet weak var loadingView: NSProgressIndicator!
    @IBOutlet weak var nameLabel: NSTextField!
}
