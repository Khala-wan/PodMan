//
//  SpecHelpViewController.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/3.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class SpecHelpViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.string = "      如果：你的Mac上配置了两个github的SSH，一个工作的一个个人的。那么当你配置了github SSH 映射之后，请在SSH URL里面填入你映射的git repo URL \n 如下：\n repo URL：git@github.com:xxx/xxx. \n  SSH URL:  git@github_Work:xxx/xxx.\n      当然，如果你没有配置多个SSH的话，就用原生的SSH repo URL即可。"
    }
    
    @IBOutlet var contentTextView: NSTextView!
}
