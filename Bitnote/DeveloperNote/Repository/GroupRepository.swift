import Foundation


class GroupRepository: Repository {

    private var groupDataList: [Group] = []
    
    func getGroup(at index: Int) -> Group? {
        return groupDataList[safe: index]
    }
    
    func fetchGroups(completion: @escaping ([Group]) -> Void) {
        do {
            let fetchResults = try RealmManager.fetchObjects(Group.self)
            self.groupDataList = fetchResults
            completion(fetchResults)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addGroup(title: String, completion: @escaping ([Group]?) -> Void) {
        let newGroup = Group(title: title)

        do {
            try RealmManager.write { transaction in
                transaction.add(newGroup)
            }
            groupDataList.append(newGroup)
            completion(groupDataList)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteGroup(row: Int, completion: @escaping ([Group]?) -> Void) {
        let deleteUID = groupDataList[row].id
        
        do {
            try RealmManager.deleteGroup(target: deleteUID, completion: {
                groupDataList.remove(at: row)
                completion(groupDataList)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
        
    func editGroup(target id: UID, editTitle: String, completion: @escaping ([Group]?) -> Void) {
        do {
            try RealmManager.editGroup(Group.self, targetID: id, title: editTitle, completion: { [weak self] updatedGroup in

                guard let index = self?.groupDataList.firstIndex(where: { $0.id == updatedGroup.id }) else {
                    completion(nil)
                    return
                }
                self?.groupDataList.remove(at: index)
                self?.groupDataList.insert(updatedGroup, at: index)
                completion(self?.groupDataList)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}
