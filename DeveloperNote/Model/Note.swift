import UIKit

enum NoteInputType {
    case text(String)
    case bookmark(String)
    case photoGallery(UIImage)
    case drawImage(UIImage)
    
    var keyString: String {
        switch self {
        case .text:
            return "text"
        case .bookmark(_):
            return "bookmark"
        case .photoGallery(_):
            return "photoGallery"
        case .drawImage(_):
            return "drawImage"
        }
    }
}

struct Note {
    var id: UID = UUID().uuidString
    var title: String
    var inputItems: [NoteInputType] = []
//    var reviewcount: Int // 학습 횟수
    var isDone: Bool // 공부 완료 여부
    var studyLogs: [Log]
    let createdAt: Date
    
    /// 새로 만들기 일때
    init(title: String, inputItems: [NoteInputType]) {
        self.title = title
        self.inputItems = inputItems
//        self.reviewcount = 0
        self.isDone = false
        self.studyLogs = []
        self.createdAt = Date()
    }
    
    /// note 수정일때
    init(id: UID, title: String, isDone: Bool, createdAt: Date, inputItems: [NoteInputType]){
        self.id = id
        self.title = title
        self.inputItems = inputItems
        self.isDone = isDone
        self.studyLogs = []
        self.createdAt = createdAt
    }

    func getTextString() -> String? {
        for item in inputItems {
            switch item {
            case .text(let str):
                return str
            default:
                return nil
            }
        }
        return nil
    }
    
    func getPhotoImage() -> UIImage? {
        for item in inputItems {
            switch item {
            case .photoGallery(let img):
                return img
            default:
                return nil
            }
        }
        return nil
    }
    
    func recentlyUpdatedLog() -> Log? {
        if let lastLog = studyLogs.sorted(by: {$0.createdAt > $1.createdAt}).first {
            return lastLog
        }
        return nil
    }
    
}
