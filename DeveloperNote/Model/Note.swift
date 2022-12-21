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
    init(title: String, inputItems: [NoteInputType]){
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



// MARK:- Persistable Protocol
extension Note: Persistable {
    /**
            RealmObject -> Struct
     */
    public init(managedObject: RealmNote) {
        self.id = managedObject.uid
        self.title = managedObject.title
        self.createdAt = managedObject.createdAt
        self.isDone = managedObject.isDone
        self.inputItems = managedObject.inputItems.map({ realmObject in
            switch realmObject.type {
            case "text":
                return NoteInputType.text(realmObject.text)
            case "bookmark":
                return NoteInputType.bookmark(realmObject.text)
            case "photoGallery":
                let img = (realmObject.imageData != nil) ? UIImage(data: realmObject.imageData ?? Data()) : UIImage()
                return NoteInputType.photoGallery(img ?? UIImage())
            case "drawImage":
                let img = (realmObject.imageData != nil) ? UIImage(data: realmObject.imageData ?? Data()) : UIImage()
                return NoteInputType.drawImage(img ?? UIImage())
            default:
                return NoteInputType.text(realmObject.text)
            }
        })
        self.studyLogs = []
    }
    
    /**
            Struct -> RealmObject
     */
    public func managedObject() -> RealmNote {
        let realm = RealmNote()
        realm.uid = self.id
        realm.title = self.title
        realm.createdAt = self.createdAt
        realm.isDone = self.isDone
        realm.inputItems.append(objectsIn: self.inputItems.map { self.convertInputEnum_to_realmObject($0) })
        realm.studyLogs.append(objectsIn: self.studyLogs.map { $0.managedObject() })
        return realm
    }
    
    private func convertInputEnum_to_realmObject(_ enumData: NoteInputType) -> RealmNoteInputItem {
        let object = RealmNoteInputItem()
        object.type = enumData.keyString
        switch enumData {
            case .text(let text):
                object.text = text
            break
            case .bookmark(let text):
                object.text = text
                break
            case .photoGallery(let image):
                object.imageData = image.jpegData(compressionQuality: 0.1)
                break
            case .drawImage(let image):
                object.imageData = image.jpegData(compressionQuality: 0.1)
                break
            }
        return object
    }
}
