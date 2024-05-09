//
//  HomeViewModel.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/07.
//

import Foundation
import UIKit
import Combine

final class HomeViewModel {
    private let apiClient = APIClient()
    /// HomeViewController側で監視しているSubject
    var repositoriesSubject = PassthroughSubject<[Repository], Never>()
    /// AnyPublisher：他のTypeでwrapしたものをなくして、AnyPublisherで返す
    var repositoriesPublisher: AnyPublisher<[Repository], Never> {
        return repositoriesSubject.eraseToAnyPublisher()
    }
    
    /// GET リクエストを送信し、repositoryを持ってくるメソッド
    func didTapGetAPIButton() {
        let requestProtocol = GitHubSearchRepositoriesRequest(searchQueryWord: "Swift")
        apiClient.request(requestProtocol, type: GitHubAPIType.searchRepositories) { result in
            switch result {
            case let .success(model):
                guard let repositories = model?.items else { return }
                // Subjectを通して、データを送る
                self.repositoriesSubject.send(repositories)
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
