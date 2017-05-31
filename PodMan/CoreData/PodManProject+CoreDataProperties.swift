//
//  PodManProject+CoreDataProperties.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/24.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Foundation
import CoreData


extension PodManProject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PodManProject> {
        return NSFetchRequest<PodManProject>(entityName: "PodManProject")
    }

    @NSManaged public var name: String?
    @NSManaged public var filePathData: NSData?
    @NSManaged public var isPod: Bool
    @NSManaged public var lintPath: String?

}
