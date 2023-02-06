import Foundation

protocol Repository {
    func pickGroup(in groups: [Group], at index: Int) -> Result<Group, Error>
    func fetchGroups() -> Result<[Group], Error>
    func addGroup(source groups: [Group], title: String) async -> Result<[Group], Error>
    func deleteGroup(source groups: [Group], row: Int) async -> Result<[Group] ,Error>
    func editGroup(source groups: [Group], target id: UID, editTitle: String) async -> Result<[Group], Error>
}
