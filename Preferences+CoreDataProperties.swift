//
//  Preferences+CoreDataProperties.swift
//  
//
//  Created by 이현욱 on 11/29/24.
//
//

import Foundation
import CoreData


extension Preferences {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Preferences> {
        return NSFetchRequest<Preferences>(entityName: "Preferences")
    }

    @NSManaged public var date: Date
    @NSManaged public var descriptionThing: String?
    @NSManaged public var id: UUID
    @NSManaged public var image: Data?
    @NSManaged public var location_lat: Double?
    @NSManaged public var location_lon: Double?
    @NSManaged public var name: String
    @NSManaged public var belongFolder: Folder?
    @NSManaged public var history: Set<History>?
}

// MARK: Generated accessors for history
extension Preferences {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: History)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: History)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}
