//
//  ProjectModel.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/23.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Foundation
import CoreData

enum project {
    case pod(name:String,path:URL,version:String,lintPath:String)
    case app(name:String,path:URL,lintPath:String)
    case unknow(description:String)
}
