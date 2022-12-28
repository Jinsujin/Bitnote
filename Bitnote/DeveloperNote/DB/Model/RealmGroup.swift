import RealmSwift


@objcMembers
class RealmGroup: Object {
    dynamic var uid: UID = UUID().uuidString
    dynamic var title: String = ""
    let noteList = List<RealmNote>()
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}




