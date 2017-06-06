//
//  LoginWindowController.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/18.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class LoginWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.backgroundColor = NSColor.black;
        window?.titleVisibility = .hidden
        window?.titlebarAppearsTransparent = true
        _ = self.window?.contentView?.insertVibrancyViewBlendingMode(model: .behindWindow)
    }

}
