//
//  GitHubUsersTests.swift
//  GitHubUsersTests
//
//  Created by Landon Mann on 4/2/24.
//

import XCTest
@testable import GitHubUsers

final class GitHubUsersTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetUsersFromGitHub() {
        let expectation = XCTestExpectation(description: "Fetch users from GitHub")
        
        Task.init {
            do {
                let users = try await GitHub().getUsers()
                XCTAssertNotNil(users, "Users array should not be nil")
                XCTAssertTrue(users.count > 0, "There should be at least one user")
            } catch {
                XCTFail("Error fetching users: \(error)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0) // Adjust the timeout as needed
    }
    
    func testGetUserFromGitHub() {
        let expectation = XCTestExpectation(description: "Fetch users from GitHub")
        
        Task.init {
            do {
                let user = try await GitHub().getDeatailedUser(login: "octocat")
                XCTAssertNotNil(user, "User should not be nil")
                XCTAssertTrue(user.name == "The Octocat", "There should be at least one user")
            } catch {
                XCTFail("Error fetching users: \(error)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0) // Adjust the timeout as needed
    }
    
}
