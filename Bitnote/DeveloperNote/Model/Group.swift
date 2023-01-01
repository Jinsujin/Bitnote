import Foundation

/// uniq id
typealias UID = String


struct Group {
    var id: UID = UUID().uuidString
    var title: String = ""
    var notelist: [Note]?
    
    init(){}
    
    /// 그룹생성화면에서 사용
    init(title: String, notelist: [Note]? = nil){
//        self.id = RealmManager.incrementId(Group.self)
        self.title = title
        self.notelist = notelist
    }
    
    init(id: UID, title: String, notelist: [Note]? = nil){
        self.id = id
        self.title = title
        self.notelist = notelist
    }
    
    /** 노트목록(notelist) 에서 공부할 노트만 필터해서, notelist 를 업데이트 한다
     
     - 노트 내용이 있는것
     - 노트 내용에서 북마크는 참고를 위한 필드이므로 거른다
     */
    mutating func setStudyNoteList() {
        guard let notelist = self.notelist else { return }
        let useShuffle = SettingConfigConcrete.sharedInstance().useShuffleNote
        
        var notDoneNotes = notelist.filter({ !$0.isDone })
        
        for i in 0..<notDoneNotes.count {
            let note = notDoneNotes[i]
            notDoneNotes[i].inputItems = note.inputItems.filter({ $0.keyString != "bookmark" })
        }
        var filtered_notelist = notDoneNotes.filter({ $0.inputItems.count > 0 })
        if (useShuffle) {
            filtered_notelist.shuffle()
        }
        
        self.notelist = filtered_notelist
    }
}
