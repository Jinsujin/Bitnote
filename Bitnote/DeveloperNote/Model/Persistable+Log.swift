import Foundation


extension Log: Persistable {
    /**
            RealmObject -> Struct
     */
    public init(managedObject: RealmLog) {
        self.uid = managedObject.uid
        self.ownerId = managedObject.ownerId
        self.createdAt = managedObject.createdAt
        self.understandLevel = .getLevelFromKeySting(key: managedObject.understandLevel)

    }
    
    /**
            Struct -> RealmObject
     */
    public func managedObject() -> RealmLog {
        let realm = RealmLog()
        realm.uid = self.uid
        realm.ownerId = self.ownerId
        realm.createdAt = self.createdAt
        realm.understandLevel = self.understandLevel.keyString
        return realm
    }
}
