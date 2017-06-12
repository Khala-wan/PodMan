//
//  PodProcess.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/25.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

struct PodProcess : baseProcess{
    
    var process: Process = Process()
    
    var delegate:ProcessDelegate?
    var operation:PodManOperationType?
    
    static func initWith(operation:PodManOperationType ,delegate:ProcessDelegate) -> PodProcess{
        var process:PodProcess = PodProcess()
        process.delegate = delegate
        process.operation = operation
        return process
    }
    
    //MARK: ---- pod init
    func runPodInit(filePath:String,outPutView:NSTextView){
        runShellWith(filePath: filePath, shellName: "initShell.sh", outPutView: outPutView)
    }
    
    //MARK: ---- pod install
    func runPodInstall(filePath:String,outPutView:NSTextView){
        runShellWith(filePath: filePath, shellName: "installShell.sh", outPutView: outPutView)
    }

    //MARK: ---- pod Update
    func runPodUpdate(filePath:String,outPutView:NSTextView){
        runShellWith(filePath: filePath, shellName: "updateShell.sh", outPutView: outPutView)
    }
    
    //MARK: ---- pod lint
    func runPodLint(filePath:String,outPutView:NSTextView,allowWarning:Bool,useLibraries:Bool,verbose:Bool){
        runShellWith(filePath: filePath, shellName: "lintShell.sh", outPutView: outPutView, arguments: [getPrivateSources(),allowWarning ? "--allow-warnings" : "",useLibraries ? "--use-libraries" : "",verbose ? "--verbose" : ""])
    }
    
    //MARK: ---- pod sepc lint
    func runPodSpecLint(filePath:String,outPutView:NSTextView,allowWarning:Bool,useLibraries:Bool,verbose:Bool){
        runShellWith(filePath: filePath, shellName: "specLintShell.sh", outPutView: outPutView, arguments: [getPrivateSources(),allowWarning ? "--allow-warnings" : "",useLibraries ? "--use-libraries" : "",verbose ? "--verbose" : ""])
    }
    
    
    //MARK: ---- pod repo add
    func runPodRepoAdd(name:String,url:String){
        runShellWith(shellName: "addShell.sh", arguments: [name,url])
    }
    
    //MARK: ---- pod repo remove
    func runPodRepoRemove(name:String){
        runShellWith(shellName: "removeShell.sh", arguments: [name])
    }
    
    //MARK: ---- pod lib create
    func runPodCreate(podInfo:[String:String]){
        runShellWith(shellName: "createShell.sh", arguments: [podInfo["podPath"]!,podInfo["podName"]!,podInfo["lan"]!,podInfo["demoAPP"]!,podInfo["testTool"]!,podInfo["viewTest"]!])
    }
    
    //MARK: ---- pod release
    func runPodRelease(filePath:String,isPrivatePod:Bool,specsRepo:String?,allowWarning:Bool,useLibraries:Bool,outPutView:NSTextView){
        runShellWith(filePath: filePath, shellName: "releaseShell.sh", outPutView: outPutView, arguments: [isPrivatePod ? "YES" : "NO",specsRepo ?? "",allowWarning ? "--allow-warnings" : "",useLibraries ? "--use-libraries" : ""])
    }
    
    fileprivate func getPrivateSources()->String{
        var Sources:[String] = ["https://github.com/CocoaPods/Specs.git"]
        let repos:[String] = PodSpecs.queryData(nil).map { (item) -> String in
            return item.httpsURL ?? ""
        }
        Sources = repos + Sources
        
        return Sources.joined(separator: ",")
    }
    
    func handleResult(str:String){
        if str.contains("PodProcessSuccessed") {
            delegate?.ProcessDidSuccessed(opration: operation!)
        }
        else if str.contains("PodProcessFailed"){
            
            var errorMessages:[String] = str.replacingOccurrences(of: "PodProcessFailed\n", with: "").components(separatedBy: "\n")
            _ = errorMessages.popLast()
            let errorMessage:String = errorMessages.last ?? ""
            delegate?.ProcessDidFailed(opration: operation!, message: errorMessage)
        }
    }
    
}
