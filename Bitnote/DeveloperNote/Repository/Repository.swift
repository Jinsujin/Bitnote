import Foundation

protocol Repository {
    func getGroup(at index: Int) -> Group?
    func fetchGroups(completion: @escaping ([Group]) -> Void)
    func addGroup(title: String, completion: @escaping ([Group]?) -> Void)
    func deleteGroup(row: Int, completion: @escaping ([Group]?) -> Void)
    func editGroup(target id: UID, editTitle: String, completion: @escaping ([Group]?) -> Void)
}
