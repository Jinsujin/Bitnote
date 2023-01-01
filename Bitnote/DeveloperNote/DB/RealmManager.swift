import Foundation
import RealmSwift


public final class WriteTransaction {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    public func add<T: Persistable>(_ value: T) {
        realm.add(value.managedObject())
    }
}

enum RealmErrorMessage: String, Error {
    case FailInitialize
    case NotFoundObject
}


public final class RealmManager {
    
    // realm 인스턴스 생성
    public static func realm() -> Realm? {
        do {
              return try Realm()
        } catch {
              print("🙅‍♂️DBinitialError", error.localizedDescription)
        }
        return nil
      }
    
    
    public static func connect(_ completion: @escaping (Bool) -> Void) {
            let success: Bool
            if configRealm() {
                success = true
            } else {
                success = false
            }
            
            completion(success)
        }
        
    
    public static let DBPath: URL? = {
        let appGroupID: String = "group.com.developerNote"
        
        guard let groupDir: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            return nil
        }
        
        let realmPath = groupDir.appendingPathComponent("db.realm")
        return realmPath
    }()

    
    /********************
  v2: RealmNote - isDone 추가
     ***********************/
    
    private static func configRealm() -> Bool {
        guard let realmPath = self.DBPath else {
            return false
        }
        
//        let config = Realm.Configuration(fileURL: realmPath)
        let config = Realm.Configuration(
            fileURL: realmPath,
            schemaVersion: 3,
            migrationBlock: { (migration, oldSchemaVersion) in
                
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: RealmNote.className()) { oldObject, newObject in
                        // review count property add
//                        newObject!["reviewcount"] = 0
                    }
                } else if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: RealmNote.className()) { oldObject, newObject in
                        newObject!["isDone"] = false
                    }
                } else if oldSchemaVersion < 3 {
                    // RealmLog 추가
                    // uid: Int -> uid: String 으로 변경
                    // RealmNote - reviewCount 제거, createdAt 필드 추가
                    migration.enumerateObjects(ofType: RealmNote.className()) { oldObject, newObject in
                        let oldValue =  oldObject!["uid"] as! Int
                        newObject!["uid"] = String(oldValue)
                    }
                    migration.enumerateObjects(ofType: RealmGroup.className()) { oldObject, newObject in
                        let oldValue =  oldObject!["uid"] as! Int
                        newObject!["uid"] = String(oldValue)
                    }
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
        print("DB path: \(realmPath)")
        return true
    }
    
      
    public func getUrl() -> URL? {
        let url = Realm.Configuration.defaultConfiguration.fileURL
        print("📂 Realm Database fileUrl:", url?.absoluteString ?? "Not Found")
        return url
    }
    
    static func incrementId<T: Persistable>(_ type: T.Type) -> Int {
        guard let realm = RealmManager.realm() else { return 0 }
        
        return (realm.objects(T.ManagedObject.self).max(ofProperty: "uid") as Int? ?? 0) + 1
    }
  
    /**
     * 사용:
     try! manager.write { transaction in
         transaction.add(Object)
     }
     */
    static func write(_ block: (WriteTransaction) throws -> Void) throws {
        guard let realm = RealmManager.realm() else {
            throw RealmErrorMessage.FailInitialize
        }
        
        let transaction = WriteTransaction(realm: realm)
        try realm.write {
            try block(transaction)
        }
    }
    
    static func fetchObject<T: Persistable>(_ persistable: T.Type, id: UID) throws -> T? {
        guard let realm = RealmManager.realm() else {
            throw RealmErrorMessage.FailInitialize
        }
        
        guard let fetchObject = realm.object(ofType: persistable.ManagedObject, forPrimaryKey: id) else {
            throw RealmErrorMessage.NotFoundObject
        }
        return T(managedObject: fetchObject)
    }
    
    static func fetchObjects<T: Persistable>(_ persistable: T.Type) throws -> [T] {
        guard let realm = RealmManager.realm() else {
            throw RealmErrorMessage.FailInitialize
        }
        
        let results = realm.objects(persistable.ManagedObject)
        return results.compactMap({ T(managedObject: $0) })
    }
    
    static func editGroup<T: Persistable>(_ persistable: T.Type, targetID: UID, title: String, completion: @escaping (T) -> Void) throws {
        guard let realm = RealmManager.realm() else {
            throw RealmErrorMessage.FailInitialize
        }

        try realm.write {
            let updateResult = realm.create(persistable.ManagedObject, value: ["uid": targetID, "title": title], update: .modified)
            completion(T(managedObject: updateResult))
        }
    }
    
    static func deleteGroup(target id: UID, completion: () -> Void) throws {
        guard let realm = RealmManager.realm() else {
            throw RealmErrorMessage.FailInitialize
        }
        
        guard let fetchObject = realm.object(ofType: RealmGroup.self, forPrimaryKey: id) else {
            throw RealmErrorMessage.NotFoundObject
        }
        
        try realm.write {
            let childObjects = fetchObject.noteList
            realm.delete(childObjects)
            realm.delete(fetchObject)
            completion()
        }
    }
}
