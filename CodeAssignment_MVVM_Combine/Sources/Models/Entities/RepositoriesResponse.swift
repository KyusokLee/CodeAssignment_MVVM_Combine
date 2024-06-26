//
//  Repository.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/08.
//

import Foundation


/** Repositoryから取りたい値だけをModelとして設定
- リポジトリ名(path含めないやつ)、リポジトリのdescription、スター数、language、プロフィール画像、UserNameを表示したい
- itemsの中にRepositoryのデータが入っている構造
- itemsの中のownerの中に特定したuserのデータが格納されている
- 言語は、今後色もつけて画面に表示したい
- APIで定義したKeyの名前を変えたのは、ViewControllerとかでそのkeyのデータを用いるとき、わかりやすくするためである。そのため、decodingのStrategyは自動で変換されるメソッドを使うのが良さそう
- 参考URL : https://docs.github.com/ja/rest/search/search?apiVersion=2022-11-28#search-repositories
*/
struct RepositoriesResponse: Codable {
    /// queryに当てはまる結果の数
    let totalCount: Int
    /// リポジトリの詳細データが入っている配列形
    let items: [RepositoryResponse]
    
    struct RepositoryResponse: Codable {
        var owner: RepositoryUserResponse
        var name: String
        var description: String?
        var language: String?
        var stargazersCount: Int
        var forksCount: Int
        var watchersCount: Int
        var openIssuesCount: Int
        
        /// decodeのkeyDecodingStrategyメソッドを用いて、convertFromSnakeCaseで自動的に変換されるstructの中身にしておく
        struct RepositoryUserResponse: Codable {
            var login: String
            var avatarUrl: String
        }
    }
}
