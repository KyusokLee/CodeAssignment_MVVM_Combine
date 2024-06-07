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
    
    @Published private(set) var isStarred: Bool = false
    @Published private(set) var repository: Repositories.Repository

    private let apiClient = APIClient()

    init(repository: Repositories.Repository) {
        self.repository = repository
    }

    /// POST・DELETE リクエストを送信し、repositoryにスターの付け・解除するメソッド
    func didTapStarButton() {
        let requestProtocol = GitHubStarRepositoryRequest(owner: repository.owner.userName, repository: repository.name, starStatus: !isStarred)
        apiClient.request(requestProtocol, type: .starRepository) { [weak self] result in
            switch result {
            case .success(_):
                guard let self else { return }
                // スター数を増減させる すでにスターが付いている場合は-1, これからスターをつける場合は+1する
                self.repository.stargazersCount += self.isStarred ? -1 : 1
                // スターの状態をtoggleする
                self.isStarred.toggle()
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
