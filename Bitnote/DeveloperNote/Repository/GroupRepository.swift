import Foundation


class GroupRepository: Repository {
    
    func getGroup(source groups: [Group], at index: Int) -> Group? {
        if let selectGroup = groups[safe: index] {
            do {
                let fetchReslt = try RealmManager.fetchObject(Group.self, id: selectGroup.id)
                return fetchReslt
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func fetchGroups(completion: @escaping ([Group]) -> Void) {
        do {
            let fetchResults = try RealmManager.fetchObjects(Group.self)
            completion(fetchResults)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addGroup(source groups: [Group], title: String, completion: @escaping ([Group]?) -> Void) {
        let newGroup = Group(title: title)
        var sourceGroups = groups

        do {
            try RealmManager.write { transaction in
                transaction.add(newGroup)
            }
            sourceGroups.append(newGroup)
            completion(sourceGroups)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteGroup(source groups: [Group], row: Int, completion: @escaping ([Group]?) -> Void) {
        var sourceGroups = groups
        let deleteUID = sourceGroups[row].id
        
        do {
            try RealmManager.deleteGroup(target: deleteUID, completion: {
                sourceGroups.remove(at: row)
                completion(sourceGroups)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
        
    func editGroup(source groups: [Group], target id: UID, editTitle: String, completion: @escaping ([Group]?) -> Void) {
        var sourceGroups = groups
        do {
            try RealmManager.editGroup(Group.self, targetID: id, title: editTitle, completion: { updatedGroup in

                guard let index = sourceGroups.firstIndex(where: { $0.id == updatedGroup.id }) else {
                    completion(nil)
                    return
                }
                sourceGroups.remove(at: index)
                sourceGroups.insert(updatedGroup, at: index)
                completion(sourceGroups)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}
