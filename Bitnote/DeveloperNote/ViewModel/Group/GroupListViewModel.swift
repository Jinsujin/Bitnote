//
//  GroupListViewModel.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/29.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay


class GroupListViewModel {
    
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
        repository.addGroup(title: title) { [weak self] updatedGroups in
            if let groups = updatedGroups {
                self?.groupListOb.accept(groups)
            }
        }
    }
    
    
    func deleteGroup(at row: Int) {
        repository.deleteGroup(row: row) { [weak self] updatedGroups in
            if let groups = updatedGroups {
                self?.groupListOb.accept(groups)
            }
        }
    }
    
    
    func getGroup(by indexPath: IndexPath) -> Group? {
        return repository.getGroup(at: indexPath.row)
    }
    
    
    func editGroupTitle(_ selectedGroup: Group, title: String) {
        repository.editGroup(target: selectedGroup.id, editTitle: title) { [weak self] updatedGroups in
            if let groups = updatedGroups {
                self?.groupListOb.accept(groups)
            }
        }
    }
}
