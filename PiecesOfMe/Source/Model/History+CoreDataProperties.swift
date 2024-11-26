//
//  History+CoreDataProperties.swift
//  
//
//  Created by 이현욱 on 11/26/24.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var updateDate: Date?
    @NSManaged public var updateLevel: Int16

}
