//
//  AddSpecWindow.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/27.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class AddSpecWindow: NSWindow ,PodProcessDelegate{
    static func window() -> AddSpecWindow {
        let window:AddSpecWindow = AddSpecWindow.loadWithNibName("AddSpecWindow", AddSpecWindow.classForCoder()) as! AddSpecWindow
        return window
    }
    
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        errorMessageLabel.isHidden = true
        loading = true
        process.runPodRepoAdd(name: nameField.stringValue, url: URLField.stringValue)
    }
    
//MARK: ---- Delegate
    func PodProcessDidOutPut(message: String) {
        
    }
    
    func PodProcessDidFinished() {
        PodSpecs.insertData(name: nameField.stringValue, repo: URLField.stringValue)
        self.close()
    }
    
    func PodProcessDidFailed(message: String) {
        errorMessageLabel.stringValue = message
        errorMessageLabel.isHidden = false
        loading = false
    }
    
    fileprivate lazy var process:PodProcess = {
        return PodProcess.initWith(delegate: self)
    }()
    
    var loading:Bool = false{
        didSet{
            confirmBtn.isHidden = loading
            loadingView.isHidden = !loading
            if loading {
                loadingView.startAnimation(nil)
            }else{
                loadingView.stopAnimation(nil)
            }
        }
    }
    
    @IBOutlet weak var loadingView: NSProgressIndicator!
    @IBOutlet weak var confirmBtn: NSButton!
    @IBOutlet weak var URLField: NSTextField!
    @IBOutlet weak var errorMessageLabel: NSTextField!
    @IBOutlet weak var nameField: NSTextField!
}
