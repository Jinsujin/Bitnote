import RealmSwift


@objcMembers
public class RealmLog: Object {
    dynamic var uid: UID = UUID().uuidString
    
    dynamic var ownerId: UID = UUID().uuidString
    dynamic var createdAt: Date = Date()
    dynamic var understandLevel:String = ""
    
    public override static func primaryKey() -> String? {
        return "uid"
    }
}
