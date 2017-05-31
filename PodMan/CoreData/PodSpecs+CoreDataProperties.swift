//
//  PodSpecs+CoreDataProperties.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/31.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Foundation
import CoreData


extension PodSpecs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PodSpecs> {
        return NSFetchRequest<PodSpecs>(entityName: "PodSpecs")
    }

    @NSManaged public var name: String?
    @NSManaged public var repoURL: String?

}
