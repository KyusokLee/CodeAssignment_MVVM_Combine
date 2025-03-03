//
//  HomeViewModelTests.swift
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
    private var cancellables = Set<AnyCancellable>()

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
            // CurrentValueSubject や @Published は、subscribe（購読）した瞬間に現在の値を流す 仕様になっている
            // 購読した瞬間に現在の値（デフォルト値）を流す
            // search を呼ぶ前のデフォルト値 を最初に受け取る
            // デフォルト値をスキップして、本当に API のレスポンスが反映された値だけをチェック
            // dropFirstを使って、意図しない初期値が sink に流れてくることを防ぐ
            .dropFirst()
            .sink(receiveValue: { repositories in
                XCTAssertNotNil(repositories)
                // (実際の値、期待値) 2つの値が等しいことを確認するために使う
                XCTAssertEqual(repositories?.totalCount, 1)
                // 非同期処理が完了したことを XCTest に伝える
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.search(queryString: "Swift")

        wait(for: [expectation], timeout: 2.0)
    }

    func testSearchFailure() {
        let expectation = XCTestExpectation(description: "Search failure")
        mockAPIClient.result = .failure(.apiServerError)

        viewModel.repositoriesPublisher
            .sink { repositories in
                // repositories が nil であることを確認する
                XCTAssertNil(repositories)
                // 非同期処理が完了したことを XCTest に伝える
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.search(queryString: "Swift")
        wait(for: [expectation], timeout: 2.0)
    }
}

// モックAPIクライアントの作成
final class MockAPIClient: APIClient {
    var result: Result<Any?, ErrorType>?

    override func request<T: GitHubAPIClientProtocol>(
        _ requestProtocol: T,
        type: GitHubAPIType,
        completion: @escaping (Result<T.Model?, ErrorType>) -> Void
    ) {
        guard let result = result else {
            completion(.failure(.unknownError))
            return
        }

        switch result {
        case .success(let data):
            if let model = data as? T.Model {
                completion(.success(model))
            } else {
                completion(.failure(.decodeError))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

