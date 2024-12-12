//
//  TemporaryPreference.swift
//  PiecesOfMe
//
//  Created by 이현욱 on 11/27/24.
//

import Foundation
import CoreData

struct PreferenceEntity: Hashable {
    var date: Date
    var descriptionThing: String?
//    var history: [TemporaryHistory]?
    var id: String
    var image: Data?
    var location_lat: Double?
    var location_lon: Double?
    var name: String
    
    static var defaultValue: PreferenceEntity {
        PreferenceEntity(
            date: .distantPast,
            descriptionThing: nil,
            id: UUID().uuidString,
            image: nil,
            location_lat: nil,
            name: "")
    }
    
    static func toModel(preference: Preferences?) -> PreferenceEntity {
        if let preference = preference {
            return PreferenceEntity(
                date: preference.date!,
                descriptionThing: preference.descriptionThing,
//                history: preference.history,
                id: preference.id!,
                image: preference.image,
                location_lat: preference.location_lat,
                name: preference.name!)
        }
        return PreferenceEntity.defaultValue
    }
}

struct TemporaryHistory: Hashable {
    var id: UUID
    var updateDate: Date?
    var updateLevel: Int16
}

struct FolderEntity: Hashable {
    var date: Date
    var id: String
    var name: String
    var preferences: [PreferenceEntity] = []
    var subFolders: [FolderEntity] = []
    
    
    static var emptyFolder: FolderEntity {
        //        TemporaryFolder(date: <#T##Date#>, id: <#T##String#>, name: <#T##String#>)
        return FolderEntity(date: Date(), id: UUID().uuidString, name: "Home")
    }
    
    static func toModel(folder: Folder?, visited: inout Set<String>) -> FolderEntity {
        print("계속 불림")
        if let folder = folder {
            // 이미 처리된 폴더인지 확인
            if visited.contains(folder.id!) {
                return FolderEntity.emptyFolder // 기본값 반환
            }

            // 현재 폴더 ID를 기록
            visited.insert(folder.id!)

            let tempPre = folder.preferences as? Set<Preferences> ?? []
            let tempSub = folder.subFolders as? Set<Folder> ?? []
            return FolderEntity(date: folder.date!,
                                id: folder.id!,
                                name: folder.name!,
                                preferences: tempPre.map { PreferenceEntity.toModel(preference: $0) },
                                subFolders: tempSub.map { FolderEntity.toModel(folder: $0, visited: &visited) })
        } else {
            return FolderEntity.emptyFolder
        }
    }
    
    @discardableResult
    static func toFolder(folders: FolderEntity, fodlses: NSManagedObjectContext) -> Folder {
        let entity = Folder(context: fodlses)
        entity.id = folders.id
        entity.name = folders.name
        entity.date = folders.date
        
        print(folders)
        folders.subFolders.forEach {  entity.addToSubFolders(FolderEntity.toFolder(folders: $0, fodlses: fodlses)) }
        
        return entity
        //        fodlses.preferences
    }
}
