//
//  AddSpecWindow.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/27.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class AddSpecWindow: NSWindow ,ProcessDelegate{
    static func window() -> AddSpecWindow {
        let window:AddSpecWindow = AddSpecWindow.loadWithNibName("AddSpecWindow", AddSpecWindow.classForCoder()) as! AddSpecWindow
        return window
    }
    
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        if sshURLField.stringValue.characters.count == 0 || nameField.stringValue.characters.count == 0 || httpsURLField.stringValue.characters.count == 0{
            errorMessageLabel.stringValue = "信息不全"
            return
        }
        errorMessageLabel.stringValue = ""
        loading = true
        process.runPodRepoAdd(name: nameField.stringValue, url: sshURLField.stringValue)
    }
    
    @IBAction func helpBtnClicked(_ sender: NSButton) {
        helpView.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxY)
    }
    
//MARK: ---- Delegate
    func ProcessDidOutPut(message: String) {
        
    }
    
    func ProcessDidFinished() {
        PodSpecs.insertData(name: nameField.stringValue, https: httpsURLField.stringValue, ssh: sshURLField.stringValue)
        self.close()
    }
    
    func ProcessDidFailed(message: String) {
        errorMessageLabel.stringValue = message
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
    
    fileprivate lazy var helpView:NSPopover = {
        let pop:NSPopover = NSPopover()
        pop.behavior = .semitransient
        pop.contentViewController = SpecHelpViewController()
        pop.animates = true
        return pop
    }()
    
    @IBOutlet weak var loadingView: NSProgressIndicator!
    @IBOutlet weak var confirmBtn: NSButton!
    
    @IBOutlet weak var sshURLField: NSTextField!
   
    @IBOutlet weak var httpsURLField: NSTextField!
    @IBOutlet weak var errorMessageLabel: NSTextField!
    @IBOutlet weak var nameField: NSTextField!
}
