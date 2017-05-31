//
//  SecureTextField.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/18.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class SecureTextField: NSSecureTextField {

    override func awakeFromNib() {
        focusRingType = .none
    }
}
