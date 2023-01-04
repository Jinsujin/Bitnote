//
//  BitnoteTests.swift
//  BitnoteTests
//
//  Created by Sujin Jin on 2022/12/28.
//  Copyright © 2022 Tomatoma. All rights reserved.
//

import XCTest

class BitnoteTests: XCTestCase {
    
    var sut: GroupListViewModel!
    var mockRepository: MockRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.mockRepository = MockRepository()
        self.sut = GroupListViewModel(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRepository = nil
        
        try super.tearDownWithError()
    }

    func test_repositoryFetchData_compareCallCount() {
        let mockRepository = MockRepository()
        let expectResult = mockRepository.createItems()
        let expectation = XCTestExpectation()
        
        mockRepository.fetchGroups { groups in
            XCTAssertEqual(mockRepository.groupList.count, expectResult.count)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockRepository.fetchGroupsMethodCallCount, 1)
    }
    
    func test_GroupListViewModel_addNewGroup_fetchingGroups() {
        // given
        let createdItems = mockRepository.createItems()
        XCTAssertEqual(createdItems.count, 3)
        
        // when
        sut.addNewGroup("NewGroup")
        
        // then
        XCTAssertEqual(mockRepository.addGroupMethodCallCount, 1)
        XCTAssertEqual(mockRepository.groupList.count, 4)
    }
    
    func test_GroupListViewModel_whenEditGroupTitle_matchTitle() {
        // given
        mockRepository.groupList = [Group(title: "NewGroup")]
        
        // when
        let indexPath = IndexPath(row: 0, section: 0)
        let group = sut.getGroup(by: indexPath)
        XCTAssertNotNil(group)
        
        let editTitle = "Edited!"
        sut.editGroupTitle(group!, title: editTitle)
        
        // then
        XCTAssertEqual(mockRepository.editGroupTitleMethodCallCount, 1)
        
        let editedGroup = sut.getGroup(by: indexPath)
        XCTAssertNotNil(editedGroup)
        XCTAssertEqual(editedGroup!.title, editTitle)
    }
    
    func test_GroupListViewModel_whenDeleteGroup() {
        // given
        mockRepository.groupList = [Group(title: "NewGroup")]
        let indexPath = IndexPath(row: 0, section: 0)
        
        // when
        sut.deleteGroup(at: indexPath.row)
        
        // then
        XCTAssertEqual(mockRepository.deleteGroupMethodCallCount, 1)
        XCTAssertNil(sut.getGroup(by: indexPath))
    }
}


class MockRepository: Repository {

    // test property
    var getGroupMethodCallCount = 0
    var fetchGroupsMethodCallCount = 0
    var addGroupMethodCallCount = 0
    var deleteGroupMethodCallCount = 0
    var editGroupTitleMethodCallCount = 0
    
    var groupList: [Group] = []
    
    @discardableResult
    func createItems() -> [Group] {
        let items = [Group(title: "test1"),Group(title: "test2"),Group(title: "test3")]
        self.groupList = items
        return items
    }
    
    func getGroup(at index: Int) -> Group? {
        getGroupMethodCallCount += 1
        return groupList[safe: index]
    }
    
    func fetchGroups(completion: @escaping ([Group]) -> Void) {
        fetchGroupsMethodCallCount += 1
        completion(groupList)
    }
    
    func addGroup(source groups: [Group], title: String, completion: @escaping ([Group]?) -> Void) {
        let newGroup = Group(title: title)
        var sourceGroups = groups
        sourceGroups.append(newGroup)
        groupList.append(newGroup)
        addGroupMethodCallCount += 1
        completion(sourceGroups)
    }
    
    func deleteGroup(row: Int, completion: @escaping ([Group]?) -> Void) {
        groupList.remove(at: row)
        deleteGroupMethodCallCount += 1
        completion(groupList)
    }
    
    func editGroup(target id: UID, editTitle: String, completion: @escaping ([Group]?) -> Void) {
        editGroupTitleMethodCallCount += 1
        guard let index = groupList.firstIndex(where: { $0.id == id }) else {
            completion(nil)
            return
        }
        guard let originalIndex = groupList.firstIndex(where: { $0.id == id }) else {
            completion(nil)
            return
        }
        let originalGroup = groupList[originalIndex]
        groupList.remove(at: index)
        let updateGroup = Group(id: originalGroup.id, title: editTitle, notelist: originalGroup.notelist)
        groupList.insert(updateGroup, at: index)
    }
}
