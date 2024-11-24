//
//  DBManager.swift
//  PiecesOfMe
//
//  Created by 이현욱 on 11/22/24.
//

import Foundation

protocol DBItemAble {
//    associatedtype Item
}

protocol DBAble {
    func create(item: DBItemAble)
    func delete(item: DBItemAble)
    func update(item: DBItemAble)
    func read(item: any DBItemAble)
}

final class DBManager {
    private let dbable: DBAble
    
    init(_ DBable: DBAble) {
        self.dbable = DBable
    }
    
    func create() {
//        dbable.create(item: CoreDataItem())
    }
    
}
