//
//  Untitled.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by kyusok.lee on 2025/02/25.
//

import XCTest
import Combine
@testable import CodeAssignment_MVVM_Combine

final class HomeViewModelTests: XCTestCase {
    private var viewModel: HomeViewModel!
    private var mockAPIClient: MockAPIClient!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        viewModel = HomeViewModel(apiClient: mockAPIClient)
    }

    override func tearDown() {
        viewModel = nil
        mockAPIClient = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testSearchSuccess() {
        let expectation = XCTestExpectation(description: "Search success")
        let mockRepositories = RepositoriesResponse(
            totalCount: 1,
            items: [
                RepositoriesResponse.RepositoryResponse(
                    owner: .init(login: "testUser", avatarUrl: "https://example.com/avatar.png"),
                    name: "TestRepo",
                    description: "Test description",
                    language: "Swift",
                    stargazersCount: 10,
                    forksCount: 5,
                    watchersCount: 3,
                    openIssuesCount: 1
                )
            ]
        )

        mockAPIClient.result = .success(mockRepositories)

        viewModel.repositoriesPublisher
            .dropFirst()
            .sink { repositories in
                XCTAssertNotNil(repositories)
                XCTAssertEqual(repositories?.repositories.totalCount, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.search(queryString: "Swift")

        wait(for: [expectation], timeout: 2.0)
    }

    func testSearchFailure() {
        let expectation = XCTestExpectation(description: "Search failure")
        mockAPIClient.result = .failure(.apiServerError)

        viewModel.repositoriesPublisher
            .dropFirst()
            .sink { repositories in
                XCTAssertNil(repositories)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.search(queryString: "Swift")

        wait(for: [expectation], timeout: 2.0)
    }
}

// モックAPIクライアントの作成
final class MockAPIClient: APIClient {
    // 型を固定せず汎用的に保持
    var result: Any?

    override func request<T: GitHubAPIClientProtocol>(_ requestProtocol: T, type: GitHubAPIType, completion: @escaping (Result<T.Model?, ErrorType>) -> Void) {
        if let result = result as? Result<T.Model?, ErrorType> {
            completion(result)
        }
    }
}

