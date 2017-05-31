//
//  CreateProjectPanel.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/22.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class CreateProjectPanel: NSPanel {

    static func panel() -> CreateProjectPanel {
        let panel:CreateProjectPanel = CreateProjectPanel.loadWithNibName("CreateProjectPanel", CreateProjectPanel.classForCoder()) as! CreateProjectPanel
        return panel
    }
    
    @IBAction func chooseBtnClicked(_ sender: Any) {
        
        let panel:NSOpenPanel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.begin { (res) in
            
        }
    }
    
}
