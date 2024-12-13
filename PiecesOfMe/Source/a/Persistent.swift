//
//  Persistent.swift
//  PiecesOfMe
//
//  Created by 이현욱 on 11/27/24.
//

import Foundation
import CoreData

// Core Data 엔티티 모델 정의
// 폴더와 파일/문자열 값을 관리하기 위한 모델

typealias FolderData = (subFolder: [Folder], Preferences: [Preferences])

// Core Data 관리 클래스
class CoreDataManager {
    static let shared = CoreDataManager()
    
    // Core Data 스택 설정
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PiecesOfMe")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private init() { }
    //        context.automaticallyMergesChangesFromParent = true
    //
    //        context.name = "viewContext"
    //        /// - Tag: viewContextMergePolicy
    //        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    //        context.undoManager = nil
    //        context.shouldDeleteInaccessibleFaults = true
    //    }
    
    // 새로운 폴더 생성
    func createFolder(name: String, parentFolder: FolderEntity? = nil, completion: ((Bool) -> Void)?) {
        let context = persistentContainer.viewContext
        let folder = Folder(context: context)
        folder.name = name
        folder.id = UUID().uuidString
//        folder.parentFolderName = parentFolder?.name
        folder.date = Date()
        folder.subFolders = []
        folder.preferences = []
        
        do {
            try context.save()
            completion?(true)
        } catch {
            print("폴더 생성 실패: \(error)")
            context.rollback()
            //            fatalError("폴더 생성 실패")
            completion?(false)
        }
    }
    
    // 파일/문자열 값 생성
    func createFileItem(name: String, content: String, folder: Folder) -> Preferences {
        let context = persistentContainer.viewContext
        let fileItem = Preferences(context: context)
        fileItem.name = name
        fileItem.belongFolder = folder
        
        //        fileItem.content = content
        //        fileItem.createdAt = Date()
        //        fileItem.folder = folder
        
        do {
            try context.save()
            return fileItem
        } catch {
            print("파일 생성 실패: \(error)")
            context.rollback()
            fatalError("파일 생성 실패")
        }
    }
        
    // 내가 원하는 건 FolderEntity로 쓰는 거 왜? subFolder
    func fetchHome() throws -> FolderEntity {
        // FIXME: 일단 임시로 바로 복귀하는데, 처음이면 Hoem Folder 만들기 
        return FolderEntity(id: UUID().uuidString, name: "Home", date: Date(), parentFolderId: nil, subFolders: [], preferences: [])
        if UserDefaults.standard.bool(forKey: "isFirst") {
            return FolderEntity(id: UUID().uuidString, name: "Home", date: Date(), parentFolderId: nil, subFolders: [], preferences: [])
        } else {
            let context = persistentContainer.viewContext
            let folderName = "Home"
            
            let homeFolderRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
            homeFolderRequest.predicate = NSPredicate(format: "name == %@", folderName)
            
            let subfoldersRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
            subfoldersRequest.predicate = NSPredicate(format: "parentFolder == %@", folderName)
            
            let filesRequest: NSFetchRequest<Preferences> = Preferences.fetchRequest()
            filesRequest.predicate = NSPredicate(format: "belongFolder == %@", folderName)
            
            do {
                let homeFolder = try context.fetch(homeFolderRequest).first!
                let subFolders = try context.fetch(subfoldersRequest)
                let preferences = try context.fetch(filesRequest)
                
                return FolderEntity(from: homeFolder)
                
                
                //            return FolderEntity(name: folderName, date: folder.date, preferences: preferences.map { PreferenceEntity(from: $0) }, subFolders: subFolders.map { FolderEntity(from: $0) })
            } catch {
                print("아이템 검색 실패: \(error)")
                throw error
            }
        }
    }
    
//    func fetch(with folder: Folder) throws -> FolderEntity {
//        let context = persistentContainer.viewContext
//        let folderName = folder.name!
//        
//        let subfoldersRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
//        subfoldersRequest.predicate = NSPredicate(format: "parentFolder == %@", folderName)
//        
//        let filesRequest: NSFetchRequest<Preferences> = Preferences.fetchRequest()
//        filesRequest.predicate = NSPredicate(format: "belongFolder == %@", folderName)
//        
//        do {
//            let subFolders = try context.fetch(subfoldersRequest)
//            let preferences = try context.fetch(filesRequest)
//            
//            return FolderEntity2(name: folderName, date: folder.date!, preferences: preferences, subFolders: subFolders)
//        } catch {
//            print("아이템 검색 실패: \(error)")
//            throw error
//        }
//    }
    
//    func fetchItemsInFolder(folder: String) -> (subfolders: [Folder], files: [Preferences]) {
//
//    }
    
    
//     홈일때 parent nil, folder = Home인경우
//    그럴 때는 항상 자신의 하위에 있는 것들을 다 까지는 아니여도 그 폴더에 있는 건 가져와야함
//    그리고 걱정이 되는게 그 뷰를 누를때마다 즉 view did appear 될때마다 predict쳐서 가져와야 할거같은데
//
    
    // 폴더 삭제 (하위 폴더와 파일 포함)
    func deleteFolder(_ folder: Folder) {
        let context = persistentContainer.viewContext
        context.delete(folder)
        
        do {
            try context.save()
        } catch {
            print("폴더 삭제 실패: \(error)")
            context.rollback()
        }
    }
}

//extension NSManagedObjectContext {
//    // FolderEntity를 Folder로 변환
//    func createOrUpdateFolder(from entity: FolderEntity) -> Folder {
//        // 기존 Folder 찾기 또는 새로 생성
//        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@", entity.name)
//        fetchRequest.fetchLimit = 1
//        
//        do {
//            let existingFolders = try self.fetch(fetchRequest)
//            let folder: Folder
//            
//            if let existingFolder = existingFolders.first {
//                // 기존 폴더 업데이트
//                folder = existingFolder
//            } else {
//                // 새 폴더 생성
//                folder = Folder(context: self)
//            }
//            
//            // 폴더 속성 설정
//            folder.name = entity.name
//            folder.date = entity.date
//            //            entity.
//            
//            // 부모 폴더 설정 (필요한 경우)
//            if let parentFolderId = entity.parentFolder {
//                let parentFetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
//                parentFetchRequest.predicate = NSPredicate(format: "id == %@", parentFolderId as CVarArg)
//                parentFetchRequest.fetchLimit = 1
//                
//                let parentFolders = try self.fetch(parentFetchRequest)
//            }
//            
//            // 저장 및 반환
//            try self.save()
//            return folder
//            
//        } catch {
//            print("폴더 생성/업데이트 실패: \(error)")
//            // 에러 발생 시 롤백
//            self.rollback()
//            fatalError("폴더 처리 중 오류 발생")
//        }
//    }
//}
