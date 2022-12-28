//
//  BitnoteTests.swift
//  BitnoteTests
//
//  Created by Sujin Jin on 2022/12/28.
//  Copyright © 2022 Tomatoma. All rights reserved.
//

import XCTest

class BitnoteTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_repositoryFetchData_compareCount() {
        let mockRepository = MockRepository()
        let expectResult = mockRepository.createItems()
        let expectation = XCTestExpectation()
        
        mockRepository.fetchGroups { groups in
            XCTAssertEqual(mockRepository.groupList.count, expectResult.count)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}


class MockRepository: Repository {

    // test property
    var groupList: [Group] = []
    
    @discardableResult
    func createItems() -> [Group] {
        let items = [Group(title: "test1"),Group(title: "test2"),Group(title: "test3")]
        self.groupList = items
        return items
    }
    
    func getGroup(by indexPath: IndexPath) -> Group {
        return groupList[indexPath.row]
    }
    
    func fetchGroups(completion: @escaping ([Group]) -> Void) {
        completion(groupList)
    }
    
    func addGroup(title: String, completion: @escaping ([Group]?) -> Void) {
        let newGroup = Group(title: title)
        groupList.append(newGroup)
        completion(groupList)
    }
    
    func deleteGroup(row: Int, completion: @escaping ([Group]?) -> Void) {
        groupList.remove(at: row)
        completion(groupList)
    }
    
    func editGroupTitle(target group: Group, title: String, completion: @escaping ([Group]?) -> Void) {
        guard let index = groupList.firstIndex(where: { $0.id == group.id }) else {
            completion(nil)
            return
        }
        groupList.remove(at: index)
        let updateGroup = Group(original: group, uptatedTitle: title)
        groupList.insert(updateGroup, at: index)
    }
}
