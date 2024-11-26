//
//  Preferences+CoreDataProperties.swift
//  
//
//  Created by 이현욱 on 11/26/24.
//
//

import Foundation
import CoreData


extension Preferences {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Preferences> {
        return NSFetchRequest<Preferences>(entityName: "Preferences")
    }

    @NSManaged public var date: Date?
    @NSManaged public var descriptionThing: String?
    @NSManaged public var history: [History]?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var location_lat: Double
    @NSManaged public var location_lon: Double
    @NSManaged public var name: String?

}
