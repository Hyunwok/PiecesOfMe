//
//  FolderExtension.swift
//  PiecesOfMe
//
//  Created by 이현욱 on 12/12/24.
//

import Foundation
import CoreData

struct FolderEntity: Hashable {
    var date: Date
    var id: String
    var name: String
    var parentFolderId: String? = nil
    var subFolders: [FolderEntity] = []
    var preferences: [PreferenceEntity] = []
    
    init(from entity: Folder) {
        self.id = entity.id!
        self.name = entity.name!
        self.date = entity.date!
        self.parentFolderId = entity.parentFolderId
        self.subFolders = (entity.subFolders?.allObjects as? [Folder] ?? [])
            .map { FolderEntity(from: $0) }
    }
    
    init(id: String, name: String, date: Date, parentFolderId: String? = nil, subFolders: [FolderEntity] = [], preferences: [PreferenceEntity] = []) {
        self.id = id
        self.name = name
        self.date = date
        self.parentFolderId = parentFolderId
        self.subFolders = subFolders
        self.preferences = preferences
    }
    
    static var emptyFolder: FolderEntity {
        return FolderEntity(id: UUID().uuidString, name: "Home", date: Date())
    }
}

extension FolderEntity {
    // Folder 구조체에서 FolderEntity로 변환하는 메서드
    func toFolder(in context: NSManagedObjectContext) -> Folder {
        // 기존에 같은 ID를 가진 엔티티가 있는지 먼저 확인
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", self.id as CVarArg)
        
        do {
            let existingEntities = try context.fetch(fetchRequest)
            
            // 기존 엔티티가 있으면 업데이트
            if let existingEntity = existingEntities.first {
                existingEntity.name = self.name
                existingEntity.date = self.date
                
                // 부모 폴더 설정 (ID로 찾아서)
                if let parentId = self.parentFolderId {
                    let parentFetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
                    parentFetchRequest.predicate = NSPredicate(format: "id == %@", parentId as CVarArg)
                    let parentEntities = try context.fetch(parentFetchRequest)
                    existingEntity.parentFolderId = parentEntities.first?.id
                }
                
                // 하위 폴더들 업데이트
                let subFolderEntities = subFolders.map { $0.toFolder(in: context) }
                existingEntity.subFolders = NSSet(array: subFolderEntities)
                return existingEntity
            }
            
            // 기존 엔티티가 없으면 새로 생성
            let newEntity = Folder(context: context)
            newEntity.id = self.id
            newEntity.name = self.name
            newEntity.date = self.date
            
            // 부모 폴더 설정 (ID로 찾아서)
            if let parentId = self.parentFolderId {
                let parentFetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
                parentFetchRequest.predicate = NSPredicate(format: "id == %@", parentId as CVarArg)
                let parentEntities = try context.fetch(parentFetchRequest)
                newEntity.parentFolderId = parentEntities.first?.parentFolderId
            }
            
            // 하위 폴더들 변환
            let subFolderEntities = self.subFolders.map { $0.toFolder(in: context) }
            newEntity.subFolders = NSSet(array: subFolderEntities)
            
            return newEntity
            
        } catch {
            // 에러 처리 (여기서는 기본 엔티티 생성)
            let newEntity = Folder(context: context)
            newEntity.id = self.id
            newEntity.name = self.name
            newEntity.date = self.date
            
            return newEntity
        }
    }
}
