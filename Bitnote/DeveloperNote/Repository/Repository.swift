import Foundation

protocol Repository {
    func getGroup(at index: Int) -> Group?
    func fetchGroups(completion: @escaping ([Group]) -> Void)
    func addGroup(title: String, completion: @escaping ([Group]?) -> Void)
    func deleteGroup(row: Int, completion: @escaping ([Group]?) -> Void)
    func editGroupTitle(target group: Group, title: String, completion: @escaping ([Group]?) -> Void)
}
