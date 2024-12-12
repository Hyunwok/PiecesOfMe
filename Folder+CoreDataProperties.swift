//
//  Folder+CoreDataProperties.swift
//  
//
//  Created by 이현욱 on 11/29/24.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var parentFolder: Folder?
    @NSManaged public var preferences: Set<Preferences>?
    @NSManaged public var subFolders: Set<Folder>?
    @NSManaged public var relationship: Folder?
    @NSManaged public var relationship1: History?

}

// MARK: Generated accessors for preferences
extension Folder {

    @objc(addPreferencesObject:)
    @NSManaged public func addToPreferences(_ value: Preferences)

    @objc(removePreferencesObject:)
    @NSManaged public func removeFromPreferences(_ value: Preferences)

    @objc(addPreferences:)
    @NSManaged public func addToPreferences(_ values: NSSet)

    @objc(removePreferences:)
    @NSManaged public func removeFromPreferences(_ values: NSSet)

}

// MARK: Generated accessors for subFolders
extension Folder {

    @objc(addSubFoldersObject:)
    @NSManaged public func addToSubFolders(_ value: Folder)

    @objc(removeSubFoldersObject:)
    @NSManaged public func removeFromSubFolders(_ value: Folder)

    @objc(addSubFolders:)
    @NSManaged public func addToSubFolders(_ values: NSSet)

    @objc(removeSubFolders:)
    @NSManaged public func removeFromSubFolders(_ values: NSSet)

}
