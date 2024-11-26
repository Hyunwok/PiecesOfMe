//
//  Folder+CoreDataProperties.swift
//  
//
//  Created by 이현욱 on 11/26/24.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var parentFolder: NSObject?
    @NSManaged public var preferences: Set<Preferences>?
    @NSManaged public var subFolders: Set<Folder>?
    @NSManaged public var relationship: Folder?
    @NSManaged public var relationship1: History?

}
