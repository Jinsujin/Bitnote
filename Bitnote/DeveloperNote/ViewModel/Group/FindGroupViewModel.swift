import Foundation
import RxSwift

class FindGroupViewModel {
    public var groupDataList: [Group] = []
    
    /**
     초기화

     */
    init(){
        fetchGroupFromDB()
    }
    
    func fetchGroupFromDB(){
        if let realm = RealmManager.realm() {
            let fetchObjects = realm.objects(RealmGroup.self)
            self.groupDataList = fetchObjects.compactMap({ Group(managedObject: $0)})
            
            // todo: 학습횟수 최대 5로 설정했을때, 5이하인 노트만 가지고 온다
//            let groups = fetchObjects.compactMap({ Group(managedObject: $0) })
//            for g in groups {
//                var resultGroup = g
//                let filter5underReviewcount = g.notelist?.filter({ $0.reviewcount < 5 })
//                resultGroup.notelist = filter5underReviewcount
//                groupDataList.append(resultGroup)
//            }
        }
    }
    
}


