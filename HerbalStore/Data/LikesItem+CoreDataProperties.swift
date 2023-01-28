//
//  LikesItem+CoreDataProperties.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/12.
//
//

import Foundation
import CoreData


extension LikesItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikesItem> {
        return NSFetchRequest<LikesItem>(entityName: "LikesItem")
    }

    @NSManaged public var id: String
    @NSManaged public var image: String
    @NSManaged public var likes: Bool
    @NSManaged public var name: String

}

extension LikesItem : Identifiable {

}
