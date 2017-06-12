//
//  Pod+PodProcess.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/12.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

extension Pod{
    
    
    func specLintWith(pDelegate:ProcessDelegate,outPutView:NSTextView){
        PodProcess.initWith(operation: .specLint, delegate: pDelegate).runPodSpecLint(filePath: self.dictionary!, outPutView: outPutView, allowWarning: self.allowWarnings, useLibraries: self.useLibraries, verbose: self.verbose)
    }
    
    func lintWith(pDelegate:ProcessDelegate,outPutView:NSTextView){
        PodProcess.initWith(operation: .lint, delegate: pDelegate).runPodLint(filePath: self.dictionary!, outPutView: outPutView, allowWarning: self.allowWarnings, useLibraries: self.useLibraries, verbose: self.verbose)
    }
    
    func releaseWith(pDelegate:ProcessDelegate,outPutView:NSTextView){
        PodProcess.initWith(operation: .release, delegate: pDelegate).runPodRelease(filePath: self.dictionary!, isPrivatePod: self.isPrivate, specsRepo: self.specsRepo!, allowWarning: self.allowWarnings, useLibraries: self.useLibraries, outPutView: outPutView)
    }
    
    
}
