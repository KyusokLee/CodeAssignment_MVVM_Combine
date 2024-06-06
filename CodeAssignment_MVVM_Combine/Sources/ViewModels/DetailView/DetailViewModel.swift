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
    
    /// POST・DELETE リクエストを送信し、repositoryにスターの付け・解除するメソッド
    func starRepository(owner: String, repo: String, starStatus: Bool) {
        let requestProtocol = GitHubStarRepositoryRequest(owner: owner, repository: repo, starStatus: starStatus)
        apiClient.request(requestProtocol, type: .starRepository) { result in
            switch result {
            case .success(_):
                starStatus ? self.starRepositorySubject.send(true) : self.starRepositorySubject.send(false)
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
