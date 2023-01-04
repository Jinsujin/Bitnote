import Foundation

protocol Repository {
    func getGroup(source groups: [Group], at index: Int) -> Group?
    func fetchGroups(completion: @escaping ([Group]) -> Void)
    func addGroup(source groups: [Group], title: String, completion: @escaping ([Group]?) -> Void)
    func deleteGroup(source groups: [Group], row: Int, completion: @escaping ([Group]?) -> Void)
    func editGroup(source groups: [Group], target id: UID, editTitle: String, completion: @escaping ([Group]?) -> Void)
}
