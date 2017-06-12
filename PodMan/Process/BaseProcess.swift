//
//  BaseProcess.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/3.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

public protocol ProcessDelegate {
    func ProcessDidSuccessed(opration:PodManOperationType)
    
    func ProcessDidFailed(opration:PodManOperationType,message:String)
    
}

protocol baseProcess {
    var process:Process {get set}
    var delegate:ProcessDelegate? {get set}
    func handleResult(str:String)
}
extension baseProcess{
    
    func runShellWith(filePath:String,shellName:String,outPutView:NSTextView,arguments:[String] = []){
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
                    outPutView.scrollRangeToVisible(NSMakeRange(outPutView.string.characters.count, 0))
                    self.handleResult(str: outStr)
                }
            }
            output.waitForDataInBackgroundAndNotify()
        }
        self.process.waitUntilExit()
        self.process.launch()
    }
    
    func runShellWith(shellName:String,arguments:[String] = []){
        guard !process.isRunning else {
            return
        }
        let shellPath = Bundle.main.path(forResource: shellName, ofType: nil)
        process.launchPath = shellPath
        process.arguments = arguments
        let outputPipe:Pipe = Pipe.init()
        let output:FileHandle = outputPipe.fileHandleForReading
        process.standardOutput = outputPipe
        
        DispatchQueue.global().async {
            self.process.launch()
            
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
                            self.handleResult(str: outStr)
                        }
                    }
                }
                output.waitForDataInBackgroundAndNotify()
            }
            self.process.waitUntilExit()
        }
    }
    
    fileprivate func handleOutPutStr(str:String)->NSMutableAttributedString{
        let outPutStr:NSMutableAttributedString = NSMutableAttributedString.init(string: str)
        outPutStr.addAttributes([NSAttributedStringKey.font:NSFont.systemFont(ofSize: 14)], range: NSMakeRange(0, str.characters.count))
        let style:NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.lineSpacing = 8
        outPutStr.addAttributes([NSAttributedStringKey.paragraphStyle:style], range: NSMakeRange(0, str.characters.count))
        return outPutStr
    }
}
