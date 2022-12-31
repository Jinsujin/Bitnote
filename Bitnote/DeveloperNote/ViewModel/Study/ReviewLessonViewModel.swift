import Foundation


class ReviewLessonViewModel {
    private var noteList: [Note] = []
    
    init() {}
    
    /// 복습해야 하는 노트리스트 반환
    func getNoteList() -> [Note] {
        guard let noteList = fetchNoteList() else {
            return []
        }
        
        return noteList
    }
    
    
    /**
     복습해야 하는 노트 리스트 반환
     
     1. NoteList 의 로그list 루프 돌면서, 마지막에 등록한 로그를 가져온다
     2. 로그의 "등록 날짜+level 일수" 와, 오늘날짜 비교
     00:00 시를 기준으로 리셋 (나중에 설정에서 변경할 수 있게 할것)
     - low: 1일 후
     -  middle: 3일 후
     - high: 7일 후
     */
    private func fetchNoteList() -> [Note]? {
        guard let realm = RealmManager.realm() else {
            return nil
        }
        
        var result: [Note] = []
        let fetchNoteList = realm.objects(RealmNote.self).filter("isDone == %@", false)
         
        let today = Date()
        let oneDay: TimeInterval = (60 * 60 * 24)
        
        for note in fetchNoteList {
            if let lastLog = note.studyLogs.sorted(by: {$0.createdAt > $1.createdAt}).first {
                let level = UnderstandLevel.getLevelFromKeySting(key: lastLog.understandLevel)
                let addDay = TimeInterval(oneDay * Double(level.rawValue))
                
                // 오늘의 날짜 VS 마지막로그시간 + 레벨날짜
                let reviewDay = lastLog.createdAt.addingTimeInterval(addDay)
                
                let betweenSec = today.startOfDay().timeIntervalSince(reviewDay.startOfDay())
                if (betweenSec < 0) { continue }
                result.append(Note(managedObject: note))
            }
        }
        return result
    }
}
