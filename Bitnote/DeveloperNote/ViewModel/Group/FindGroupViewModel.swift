import Foundation
import RxSwift

final class FindGroupViewModel {
    public var groupDataList: [Group] = []
    
    init(){
        fetchGroupFromDB()
    }
    
    func fetchGroupFromDB(){
        
        do {
            let fetchResults = try RealmManager.fetchObjects(Group.self)
            self.groupDataList = fetchResults
            
            // TODO:- 학습횟수 최대 5로 설정했을때, 5이하인 노트만 가지고 온다
//            let groups = fetchObjects.compactMap({ Group(managedObject: $0) })
//            for g in groups {
//                var resultGroup = g
//                let filter5underReviewcount = g.notelist?.filter({ $0.reviewcount < 5 })
//                resultGroup.notelist = filter5underReviewcount
//                groupDataList.append(resultGroup)
//            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


