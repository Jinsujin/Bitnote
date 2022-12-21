import RealmSwift

@objcMembers
class RealmNote: Object {
    dynamic var uid: UID = UUID().uuidString
    dynamic var title: String = ""
    dynamic var isDone: Bool = false
    dynamic var createdAt: Date = Date()
    
    // note 내용 리스트
    let inputItems = List<RealmNoteInputItem>()
    
    let group = LinkingObjects(fromType: RealmGroup.self, property: "noteList")
    
    let studyLogs = List<RealmLog>()
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}

@objcMembers
class RealmNoteInputItem: Object {
    dynamic var type = ""
    dynamic var text = ""
    dynamic var imageData: Data? = nil
}
