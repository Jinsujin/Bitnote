import Foundation
import RxSwift
import RxRelay


final class GroupListViewModel {
    
    private let repository: Repository
    var groupListOb = BehaviorRelay<[Group]>(value: [])
    
    init(repository: Repository) {
        self.repository = repository
        getGroups()
    }
    
    func getGroups() {
        if case let .success(data) = repository.fetchGroups() {
            self.groupListOb.accept(data)
        }
    }
    
    func getGroup(by indexPath: IndexPath) -> Group? {
        let result = repository.pickGroup(in: groupListOb.value, at: indexPath.row)
        if case let .success(data) = result {
            return data
        }
        return nil
    }
    
    func addNewGroup(_ title: String) async {
        let result = await repository.addGroup(source: groupListOb.value, title: title)
        if case let .success(groups) = result {
            self.groupListOb.accept(groups)
        }
        // TODO: - Error handle
    }
    
    func editGroupTitle(_ selectedGroup: Group, title: String) async {
        let result = await repository.editGroup(source: groupListOb.value, target: selectedGroup.id, editTitle: title)
        if case let .success(updatedGroups) = result {
            groupListOb.accept(updatedGroups)
        }
        // TODO: - Error handle
    }
    
    func deleteGroup(at row: Int) async {
        let result = await repository.deleteGroup(source: groupListOb.value, row: row)
        if case let .success(updatedGroups) = result {
            self.groupListOb.accept(updatedGroups)
        }
        // TODO: - Error handle
    }
}
