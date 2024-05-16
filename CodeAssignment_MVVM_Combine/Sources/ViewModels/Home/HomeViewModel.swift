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
    /** HomeViewController側に渡すSubject（通路ってイメージ）
     - PassThroughSubjectは、値を保持しないので、CurrentValueSubjectを通してVCに値を渡す
     - RepositoriesForViewはただ、HomeViewControllerに渡す用のModelである
     */
    var repositoriesSubject = CurrentValueSubject<Repositories?, Never>(nil)
    /// AnyPublisher：他のTypeでwrapしたものをなくして、AnyPublisherで返す
    var repositoriesPublisher: AnyPublisher<Repositories?, Never> {
        return repositoriesSubject.eraseToAnyPublisher()
    }
    
    /// GET リクエストを送信し、repositoryを持ってくるメソッド
    func search(queryString searchWord: String) {
        let requestProtocol = GitHubSearchRepositoriesRequest(searchQueryWord: searchWord)
        apiClient.request(requestProtocol, type: GitHubAPIType.searchRepositories) { result in
            switch result {
            case let .success(repositories):
                // model: API側から持ってくるRepositories
                guard let repositories else { return }
                // VCに渡す用のinstance
                let repositoriesView = Repositories(repositories: repositories)
                // subjectを通してModelを送る
                self.repositoriesSubject.send(repositoriesView)
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
