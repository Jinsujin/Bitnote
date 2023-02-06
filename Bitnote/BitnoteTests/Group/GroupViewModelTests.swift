import XCTest

class GroupViewModelTests: XCTestCase {
    
    var sut: GroupListViewModel!
    var mockRepository: MockGroupRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.mockRepository = MockGroupRepository()
        self.sut = GroupListViewModel(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRepository = nil
        
        try super.tearDownWithError()
    }

    func test_GroupListViewModel_fetchData_checkMethodCall() {
        let createdItems = mockRepository.createItems(count: 4)
        mockRepository.prepare(source: createdItems)
        sut.getGroups()
        XCTAssertEqual(mockRepository.fetchGroupsMethodCallCount, 2)
    }
    
    
    func test_GroupListViewModel_addNewGroup_checkMethodCall() async {
        // given
        let groupList = mockRepository.createItems(count: 4)
        mockRepository.prepare(source: groupList)
        sut.getGroups()

        // when
        await sut.addNewGroup("NewGroup1")
        await sut.addNewGroup("NewGroup2")
        
        // then
        XCTAssertEqual(mockRepository.addGroupMethodCallCount, 2)
        XCTAssertEqual(4+2, sut.groupListOb.value.count)
    }

    func test_GroupListViewModel_whenEditGroupTitle_shouldMatchTitle() async {
        // given
        let groupList = [Group(title: "NewGroup")]
        mockRepository.prepare(source: groupList)
        sut.getGroups()

        // when
        let indexPath = IndexPath(row: 0, section: 0)
        let group = sut.getGroup(by: indexPath)
        XCTAssertNotNil(group)

        let editTitle = "Edited!"
        await sut.editGroupTitle(group!, title: editTitle)

        // then
        XCTAssertEqual(mockRepository.editGroupTitleMethodCallCount, 1)

        let editedGroup = sut.getGroup(by: indexPath)
        XCTAssertNotNil(editedGroup)
        XCTAssertEqual(editedGroup!.title, editTitle)
    }

    func test_GroupListViewModel_whenDeleteGroup_shouldNil() async {
        // given
        let groupList = [Group(title: "NewGroup")]
        mockRepository.prepare(source: groupList)
        sut.getGroups()

        let indexPath = IndexPath(row: 0, section: 0)

        // when
        await sut.deleteGroup(at: indexPath.row)

        // then
        XCTAssertEqual(mockRepository.deleteGroupMethodCallCount, 1)
        XCTAssertNil(sut.getGroup(by: indexPath))
    }
}
