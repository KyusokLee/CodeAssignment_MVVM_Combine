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
    /// HomeViewController側に渡すSubject（通路ってイメージ）
    // RepositoriesForViewはただ、HomeViewControllerに渡す用のModelである
    var repositoriesSubject = PassthroughSubject<RepositoriesForView, Never>()
    /// AnyPublisher：他のTypeでwrapしたものをなくして、AnyPublisherで返す
    var repositoriesPublisher: AnyPublisher<RepositoriesForView, Never> {
        return repositoriesSubject.eraseToAnyPublisher()
    }
    
    /// GET リクエストを送信し、repositoryを持ってくるメソッド
    func didTapGetAPIButton() {
        let requestProtocol = GitHubSearchRepositoriesRequest(searchQueryWord: "Swift")
        apiClient.request(requestProtocol, type: GitHubAPIType.searchRepositories) { result in
            switch result {
            case let .success(model):
                // model: API側から持ってくるRepositories
                guard let model else { return }
                // VCに渡す用のinstance
                let repositories = RepositoriesForView(totalCount: model.totalCount, repositories: model.self)
                // subjectを通してModelを送る
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
