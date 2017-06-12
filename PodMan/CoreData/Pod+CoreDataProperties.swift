//
//  Pod+CoreDataProperties.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/2.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Foundation
import CoreData


extension Pod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pod> {
        return NSFetchRequest<Pod>(entityName: "Pod")
    }

    @NSManaged public var name: String?
    @NSManaged public var specsRepo: String?
    @NSManaged public var isPrivate: Bool
    @NSManaged public var useLibraries: Bool
    @NSManaged public var allowWarnings: Bool
    @NSManaged public var verbose: Bool
    @NSManaged public var dictionary: String?
}
