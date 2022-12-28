import Foundation

class StudyFinishViewModel {
    
    /// 복습일때는 group 정보 없음
    private var group: Group?
    private var noteList: [Note] = []
    private var understandNotes: [UID: UnderstandLevel] = [:]

    init() { }
    
    func setData(_ noteList: [Note], understandNotes : [UID: UnderstandLevel]) {
        self.noteList = noteList
        self.understandNotes = understandNotes
    }
    

    /**
     버튼 누르지 않은 노트는 .high로 간주하여 로그 생성
     
     - 1. groupData 를 돌면서, understandNotes 에 없는 노트를 찾는다
     - 2. 없는 노트는 레벨을 .hight로 하여 새로운 배열에 추가
     */
    private func updateDefaultValueUnderstandNotes() -> [UID: UnderstandLevel] {
        var updated_understandNotes = self.understandNotes
        var notCheckUIDs: [UID] = []
        
        noteList.forEach {
            if (understandNotes[$0.id] == nil) {
                notCheckUIDs.append($0.id)
            }
        }
        
        notCheckUIDs.forEach {
            updated_understandNotes[$0] = .high
        }
        
        return updated_understandNotes
    }
    
    
    /// 못맞춘 문제의 갯수 문자열 반환
    func getResultLocalizedText() -> String {
        let updated_understandNotes = updateDefaultValueUnderstandNotes()
        
        let totalCount: Int = noteList.count
        
        let lowLevelCount: Int = updated_understandNotes.filter({ $0.value == .low }).count
        let solvedCount = totalCount - lowLevelCount

        let str = NSLocalizedString("lesson_finish_correct_score_%d %d", comment: "score")
        let localizeStr: String
        let langType = LanguageCodeType.getCode(Locale.current.languageCode)

        switch langType {
        case .korea:
            localizeStr = String(format: str, totalCount,solvedCount)
        default:
            localizeStr = String(format: str, solvedCount, totalCount)
        }
        
        return localizeStr
    }
    
    
    func getLowLevelTitlesText() -> String {
        let updated_understandNotes = updateDefaultValueUnderstandNotes()
        var result: [String] = []
        
        for n in updated_understandNotes {
            if (n.value == .middle || n.value == .high) {
                continue
            }
            let title = noteList.filter({ $0.id == n.key }).compactMap({ $0.title })
            if let t = title.first { result.append(t) }
        }
        
        return result.joined(separator: ", ")
    }
    
    
    func updateDB(completion: ((Bool) -> Void)? = nil) throws {
        let updated_understandNotes = updateDefaultValueUnderstandNotes()
        let date = Date()
        
        // 1. 로그 생성 -> 로그 테이블에 새로운 데이터 넣기
        // 2. Note 테이블의 마지막업데이트된 로그 필드에, 생성된 로그의 UID 를 넣어서 업뎃
        
        // 업데이트할 노트리스트에서
        let logs: [Log] = updated_understandNotes.map { understandNote in
            Log(ownerId: understandNote.key,
                understandLevel: understandNote.value,
                createdAt: date)
        }
        
        
       // DB
        guard let realm = RealmManager.realm() else {
            completion?(false)
            return
        }
        
        do {
            try realm.write {
                for log in logs {
                    let fetchNote = realm.object(ofType: RealmNote.self, forPrimaryKey: log.ownerId)
                    fetchNote?.studyLogs.append(log.managedObject())
                }
                completion?(true)
            }
        } catch {
            print(error.localizedDescription)
            completion?(false)
        }
    }
    
}
