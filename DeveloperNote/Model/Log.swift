import UIKit


enum UnderstandLevel: Int {
    case low = 1 //이해도 낮음
    case middle = 3 // 중간
    case high = 7 // 높음
    
    var keyString: String {
        switch self {
        case .low:
            return "low"
        case .middle:
            return "middle"
        case .high:
            return "high"
        }
    }
    
    static func getLevelFromKeySting(key: String) -> Self {
        switch key {
        case UnderstandLevel.low.keyString:
            return UnderstandLevel.low
        case UnderstandLevel.middle.keyString:
            return UnderstandLevel.middle
        case UnderstandLevel.high.keyString:
            return UnderstandLevel.high
        default:
            return UnderstandLevel.high
        }
    }
}


struct Log {
    let uid: UID
    let ownerId: UID
    let createdAt: Date
    let understandLevel: UnderstandLevel

    public init(ownerId: UID, understandLevel: UnderstandLevel, createdAt: Date) {
        self.uid = UUID().uuidString
        self.ownerId = ownerId
        self.understandLevel = understandLevel
        self.createdAt = createdAt // 생성자에서 현재 시간을 바로 넣을지?
    }
}

extension Log: Persistable {
    /**
            RealmObject -> Struct
     */
    public init(managedObject: RealmLog) {
        self.uid = managedObject.uid
        self.ownerId = managedObject.ownerId
        self.createdAt = managedObject.createdAt
        self.understandLevel = .getLevelFromKeySting(key: managedObject.understandLevel)

    }
    
    /**
            Struct -> RealmObject
     */
    public func managedObject() -> RealmLog {
        let realm = RealmLog()
        realm.uid = self.uid
        realm.ownerId = self.ownerId
        realm.createdAt = self.createdAt
        realm.understandLevel = self.understandLevel.keyString
        return realm
    }
}
