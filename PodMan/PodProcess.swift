//
//  PodProcess.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/25.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

public protocol PodProcessDelegate {
    func PodProcessDidOutPut(message:String)
    
    func PodProcessDidFinished()
    
    func PodProcessDidFailed(message:String)
}

struct PodProcess {
    
    var delegate:PodProcessDelegate?
    
    let process:Process = Process()
    
    var lastOutPut:String?
    
    static func initWith(delegate:PodProcessDelegate) -> PodProcess{
        var process:PodProcess = PodProcess()
        process.delegate = delegate
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
    func runPodLint(filePath:String,outPutView:NSTextView,allowWarning:Bool,useLibraries:Bool){
        runShellWith(filePath: filePath, shellName: "updateShell.sh", outPutView: outPutView, arguments: [allowWarning ? "YES" : "NO",useLibraries ? "YES" : "NO"])
    }
    
    //MARK: ---- pod sepc lint
    func runPodSpecLint(filePath:String,outPutView:NSTextView){
        runShellWith(filePath: filePath, shellName: "updateShell.sh", outPutView: outPutView)
    }
    
    
    //MARK: ---- pod repo add
    func runPodRepoAdd(name:String,url:String){
        runShellWith(shellName: "addShell.sh", arguments: [name,url])
    }
    
    
    fileprivate func runShellWith(filePath:String,shellName:String,outPutView:NSTextView,arguments:[String] = []){
        guard !process.isRunning else {
            return
        }
        outPutView.string = ""
        
        let shellPath = Bundle.main.path(forResource: shellName, ofType: nil)
        process.launchPath = shellPath
        let fileDict:String = filePath.replacingOccurrences(of: "file://", with: "")
        process.arguments = [fileDict] + arguments
        let outputPipe:Pipe = Pipe.init()
        let output:FileHandle = outputPipe.fileHandleForReading
        process.standardOutput = outputPipe
        
        process.launch()
        
        output.waitForDataInBackgroundAndNotify()
        NotificationCenter.default.addObserver(forName: Notification.Name.NSFileHandleDataAvailable, object: output, queue: nil) { (noti) in
            let outData = output.readDataToEndOfFile()
            if let outStr = String.init(data: outData, encoding: .utf8){
                guard outStr.characters.count != 0 else{
                    self.process.terminate()
                    return
                }
                DispatchQueue.main.async {
                    outPutView.textStorage?.append(self.handleOutPutStr(str: outStr))
                    outPutView.scrollRangeToVisible(NSMakeRange(outPutView.string!.characters.count, 0))
                }
            }
            output.waitForDataInBackgroundAndNotify()
        }
        process.waitUntilExit()
    }
    
    fileprivate func runShellWith(shellName:String,arguments:[String] = []){
        guard !process.isRunning else {
            return
        }
        let shellPath = Bundle.main.path(forResource: shellName, ofType: nil)
        process.launchPath = shellPath
        process.arguments = arguments
        let outputPipe:Pipe = Pipe.init()
        let output:FileHandle = outputPipe.fileHandleForReading
        process.standardOutput = outputPipe
        
        process.launch()
        
        output.waitForDataInBackgroundAndNotify()
        NotificationCenter.default.addObserver(forName: Notification.Name.NSFileHandleDataAvailable, object: output, queue: nil) { (noti) in
            let outData = output.readDataToEndOfFile()
            if let outStr = String.init(data: outData, encoding: .utf8){
                guard outStr.characters.count != 0 else{
                    self.process.terminate()
                    return
                }
                DispatchQueue.main.async {
                    if let myDelegate = self.delegate{
                        if outStr.contains("PodProcessSuccessed"){
                            myDelegate.PodProcessDidFinished()
                            
                        }
                        else if outStr.contains("PodProcessFailed"){
                            
                            var errorMessages:[String] = outStr.replacingOccurrences(of: "PodProcessFailed\n", with: "").components(separatedBy: "\n")
                            _ = errorMessages.popLast()
                            let errorMessage:String = errorMessages.last ?? ""
                            myDelegate.PodProcessDidFailed(message: errorMessage)
                        }else{
                            myDelegate.PodProcessDidOutPut(message: outStr)
                        }
                        self.process.terminate()
                    }
                }
            }
            output.waitForDataInBackgroundAndNotify()
        }
        process.waitUntilExit()
    }

    
    fileprivate func handleOutPutStr(str:String)->NSMutableAttributedString{
        let outPutStr:NSMutableAttributedString = NSMutableAttributedString.init(string: str)
        outPutStr.addAttributes([NSFontAttributeName:NSFont.systemFont(ofSize: 14)], range: NSMakeRange(0, str.characters.count))
        let style:NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.lineSpacing = 8
        outPutStr.addAttributes([NSParagraphStyleAttributeName:style], range: NSMakeRange(0, str.characters.count))
        return outPutStr
    }
    
}
