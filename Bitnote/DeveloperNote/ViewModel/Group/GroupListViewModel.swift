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
        repository.fetchGroups { [weak self] groups in
            self?.groupListOb.accept(groups)
        }
    }
    
    
    func addNewGroup(_ title: String) {
        repository.addGroup(source: groupListOb.value, title: title) { [weak self] updatedGroups in
            if let groups = updatedGroups {
                self?.groupListOb.accept(groups)
            }
        }
    }
    
    
    func deleteGroup(at row: Int) {
        repository.deleteGroup(source: groupListOb.value, row: row) { [weak self] updatedGroups in
            if let groups = updatedGroups {
                self?.groupListOb.accept(groups)
            }
        }
    }
    
    
    func getGroup(by indexPath: IndexPath) -> Group? {
        return repository.getGroup(source: groupListOb.value, at: indexPath.row)
    }
    
    
    func editGroupTitle(_ selectedGroup: Group, title: String) {
        repository.editGroup(source: groupListOb.value, target: selectedGroup.id, editTitle: title) { [weak self] updatedGroups in
            if let groups = updatedGroups {
                self?.groupListOb.accept(groups)
            }
        }
    }
}
