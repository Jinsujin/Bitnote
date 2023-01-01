//
//  PersistableProtocol.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/30.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import Foundation
import RealmSwift

public protocol Persistable {
    
    /// associatedtype: 타입을 동적으로 변하게 하기위해 사용
    /// ex) name: int    -> name: T
    associatedtype ManagedObject: RealmSwift.Object
    
    /// RealmObject -> Struct 변환
    init(managedObject: ManagedObject)
    
    /// Struct -> RealmObject
    func managedObject() -> ManagedObject
}
