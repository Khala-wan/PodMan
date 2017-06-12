//
//  GitProcess.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/3.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

struct GitProcess : baseProcess{
    func handleResult(str: String) {
    }
    
    
    var delegate:ProcessDelegate?
    
    var process: Process = Process()
    
    static func initWith(delegate:ProcessDelegate) -> GitProcess{
        var process:GitProcess = GitProcess()
        process.delegate = delegate
        return process
    }
    
    //MARK: ---- pod init
    func runGitTag(filePath:String,podName:String,outPutView:NSTextView){
        let podDir:URL = URL.init(string: filePath)!
        let podSpecPath:URL = podDir.appendingPathComponent(String.init(format: "%@.podspec", podName))
        let tagVersion:String = FileManager().getVersionFromPodspec(url: podSpecPath)
        runShellWith(filePath: filePath, shellName: "tagShell.sh", outPutView: outPutView, arguments: [tagVersion])
    }
    
    
}
