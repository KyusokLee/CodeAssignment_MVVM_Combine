//
//  DetailViewModel.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/22.
//

import Foundation
import UIKit
import Combine

final class DetailViewModel {
    
    private let apiClient = APIClient()
    var starRepositorySubject = PassthroughSubject<Bool, Never>()
    var starRepositoryPublisher: AnyPublisher<Bool, Never> {
        return starRepositorySubject.eraseToAnyPublisher()
    }
    
    /// POST リクエストを送信し、repositoryにスターをつけるメソッド
    func starRepository(owner: String, repo: String) {
        let requestProtocol = GitHubSearchRepositoriesRequest(searchQueryWord: "")
        apiClient.request(requestProtocol, type: .starRepository(owner: owner, repo: repo)) { result in
            switch result {
            case .success(_):
                self.starRepositorySubject.send(true)
            case let .failure(error):
                switch error {
                case .apiServerError:
                    print(error.errorTitle)
                case .noResponseError:
                    print(error.errorTitle)
                case .decodeError:
                    print(error.errorTitle)
                case .unknownError:
                    print(error.errorTitle)
                }
            }
        }
    }
    
    /// DELETE リクエストを送信し、repositoryにスターをつけるメソッド
    func unstarRepository(owner: String, repo: String) {
        let requestProtocol = GitHubSearchRepositoriesRequest(searchQueryWord: "")
        apiClient.request(requestProtocol, type: .unstarRepository(owner: owner, repo: repo)) { result in
            switch result {
            case .success(_):
                self.starRepositorySubject.send(false)
            case let .failure(error):
                switch error {
                case .apiServerError:
                    print(error.errorTitle)
                case .noResponseError:
                    print(error.errorTitle)
                case .decodeError:
                    print(error.errorTitle)
                case .unknownError:
                    print(error.errorTitle)
                }
            }
        }
    }
}
