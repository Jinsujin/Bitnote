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
    
    private var groupDataList: [Group] = []
    
    public var groupListOb = BehaviorRelay<[Group]>(value: [])
    
    
    /**
     초기화

     */
    init(){
        fetchGroupFromDB()
    }
    
    func fetchGroupFromDB(){
        if let realm = RealmManager.realm() {
            let fetchObjects = realm.objects(RealmGroup.self)
            self.groupDataList = fetchObjects.compactMap({
                Group(managedObject: $0)
            })
        }
        groupListOb.accept(groupDataList)
    }
    
    /**
        새로운 그룹 추가
     
     */
    func addNewGroup(_ groupTitle: String) {
        let newGroup = Group(title: groupTitle)
        groupDataList.append(newGroup)
        groupListOb.accept(groupDataList)
        
        // DB 에 그룹 추가
        guard let realm = RealmManager.realm() else {
            return
        }
        try! realm.write {
            realm.add(newGroup.managedObject())
        }
    }
    
    
    func deleteGroup(_ row: Int) {
        let deleteUid = groupDataList[row].id
        groupDataList.remove(at: row)
        groupListOb.accept(groupDataList)
        
        // DB delete
        guard let realm = RealmManager.realm(),
        let fetchGroup = realm.object(ofType: RealmGroup.self, forPrimaryKey: deleteUid) else {
            return
        }
        
        let childObjects = fetchGroup.noteList
        try! realm.write {
            realm.delete(childObjects)
            realm.delete(fetchGroup)
        }
    }
    
    // indexPath 로 선택한 그룹 반환
    func getGroupByIndexPath(_ indexPath: IndexPath) -> Group {
        return self.groupDataList[indexPath.row]
    }
    
    /**
     group title 수정
     
     */
    func editGroup(_ selectedGroup: Group, editTitle: String) {
        let updated = Group(original: selectedGroup, uptatedTitle: editTitle)
        
        if let index = groupDataList.firstIndex(where: {
            $0.id == selectedGroup.id
        }) {
            groupDataList.remove(at: index)
            groupDataList.insert(updated, at: index)
        }
        
        groupListOb.accept(groupDataList)
        
        guard let realm = RealmManager.realm() else {
            return
        }
        
        try! realm.write {
            realm.create(RealmGroup.self, value: ["uid": updated.id, "title": editTitle], update: .modified)
        }
    }
    
}
