import Foundation


class MockGroupRepository: Repository {
    enum MockRepositoryError: Error {
        case outOfRange
        case invalidIndex
    }

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
    
    func fetchGroups() -> Result<[Group], Error> {
        fetchGroupsMethodCallCount += 1
        return .success(groupList)
    }
    
    func pickGroup(in groups: [Group], at index: Int) -> Result<Group, Error> {
        getGroupMethodCallCount += 1
        guard let groups = groups[safe: index] else {
            return .failure(MockRepositoryError.outOfRange)
        }
        return .success(groups)
    }
    
    func addGroup(source groups: [Group], title: String) async -> Result<[Group], Error> {
        let newGroup = Group(title: title)
        var sourceGroups = groups
        sourceGroups.append(newGroup)
        addGroupMethodCallCount += 1
        return .success(sourceGroups)
    }
    
    func deleteGroup(source groups: [Group], row: Int) async -> Result<[Group] ,Error> {
        deleteGroupMethodCallCount += 1
        var sourceGroups = groups
        sourceGroups.remove(at: row)
        return .success(sourceGroups)
    }
    
    func editGroup(source groups: [Group], target id: UID, editTitle: String) async -> Result<[Group], Error> {
        editGroupTitleMethodCallCount += 1
        var sourceGroups = groups

        guard let index = sourceGroups.firstIndex(where: { $0.id == id }) else {
            return .failure(MockRepositoryError.invalidIndex)
        }
        let originalGroup = sourceGroups[index]
        sourceGroups.remove(at: index)
        let updateGroup = Group(id: originalGroup.id, title: editTitle, notelist: originalGroup.notelist)
        sourceGroups.insert(updateGroup, at: index)
        return .success(sourceGroups)
    }
}
