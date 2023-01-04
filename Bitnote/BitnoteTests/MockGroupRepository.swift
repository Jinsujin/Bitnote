import Foundation


class MockGroupRepository: Repository {

    // test property
    var getGroupMethodCallCount = 0
    var fetchGroupsMethodCallCount = 0
    var addGroupMethodCallCount = 0
    var deleteGroupMethodCallCount = 0
    var editGroupTitleMethodCallCount = 0
    
    var groupList: [Group] = []
    
    @discardableResult
    func createItems(count: Int) -> [Group] {
        return (0..<count).map{( Group(title: "Group\($0)") )}
    }
    
    /// test: fetchGroups 하기전에 반드시 호출하여 데이터설정
    func prepare(source groups: [Group]) {
        groupList = groups
    }
    
    func fetchGroups(completion: @escaping ([Group]) -> Void) {
        fetchGroupsMethodCallCount += 1
        completion(groupList)
    }
    
    func getGroup(source groups: [Group], at index: Int) -> Group? {
        getGroupMethodCallCount += 1
        return groups[safe: index]
    }
    
    func addGroup(source groups: [Group], title: String, completion: @escaping ([Group]?) -> Void) {
        let newGroup = Group(title: title)
        var sourceGroups = groups
        sourceGroups.append(newGroup)
        addGroupMethodCallCount += 1
        completion(sourceGroups)
    }
    
    func deleteGroup(source groups: [Group], row: Int, completion: @escaping ([Group]?) -> Void) {
        deleteGroupMethodCallCount += 1
        var sourceGroups = groups
        sourceGroups.remove(at: row)
        completion(sourceGroups)
    }
    
    func editGroup(source groups: [Group], target id: UID, editTitle: String, completion: @escaping ([Group]?) -> Void) {
        editGroupTitleMethodCallCount += 1
        var sourceGroups = groups
        
        guard let index = sourceGroups.firstIndex(where: { $0.id == id }) else {
            completion(nil)
            return
        }
        let originalGroup = sourceGroups[index]
        sourceGroups.remove(at: index)
        let updateGroup = Group(id: originalGroup.id, title: editTitle, notelist: originalGroup.notelist)
        sourceGroups.insert(updateGroup, at: index)
        completion(sourceGroups)
    }
}
