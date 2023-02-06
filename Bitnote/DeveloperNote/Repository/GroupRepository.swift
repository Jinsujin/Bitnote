import Foundation


class GroupRepository: Repository {
    
    enum PersistableStorageError: Error {
        case outOfRange
        case invalidIndex
    }
    
    func pickGroup(in groups: [Group], at index: Int) -> Result<Group, Error> {
        guard let selectGroup = groups[safe: index] else {
            return .failure(PersistableStorageError.outOfRange)
        }
        
        do {
            let fetchReslt = try RealmManager.fetchObject(Group.self, id: selectGroup.id)
            return .success(fetchReslt)
        } catch {
            return .failure(error)
        }
    }

    func fetchGroups() -> Result<[Group], Error> {
        do {
            let fetchResults = try RealmManager.fetchObjects(Group.self)
            return .success(fetchResults)
        } catch {
            return .failure(error)
        }
    }
    
    func addGroup(source groups: [Group], title: String) async -> Result<[Group], Error> {
        let newGroup = Group(title: title)
        var sourceGroups = groups
        return await withCheckedContinuation { continuation in
            do {
                try RealmManager.write { transaction in
                    transaction.add(newGroup)
                }
                sourceGroups.append(newGroup)
                continuation.resume(returning: .success(sourceGroups))
            } catch {
                continuation.resume(returning: .failure(error))
            }
        }
    }
    
    func deleteGroup(source groups: [Group], row: Int) async -> Result<[Group] ,Error> {
        var sourceGroups = groups
        let deleteUID = sourceGroups[row].id
        do {
            let _ = try await RealmManager.deleteGroup(target: deleteUID)
            sourceGroups.remove(at: row)
            return .success(sourceGroups)
        } catch {
            return .failure(error)
        }
    }
    
    func editGroup(source groups: [Group], target id: UID, editTitle: String) async -> Result<[Group], Error> {
        var sourceGroups = groups
        
        do {
            let updatedGroup = try await RealmManager.editGroup(Group.self, targetID: id, title: editTitle)
            guard let index = sourceGroups.firstIndex(where: { $0.id == updatedGroup.id }) else {
                return .failure(PersistableStorageError.invalidIndex)
            }
            sourceGroups.remove(at: index)
            sourceGroups.insert(updatedGroup, at: index)
            return .success(sourceGroups)
        } catch {
            return .failure(error)
        }
    }
}
