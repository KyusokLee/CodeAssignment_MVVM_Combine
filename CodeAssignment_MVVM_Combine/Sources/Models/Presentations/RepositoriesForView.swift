//
//  RepositoryForView.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/13.
//

import Foundation

/** ViewControllerに渡す用のstruct Model。VCで表示させるViewに適用させるために、新しくModelを作成
 - Viewに表示するだけのModelを作ることで、APIを叩くときに余計にCoding Keysを使わなくてもいいし、テストもしやすくなるというメリットがある。
*/
struct RepositoriesForView {
    /// 検索でマッチされたリポジトリの数
    let totalCount: Int?
    /// リポジトリの詳細データが入っている配列形
    // 個々のリポジトリの情報が入っている配列
    let items: [RepositoryForView]
    
    struct RepositoryForView {
        var owner: RepositoryUserForView
        var name: String?
        var description: String?
        var language: String?
        var stargazersCount: Int?

        struct RepositoryUserForView {
            var login: String?
            var avatarUrl: String?
        }
    }
    
    init(totalCount: Int?, repositories: Repositories) {
        self.totalCount = totalCount
        /// mapメソッドを用いて配列型で渡す
        self.items = repositories.items.map { item in
                .init(owner: .init(login: item.owner.login, avatarUrl: item.owner.avatarUrl),
                      name: item.name,
                      description: item.description,
                      language: item.language,
                      stargazersCount: item.stargazersCount)
        }
    }
}
