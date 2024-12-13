//
//  TemporaryPreference.swift
//  PiecesOfMe
//
//  Created by 이현욱 on 11/27/24.
//

import Foundation
import CoreData

struct PreferenceEntity: Hashable {
    var id: String
    var name: String
    var date: Date
    var image: Data?
    var location_lat: Double?
    var location_lon: Double?
    var descriptionThing: String?
    var belongFolder: FolderEntity
    
    //    var history: [TemporaryHistory]?
    
    init(from entity: Preferences) {
        self.id = entity.id!
        self.name = entity.name!
        self.date = entity.date!
        self.image = entity.image
        self.location_lat = entity.location_lat
        self.location_lon = entity.location_lon
        self.descriptionThing = entity.descriptionThing
        self.belongFolder = FolderEntity(from: entity.belongFolder!)
    }
}

extension PreferenceEntity {
    func toPreference(in context: NSManagedObjectContext) -> Preferences {
        let fetchRequest: NSFetchRequest<Preferences> = Preferences.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", self.id as CVarArg)
        
        do {
            let entity = try context.fetch(fetchRequest).first!
            
            // 기존 엔티티가 있으면 업데이트
            entity.id = self.id
            entity.name = self.name
            entity.date = self.date
            entity.image = self.image
            //                existingEntity.location_lat = self.location_lat
            //                existingEntity.location_lon = self.location_lon
            entity.descriptionThing = self.descriptionThing
            entity.belongFolder = self.belongFolder.toFolder(in: context)
            
            // 부모 폴더 설정 (ID로 찾아서)
            let parentFetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
            parentFetchRequest.predicate = NSPredicate(format: "id == %@", self.belongFolder.id as CVarArg)
            let parentEntities = try context.fetch(parentFetchRequest)
            entity.belongFolder = parentEntities.first
            
            return entity
            
        } catch {
            // 에러 처리 (여기서는 기본 엔티티 생성)
            let newEntity = Preferences(context: context)
            newEntity.id = self.id
            newEntity.name = self.name
            newEntity.date = self.date
            
            return newEntity
        }
    }
}
