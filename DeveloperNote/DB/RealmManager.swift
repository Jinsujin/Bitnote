import Foundation
import RealmSwift

/**
 Realm 초기화
 
 */

/// uniq id
typealias UID = String


public class RealmManager {
    
    // realm 인스턴스 생성
    public static func realm() -> Realm? {
        do {
              return try Realm()
        } catch {
              print("🙅‍♂️DBinitialError", error.localizedDescription)
        }
        return nil
      }
    
    
    public static func connect(_ completion: @escaping (Bool)->()) {
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
        print("Realm Database fileUrl:", url?.absoluteString)
        return url
    }
    
    static func incrementId<T: Persistable>(_ type: T.Type) -> Int {
        guard let realm = RealmManager.realm() else { return 0 }
        
        return (realm.objects(T.ManagedObject.self).max(ofProperty: "uid") as Int? ?? 0) + 1
    }
  
}

 
