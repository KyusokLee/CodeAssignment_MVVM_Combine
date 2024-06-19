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
    /// Loading 状態を指すSubject
    var loadingSubject = CurrentValueSubject<Bool, Never>(false)
    /// ReadyViewの表示状態を指すSubject
    var readyViewSubject = PassthroughSubject<Bool, Never>()
    /// AnyPublisher：他のTypeでwrapしたものをなくして、AnyPublisherで返す
    var repositoriesPublisher: AnyPublisher<Repositories?, Never> {
        return repositoriesSubject.eraseToAnyPublisher()
    }
    
    /// GET リクエストを送信し、repositoryを持ってくるメソッド
    func search(queryString searchWord: String) {
        // 空文字や空白のみの文字列の検索を防ぐために、トリミングされた検索文字列が空でないことを確認
        let trimmedQuery = searchWord.trimmingCharacters(in: .whitespacesAndNewlines)
        // 空白の検索を防ぐ
        guard !trimmedQuery.isEmpty else { return }
        // loading状態をTrueに変更
        loadingSubject.send(true)

        let requestProtocol = GitHubSearchRepositoriesRequest(searchQueryWord: trimmedQuery)
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
            self.readyViewSubject.send(false)
            // Request処理後は、loading状態をFalseに戻す
            self.loadingSubject.send(false)
        }
    }
}
