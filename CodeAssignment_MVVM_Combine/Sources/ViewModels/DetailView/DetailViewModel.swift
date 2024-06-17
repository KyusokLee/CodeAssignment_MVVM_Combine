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
    /** 星付けの状態
    - PassthroughtSubjectからPublishedに変更
    - private(set)に設定し、クラスの外部では読み取りだけを可能にする
    - Subjectじゃなく、Publishedを使うと、sendメソッドを使わずに受け取る側(VC)で値の変更を検知可能
     */
    @Published private(set) var isStarred: Bool = false
    /// 詳細画面で扱うリポジトリ
    @Published private(set) var repository: Repositories.Repository

    /** initializerでリポジトリを持っておく
    - ViewModelにリポジトリデータを持っておき、データの加工をViewModel側で処理するようにする
     */
    init(repository: Repositories.Repository) {
        self.repository = repository
    }

    /** POST・DELETE リクエストを送信し、repositoryにスターの付け・解除するメソッド
    - ViewControllerのUIから持ってくるのではなく、モデルのデータを利用するようにする
     */
    func changeRepositoryStarStatus() {
        let request = GitHubStarRepositoryRequest(
            owner: repository.owner.userName,
            repository: repository.name,
            starStatus: !isStarred
        )
        apiClient.request(request, type: .starRepository) { [weak self] result in
            switch result {
            case .success(_):
                guard let self else { return }
                // リポジトリのスター数の更新 (星付け: 1, 星解除: -1)
                self.repository.stargazersCount += self.isStarred ? -1 : 1
                // スターの状態をtoggle
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
