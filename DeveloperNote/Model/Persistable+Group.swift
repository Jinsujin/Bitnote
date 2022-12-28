import Foundation


extension Group: Persistable {
    /**
            RealmObject -> Struct
     */
    public init(managedObject: RealmGroup) {
        self.id = managedObject.uid
        self.title = managedObject.title
        self.notelist = managedObject.noteList.map({ Note(managedObject: $0) })
    }
    
    /**
            Struct -> RealmObject
     */
    public func managedObject() -> RealmGroup {
        let realm = RealmGroup()
        realm.uid = self.id
        realm.title = self.title

        if let notelist = self.notelist {
            realm.noteList.append(objectsIn: notelist.compactMap({ $0.managedObject() }))
        }

        return realm
    }
}
