import Foundation


class GroupRepository: Repository {

    private var groupDataList: [Group] = []
    
    func getGroup(at index: Int) -> Group? {
        return groupDataList[safe: index]
    }
    
    func fetchGroups(completion: @escaping ([Group]) -> Void) {
        if let realm = RealmManager.realm() {
            let fetchObjects = realm.objects(RealmGroup.self)
            self.groupDataList = fetchObjects.compactMap({
                Group(managedObject: $0)
            })
            completion(groupDataList)
        }
    }
    
    func addGroup(title: String, completion: @escaping ([Group]?) -> Void) {
        let newGroup = Group(title: title)
        
        guard let realm = RealmManager.realm() else {
            completion(nil)
            return
        }
        try! realm.write {
            realm.add(newGroup.managedObject())
            groupDataList.append(newGroup)
            completion(groupDataList)
        }
    }
    
    func deleteGroup(row: Int, completion: @escaping ([Group]?) -> Void) {
        let deleteUid = groupDataList[row].id
        
        guard let realm = RealmManager.realm(),
        let fetchGroup = realm.object(ofType: RealmGroup.self, forPrimaryKey: deleteUid) else {
            completion(nil)
            return
        }
        
        let childObjects = fetchGroup.noteList
        try! realm.write {
            realm.delete(childObjects)
            realm.delete(fetchGroup)
            
            groupDataList.remove(at: row)
            completion(groupDataList)
        }
    }

    func editGroupTitle(target group: Group, title: String, completion: @escaping ([Group]?) -> Void) {
        let updateGroup = Group(original: group, uptatedTitle: title)
        
        guard let realm = RealmManager.realm() else {
            completion(nil)
            return
        }
        
        try! realm.write {
            guard let index = groupDataList.firstIndex(where: { $0.id == group.id }) else {
                completion(nil)
                return
            }
            realm.create(RealmGroup.self, value: ["uid": updateGroup.id, "title": title], update: .modified)
            groupDataList.remove(at: index)
            groupDataList.insert(updateGroup, at: index)
            completion(groupDataList)
        }
    }
}
