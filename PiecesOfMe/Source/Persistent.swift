//
//  Persistent.swift
//  PiecesOfMe
//
//  Created by 이현욱 on 11/27/24.
//

import CoreData

final class PersistenceController: DBAble {
    typealias Item = FolderEntity
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    var visitedFolders = Set<String>()
    
    private init() {
        
        
        container = NSPersistentContainer(name: "PiecesOfMe")
        do {
            try FileManager.default.removeItem(at: container.persistentStoreDescriptions.first!.url!)
        } catch {
            print("Failed to remove persistent store: \(error)")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        
        context.name = "viewContext"
        /// - Tag: viewContextMergePolicy
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
        context.shouldDeleteInaccessibleFaults = true
    }
    
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension PersistenceController {
    func create(item: Item, completion: ((Bool) -> Void)?) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Folder", in: context) else {
            return
        }
        
        FolderEntity.toFolder(folders: item, fodlses: context)
        
        
        
//        let managedObject = NSManagedObject(entity: entity, insertInto: context)
//        managedObject.setValue(UUID().uuidString, forKey: "id")
//        managedObject.setValue(item.date, forKey: "date")
//        managedObject.setValue(item.name, forKey: "name")
//        managedObject.addToSubfolders(item.subFolders)
//        managedObject.setValue(NSSet(array: item.preferences), forKey: "preferences")
//        managedObject.setValue(NSSet(array: item.subFolders), forKey: "subFolders")
        
        do {
            
            try context.save()
            completion?(true)
        } catch {
            completion?(false)
            fatalError("에러발생! \(error)")
        }
    }
    
    func delete(item: FolderEntity) {
        print("")
    }
    
    func update(item: FolderEntity) {
        print("")
    }
    
    func read(item: FolderEntity) {
        print("")
    }
    
    func fetch(type: FetchType = .normal) -> FolderEntity {
        let fetchRequest = NSFetchRequest<Folder>(entityName: "Folder")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        if type == .parent {
            saveFirst()
            let predicate = NSPredicate(format: "name == Home")
//            fetchRequest.predicate = predicate
        }
        
        do {
            let folders = try container.viewContext.fetch(fetchRequest)
        
            return FolderEntity.toModel(folder: folders.first, visited: &visitedFolders)
        } catch {
            fatalError("개씨바바바바!\(error)")
        }
    }
    
    enum FetchType {
        case parent
        case normal
    }
    
    private func saveFirst() {
        if UserDefaults.standard.bool(forKey: "isFirstLaunch") {
            UserDefaults.standard.set(false, forKey: "isFirstLaunch")
            create(item: FolderEntity(date: Date(), id: UUID().uuidString, name: "Home"), completion: nil)
        }
    }
}


protocol DBAble {
    associatedtype Item
    func create(item: Item, completion: ((Bool) -> Void)?)
    func delete(item: Item)
    func update(item: Item)
    func read(item: Item)
}


import Foundation
import CoreData

// Core Data 엔티티 모델 정의
// 폴더와 파일/문자열 값을 관리하기 위한 모델

// Core Data 관리 클래스
//class CoreDataManager {
//    static let shared = CoreDataManager()
//    
//    // Core Data 스택 설정
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "FolderStructureModel")
//        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        return container
//    }()
//    
//    // 새로운 폴더 생성
//    func createFolder(name: String, parentFolder: Folder? = nil) -> Folder {
//        let context = persistentContainer.viewContext
//        let folder = Folder(context: context)
//        folder.name = name
//        folder.createdAt = Date()
//        folder.parentFolder = parentFolder
//        
//        do {
//            try context.save()
//            return folder
//        } catch {
//            print("폴더 생성 실패: \(error)")
//            context.rollback()
//            fatalError("폴더 생성 실패")
//        }
//    }
//    
//    // 파일/문자열 값 생성
//    func createFileItem(name: String, content: String, folder: Folder) -> FileItem {
//        let context = persistentContainer.viewContext
//        let fileItem = FileItem(context: context)
//        fileItem.name = name
//        fileItem.content = content
//        fileItem.createdAt = Date()
//        fileItem.folder = folder
//        
//        do {
//            try context.save()
//            return fileItem
//        } catch {
//            print("파일 생성 실패: \(error)")
//            context.rollback()
//            fatalError("파일 생성 실패")
//        }
//    }
//    
//    // 특정 폴더의 하위 폴더 및 파일 검색
//    func fetchItemsInFolder(folder: Folder) -> (subfolders: [Folder], files: [FileItem]) {
//        let context = persistentContainer.viewContext
//        
//        let subfoldersRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
//        subfoldersRequest.predicate = NSPredicate(format: "parentFolder == %@", folder)
//        
//        let filesRequest: NSFetchRequest<FileItem> = FileItem.fetchRequest()
//        filesRequest.predicate = NSPredicate(format: "folder == %@", folder)
//        
//        do {
//            let subfolders = try context.fetch(subfoldersRequest)
//            let files = try context.fetch(filesRequest)
//            return (subfolders, files)
//        } catch {
//            print("아이템 검색 실패: \(error)")
//            return ([], [])
//        }
//    }
//    
//    // 폴더 삭제 (하위 폴더와 파일 포함)
//    func deleteFolder(_ folder: Folder) {
//        let context = persistentContainer.viewContext
//        context.delete(folder)
//        
//        do {
//            try context.save()
//        } catch {
//            print("폴더 삭제 실패: \(error)")
//            context.rollback()
//        }
//    }
//}

// 사용 예시
//func exampleUsage() {
//    let manager = CoreDataManager.shared
//    
//    // 최상위 폴더 생성
//    let rootFolder = manager.createFolder(name: "Root")
//    
//    // 하위 폴더 생성
//    let documentsFolder = manager.createFolder(name: "Documents", parentFolder: rootFolder)
//    let imagesFolder = manager.createFolder(name: "Images", parentFolder: rootFolder)
//    
//    // 파일/문자열 값 생성
//    let _ = manager.createFileItem(
//        name: "Report.txt",
//        content: "2024년 프로젝트 보고서",
//        folder: documentsFolder
//    )
//    
//    let _ = manager.createFileItem(
//        name: "Landscape.txt",
//        content: "산과 강의 풍경 설명",
//        folder: imagesFolder
//    )
//    
//    // 폴더 내용 검색
//    let (subfolders, files) = manager.fetchItemsInFolder(folder: rootFolder)
//    print("하위 폴더 개수: \(subfolders.count)")
//    print("파일 개수: \(files.count)")
//}
