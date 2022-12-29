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
    
    func getGroup(by indexPath: IndexPath) -> Group {
        getGroupMethodCallCount += 1
        return groupList[indexPath.row]
    }
    
    func fetchGroups(completion: @escaping ([Group]) -> Void) {
        fetchGroupsMethodCallCount += 1
        completion(groupList)
    }
    
    func addGroup(title: String, completion: @escaping ([Group]?) -> Void) {
        let newGroup = Group(title: title)
        groupList.append(newGroup)
        addGroupMethodCallCount += 1
        completion(groupList)
    }
    
    func deleteGroup(row: Int, completion: @escaping ([Group]?) -> Void) {
        groupList.remove(at: row)
        deleteGroupMethodCallCount += 1
        completion(groupList)
    }
    
    func editGroupTitle(target group: Group, title: String, completion: @escaping ([Group]?) -> Void) {
        editGroupTitleMethodCallCount += 1
        guard let index = groupList.firstIndex(where: { $0.id == group.id }) else {
            completion(nil)
            return
        }
        groupList.remove(at: index)
        let updateGroup = Group(original: group, uptatedTitle: title)
        groupList.insert(updateGroup, at: index)
    }
}
