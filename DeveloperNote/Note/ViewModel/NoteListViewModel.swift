//
//  NoteListViewModel.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/29.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit
import RxSwift



class NoteListViewModel {
    // group list 에서 선택한 그룹
    private var selectedGroup: Group
    private var noteList: [Note] = []
    
    
    let groupTitle: String
    var noteListOb = BehaviorSubject<[Note]>(value: [])
    
    init(_ selectedGroup: Group = Group()){
        self.selectedGroup = selectedGroup
        self.groupTitle = selectedGroup.title
        self.noteList = selectedGroup.notelist ?? []
        
        noteListOb.onNext(noteList)
    }
    
    
    /**
     노트 삭제
     */
    func deleteNoteFromGroup(_ deleteNote: Note) {
        if let index = noteList.firstIndex(where: { $0.id == deleteNote.id }) {
            noteList.remove(at: index)
        }
        
        noteListOb.onNext(noteList)
        
        // DB delete
        guard let realm = RealmManager.realm() else {
           return
        }
        
        guard let deleteObj = realm.object(ofType: RealmNote.self, forPrimaryKey: deleteNote.id) else  {
            return
        }
        
        do{
            try realm.write {
                realm.delete(deleteObj)
            }
        }catch {
            print("delete error")
        }
    }
    
    
    
    
    
    func getNoteByIndexPath(_ indexPath: IndexPath) -> Note? {
        return noteList.enumerated()
            .compactMap({ index, element in
                (index == indexPath.row) ? element : nil
            }).first
    }
    

    func appendNewNote(_ note:Note) {
        self.noteList.append(note)
        self.noteListOb.onNext(noteList)
        
        // DB 작업
        // 1. realmModel 생성
        // 2. realm db write
        // 3. realm db - group list 에 생성한 moel append
        
        guard let realm = RealmManager.realm() else {
            return
        }
        
        let realmNoteModel = note.managedObject()
        
        try! realm.write {
            realm.add(realmNoteModel)
        }
        
        // 3.
        guard let group = realm.object(ofType: RealmGroup.self, forPrimaryKey: self.selectedGroup.managedObject().uid) else {
            return
        }
        
        try! realm.write {
            group.noteList.append(realmNoteModel)
        }
    
    }
    
    
    func editNote(_ note: Note) {
        if let index = noteList.firstIndex(where: { $0.id == note.id }) {
            noteList.remove(at: index)
            noteList.insert(note, at: index)
        }
        self.noteListOb.onNext(noteList)
        
        
        // DB
        guard let realm = RealmManager.realm() else {
            return
        }
        // DB 테이블-log 에 데이터는 존재하나, note.studyLogs는 지워져 있다
        if let fetchNote = realm.object(ofType: RealmNote.self, forPrimaryKey: note.id) {
            do {
                var editedNote = note
                editedNote.studyLogs = fetchNote.studyLogs.map({ Log(managedObject: $0) })
                
                try? realm.write {
                    realm.delete(fetchNote.inputItems)
                    realm.add(editedNote.managedObject(), update: .modified)
                }
            }
            
        }
    }
    
    // 공부 완료
    func doneStudyNote(_ note: Note) {
        // 현재 노트의 isDone 의 상태에
        guard let index = noteList.firstIndex(where: { $0.id == note.id }) else { return }
        var editedNote = noteList[index]
        editedNote.isDone = !editedNote.isDone
        
        noteList.remove(at: index)
        noteList.insert(editedNote, at: index)
        self.noteListOb.onNext(noteList)
        
        // DB
        guard let realm = RealmManager.realm() else { return }
        try! realm.write {
            realm.add(editedNote.managedObject(), update: .modified)
        }
    }
}
