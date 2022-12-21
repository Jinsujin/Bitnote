//
//  NoteDetailViewModel.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/25.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

enum NoteDetailViewEditType {
    case new
    case edit
}


class NoteDetailViewModel {

    private var inputItems: [NoteInputType] = []
    private let selectedNote: Note?
    
    
    // Input
    let titleText = BehaviorRelay(value: "")
    
    // Output
    let isTitleValid = BehaviorSubject(value: false)
    
    lazy var initialTitleText: String? = {
        selectedNote?.title
    }()
    
    let editMode: NoteDetailViewEditType
    lazy var navigationTitle :String = {
        switch editMode {
        case .new:
            return "note_add_title".localized()
        case .edit:
            return "note_edit_title".localized()
        }
    }()

    // Subject: Observable + 외부에서 값 통제 가능
    var noteInputItemsOb = BehaviorRelay<[NoteInputType]>(value: [])
    
    
    /**
     초기화
     
     -selectedNote : nil이면 새로만들기, 값이 있으면 수정
     */
    init(_ selectedNote: Note? = nil) {
        self.selectedNote = selectedNote
        self.editMode = (selectedNote == nil) ? .new : .edit
        
        // 바인딩 Input -> Output:
        // subscribe 에서 들어오는 값이 변화가 될때마다 Output의 subject에 반영
        _ = titleText.distinctUntilChanged()
        .map(checkTitleValid)
        .bind(to: isTitleValid)
        
        if let note = selectedNote {
            inputItems = note.inputItems
            noteInputItemsOb.accept(inputItems)
        }
    }
    
    /**
     노트 저장
     
     TODO: Observable 반환?
     */
    func saveNote() -> Note {
        switch editMode {
        case .new:
            let note = Note(title: self.titleText.value, inputItems: noteInputItemsOb.value)
            return note
            
        case .edit:
            let note = Note(id: selectedNote!.id, title: self.titleText.value, isDone: selectedNote!.isDone, createdAt: selectedNote!.createdAt, inputItems: noteInputItemsOb.value)
            return note
        }
    }
    
    func appendInputItem(_ item: NoteInputType){
        inputItems.append(item)
        noteInputItemsOb.accept(inputItems)
    }
    
    func deleteInputItem(_ row: Int) {
        inputItems.remove(at: row)
        noteInputItemsOb.accept(inputItems)
    }
    
    func editInputTextItem(_ row: Int, editText: String) {
        inputItems.remove(at: row)
        inputItems.insert(NoteInputType.text(editText), at: row)
        noteInputItemsOb.accept(inputItems)
    }
    
    
    func getInputItemByIndexPath(_ indexPath: IndexPath) -> NoteInputType? {
        return inputItems.enumerated()
            .compactMap({ index, element in
                (index == indexPath.row) ? element : nil
            }).first
    }
    
    func moveInputItemRowAt(from: Int, to: Int){
        self.inputItems.swapAt(from, to)
        self.noteInputItemsOb.accept(inputItems)
    }
    
    private func checkTitleValid(_ title: String) -> Bool {
        return title != ""
    }
    
    
    //    func setTitleText(_ title: String) {
    //        let isValid = checkTitleValid(title)
    //        isTitleValid.onNext(isValid)
    //    }
        
}
