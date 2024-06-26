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
struct Repositories: Hashable {
    /// 検索でマッチされたリポジトリの数
    let totalCount: Int
    /** リポジトリの詳細データが入っている配列形
    - 個々のリポジトリの情報が入っている配列
     */
    let items: [Repository]
    
    struct Repository: Hashable {
        var owner: RepositoryUser
        var name: String
        var description: String?
        var language: String?
        var stargazersCount: Int
        var watchersCount: Int
        var forksCount: Int
        var openIssuesCount: Int
        
        // computed properties (ex: 62300 -> 6.2万)
        var stringFormattedStargazersCount: String {
            stargazersCount >= Constants.numberFormatThreshold ? String(format: "%.1f万", Double(stargazersCount) / Double(Constants.numberFormatThreshold)) : String(stargazersCount)
        }

        struct RepositoryUser: Hashable {
            var userName: String
            var profileImageString: String
        }
    }
    
    init(repositories: RepositoriesResponse) {
        self.totalCount = repositories.totalCount
        /// mapメソッドを用いて配列型で渡す
        self.items = repositories.items.map { item in
                .init(
                    owner: .init(
                        userName: item.owner.login,
                        profileImageString: item.owner.avatarUrl
                    ),
                    name: item.name,
                    description: item.description,
                    language: item.language,
                    stargazersCount: item.stargazersCount,
                    watchersCount: item.watchersCount,
                    forksCount: item.forksCount,
                    openIssuesCount: item.openIssuesCount
                )
        }
    }
}
