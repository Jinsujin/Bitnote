import UIKit


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
