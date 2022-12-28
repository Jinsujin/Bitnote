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
    
    
    func getGroupByIndexPath(_ indexPath: IndexPath) -> Group {
        return repository.getGroup(by: indexPath)
    }
    
    
    func editGroupTitle(_ selectedGroup: Group, title: String) {
        repository.editGroupTitle(target: selectedGroup, title: title) { [weak self] updatedGroups in
            if let groups = updatedGroups {
                self?.groupListOb.accept(groups)
            }
        }
    }
}
